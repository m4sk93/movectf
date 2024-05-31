#!/bin/bash

PackageID=0x8f8419fea2c11e7cb29f26819c24f8dfb2106a3d9dc7a72501321d3bee2ffb61

Flashlender=0xa2431d0b8ab54690234a57d100f514f04823789c8892428ac87634e9eb304a05

#sui client call --package $PackageID \
#                --module exp \
#                --function exp1 \
#                --args $Flashlender


sui client call --package $PackageID \
                --module exp \
                --function exp2 \
                --args $Flashlender

## exp2 only once
## https://suiscan.xyz/testnet/object/0xa2431d0b8ab54690234a57d100f514f04823789c8892428ac87634e9eb304a05
