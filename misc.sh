#!/bin/bash

# Store networks in array if provided, otherwise leave empty
networks=("$@")
NETWORKS_URL="${NETWORKS_URL:-https://raw.githubusercontent.com/rhinestonewtf/constants/refs/heads/main/networks.txt}"
echo "NETWORKS_URL: $NETWORKS_URL"

while IFS='=' read -r network url; do
    # Skip empty lines and comments
    [[ -z $network || $network == \#* ]] && continue
    # Skip if networks specified and current one not included
    [[ ${#networks[@]} -gt 0 && ! " ${networks[@]} " =~ " ${network} " ]] && continue

    expanded_url=$(echo "$url" | envsubst)

    # Check required addresses
    # Safe Singleton Factory
    code=$(cast code 0x914d7Fec6aaC8cd542e72Bca78B30650d45643d7 --rpc-url "$expanded_url")
    if [ "$code" == "0x" ]; then
        printf '%s\n' "Error: Safe Singleton Factory not deployed" >&2
        exit 1
    fi

    # Counter 
    code=$(cast code 0x19575934a9542be941d3206f3ecff4a5ffb9af88 --rpc-url "$expanded_url")
    if [ "$code" == "0x" ]; then
        cast send 0x914d7Fec6aaC8cd542e72Bca78B30650d45643d7 0xdb37925934a3d3177db64e11f5e0156ceb8a756fee58ded16e549afa607ddb1d6080604052348015600e575f5ffd5b506101578061001c5f395ff3fe608060405234801561000f575f5ffd5b506004361061003f575f3560e01c80633fb5c1cb14610043578063b154be8514610064578063d09de08a14610095575b5f5ffd5b6100626100513660046100b9565b335f90815260208190526040902055565b005b6100836100723660046100d0565b5f6020819052908152604090205481565b60405190815260200160405180910390f35b610062335f9081526020819052604081208054916100b2836100fd565b9190505550565b5f602082840312156100c9575f5ffd5b5035919050565b5f602082840312156100e0575f5ffd5b81356001600160a01b03811681146100f6575f5ffd5b9392505050565b5f6001820161011a57634e487b7160e01b5f52601160045260245ffd5b506001019056fea264697066735822122037e70cd5ede78d5172136046e5d28d898aafd03c8ccee26bdb7fa993836ba39f64736f6c634300081c0033 --rpc-url "$expanded_url" --private-key "$PRIVATE_KEY"
    fi
    printf '\e]8;;https://contractscan.xyz/contract/0x19575934a9542be941d3206f3ecff4a5ffb9af88\e\\Counter successfully deployed\e]8;;\e\\\n'

done < <(curl -s "$NETWORKS_URL")
