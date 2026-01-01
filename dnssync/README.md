# dnssync

Syncs docker container names to public DNS (route53).

These will be the private (RFC 1932) container IPs, published in public A records below $LAN_DNS_SUFFIX.
This isn't really a big privacy problem, and it makes it easier to work with VPN setups where local/LAN DNS servers might not be reachable or local DNS client config might be overridden by the VPN setup.