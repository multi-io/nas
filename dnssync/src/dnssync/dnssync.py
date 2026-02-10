import argparse
import json
import os
from pathlib import Path
from typing import Optional

import boto3
from botocore.exceptions import ClientError
import docker
from docker.models.containers import Container

PUBNET_NAME_SUFFIX = "_pubnet"
PROXY_CONTAINER_NAME_SUFFIX = "-proxy-1"

def get_container_ip_in_network(container: Container, network_name: str) -> Optional[str]:
    networks = container.attrs.get("NetworkSettings", {}).get("Networks", {})
    net_info = networks.get(network_name)
    if not net_info:
        return None
    ip_address = net_info.get("IPAddress")
    return ip_address or None

def get_hosted_zone_id_for_dns_name(route53, dns_name: str) -> str:
    paginator = route53.get_paginator("list_hosted_zones")
    for page in paginator.paginate():
        for zone in page.get("HostedZones", []):
            zone_name = zone.get("Name", "")
            if zone_name == dns_name:
                return zone["Id"].split("/")[-1]
    raise RuntimeError(f"No hosted zone found for {dns_name}")

def upsert_a_record(
    route53,
    zone_id: str,
    record_name: str,
    ip_address: str,
    ttl: int,
) -> None:
    route53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            "Comment": "dnssync update",
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": record_name,
                        "Type": "A",
                        "TTL": ttl,
                        "ResourceRecords": [{"Value": ip_address}],
                    },
                }
            ],
        },
    )


def load_cache(path: Path) -> dict[str, str]:
    """Load FQDN -> IP cache from JSON file. Returns empty dict on missing/invalid file."""
    if not path.exists():
        return {}
    try:
        data = json.loads(path.read_text())
        if not isinstance(data, dict):
            return {}
        return {k: str(v) for k, v in data.items() if isinstance(v, str)}
    except (OSError, json.JSONDecodeError):
        return {}


def save_cache(path: Path, data: dict[str, str]) -> None:
    """Write FQDN -> IP cache to JSON file. Creates parent directory if needed."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, sort_keys=True) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser(description="Sync Docker container DNS to Route53.")
    parser.add_argument(
        "--compose-project",
        type=str,
        default=os.environ.get("COMPOSE_PROJECT_NAME", "nas"),
        help="Docker Compose project name.",
    )
    parser.add_argument(
        "--lan-dns-suffix",
        type=str,
        default=os.environ.get("LAN_DNS_SUFFIX"),
        help="LAN DNS suffix.",
    )
    parser.add_argument(
        "--ttl",
        type=int,
        default=int(os.environ.get("DNS_TTL", "1200")),
        help="DNS TTL in seconds.",
    )
    parser.add_argument(
        "--route53-zone-id",
        type=str,
        default=os.environ.get("ROUTE53_ZONE_ID"),
        help="Route53 zone ID. Default: derived from LAN_DNS_SUFFIX.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        default=os.environ.get("DRY_RUN", "false").lower() in {"1", "true", "yes", "y", "on"},
        help="Print intended DNS changes without applying them.",
    )
    parser.add_argument(
        "--cache-file",
        type=Path,
        default=os.environ.get("DNSSYNC_CACHE_FILE", "/var/cache/dnssync/records.json"),
        help="Path to JSON file caching last-written DNS records (FQDN -> IP).",
    )
    args = parser.parse_args()

    if not args.lan_dns_suffix:
        raise RuntimeError("LAN_DNS_SUFFIX is required")

    args.lan_dns_suffix = args.lan_dns_suffix.rstrip(".")

    route53 = boto3.client("route53")

    zone_id = args.route53_zone_id
    if not zone_id:
        zone_id = get_hosted_zone_id_for_dns_name(route53, args.lan_dns_suffix)

    docker_client = docker.from_env()

    pubnet_name = f"{args.compose_project}{PUBNET_NAME_SUFFIX}"
    proxy = docker_client.containers.get(f"{args.compose_project}{PROXY_CONTAINER_NAME_SUFFIX}")
    proxy_ip = get_container_ip_in_network(proxy, pubnet_name)
    if not proxy_ip:
        raise RuntimeError(f"Proxy container has no IP in {pubnet_name}")

    cache_path = Path(args.cache_file)
    cache: dict[str, str] = {}
    cache_modified = False
    if not args.dry_run:
        cache = load_cache(cache_path)

    for container in docker_client.containers.list(filters={"label": f"com.docker.compose.project={args.compose_project}"}):
        if container.labels.get("de.olaf-klischat.nas.no-dns-sync") == "true":
            print(f"Skipping {container.name}: no-dns-sync label set")
            continue

        hostname = container.attrs.get("Config", {}).get("Hostname")
        if not hostname:
            print(f"Skipping {container.name}: no hostname")
            continue

        container_ip = get_container_ip_in_network(container, pubnet_name)
        target_ip = container_ip or proxy_ip
        fqdn = f"{hostname}.{args.lan_dns_suffix}"

        if args.dry_run:
            print(f"DRY-RUN: would update {fqdn} -> {target_ip}")
            continue

        if cache.get(fqdn) == target_ip:
            continue

        try:
            upsert_a_record(route53, zone_id, fqdn, target_ip, args.ttl)
        except ClientError as exc:
            print(f"Failed to update {fqdn} -> {target_ip}: {exc}")
            continue

        cache[fqdn] = target_ip
        cache_modified = True
        print(f"Updated {fqdn} -> {target_ip}")

    if cache_modified:
        save_cache(cache_path, cache)


if __name__ == "__main__":
    main()

# TODO delete DNS records for containers that no longer exist