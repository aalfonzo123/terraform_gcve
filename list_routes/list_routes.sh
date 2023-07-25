#!/bin/bash

# Copyright 2023 Google. This software is provided as-is, without warranty or representation for any use or purpose.
# Your use of it is subject to your agreement with Google. 

echo "--- all psa ranges"
gcloud compute addresses list --global --filter="purpose=VPC_PEERING" --format="csv[no-heading][separator="/"](address,prefixLength)"

echo "--- all static routes (excluding default internet gateway)"
gcloud compute routes list --format="value(dest_range)" --filter="nextHopGateway!=default-internet-gateway"

for routerInfo in $(gcloud compute routers list --format="csv[no-heading](name,region,network)")
do
    IFS=',' read -r -a infoArray<<< "$routerInfo"
    name="${infoArray[0]}"
    region="${infoArray[1]}"

    echo "--- dynamic routes on $name"
    ranges=$(gcloud compute routers get-status $name --region=$region --format="value(result.bestRoutes[].destRange)")
    echo -e ${ranges//;/'\n'}
done

