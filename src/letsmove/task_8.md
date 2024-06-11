# task8

为了不影响比赛，解题过程等一段时间再放上来

```
#!/bin/bash

PackageID=0x097a3833b6b5c62ca6ad10f0509dffdadff7ce31e1d86e63e884a14860cedc0f
Challenge_Object=0x19e76ca504c5a5fa5e214a45fca6c058171ba333f6da897b82731094504d5ab9

github_id="m4sk93"
# 0xe7c6000000000000
proof="[0xe7,0xc6,0,0,0,0,0,0]"
rand="0x8"

sui client call --package $PackageID \
                --module lets_move \
                --function get_flag \
                --args $proof $github_id $Challenge_Object $rand
```
Transaction Digest: 7uCNDToLAkLm7Ks1bUJirqNRjNrZ2vCbwyYEvFUHGuB9

