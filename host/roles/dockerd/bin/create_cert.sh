#!/bin/sh

set -e

usage() {
    cat >&2 <<-EOS
usage: `basename $0` [-c CN] [-d DAYS] [-a ALTNAMES] [-s SIGNER] [-e EXTKEYUSAGE] OUTFILE

Create certificate OUTFILE.pem/OUTFILE-key.pem, with cn CN (default
"My CA"), subjectAltName ALTNAMES (provide the full string,
e.g. "DNS:*.myorg.com,IP:10.10.10.20", default empty), valid for DAYS
(default 3650), signed by SIGNER.pem/SIGNER-key.pem (default:
self-signed).

EOS
    exit 1
}

cn='My CA'
days=3650

while getopts 'c:d:a:s:e:' OPTNAME; do
case "$OPTNAME" in
    "c")
        cn="$OPTARG" ;;
    "d")
        days="$OPTARG" ;;
    "a")
        alt_names="$OPTARG" ;;
    "s")
        signer="$OPTARG" ;;
    "e")
        ext_key_usage="$OPTARG" ;;
    "?")
        usage ;;
esac
done

shift $(($OPTIND - 1))

subj="/CN=$cn"

outfile="$1"

if [ -z "$outfile" ]; then
    usage;
fi

mkdir -p "$(dirname $outfile)"

openssl genrsa -out "${outfile}-key.pem" 4096

extfile="$(mktemp)"
trap "rm -f $extfile" EXIT

if [ -n "$alt_names" ]; then
    echo "subjectAltName = $alt_names" >>"$extfile"
    extopt="-extfile $extfile"
fi

if [ -n "$ext_key_usage" ]; then
    echo "extendedKeyUsage = $ext_key_usage" >>"$extfile"
    extopt="-extfile $extfile"
fi

if [ -z "$signer" ]; then

    # self-signed
    openssl req \
        -new \
        -x509 \
        -days "$days" \
        -subj "$subj" \
        -key "${outfile}-key.pem" \
        -addext "basicConstraints=critical,CA:true" \
        -addext "keyUsage=critical,digitalSignature,cRLSign,keyCertSign" \
        $extopt \
        -sha256 \
        -out "${outfile}.pem";

else

    # signed by $signer
    openssl req -new -subj "$subj" -key "${outfile}-key.pem" -sha256 -out "${outfile}.csr"

    openssl x509 -req -days "$days" -sha256 -in "${outfile}.csr" -CA "${signer}.pem" -CAkey "${signer}-key.pem" -CAcreateserial -out "${outfile}.pem" $extopt

fi
