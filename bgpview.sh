curl -s https://api.bgpview.io/ip/$1 | jq -r ".data.prefixes[] | {prefixes: .prefixes, ASN: .asn.asn}"
