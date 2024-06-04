#!/bin/bash

PackageID=0x877e3cafcdf3570eeef8bd9623460ca18af09c4b20293102bcc16526d0d204f4

vault=0x9bba41769c3a34cea974aa45ea9c4cbd7947005e22f7356888cac67f3d9754ef
coina=0xfe1791ffe2809cdf29aa1142c3e98375cf2f5d9cb73b94bd801be81193fdf212

a_type='0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a::ctfa::CTFA'
b_type='0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a::ctfb::CTFB'

sui client call --package $PackageID \
                --module exp \
                --function exp1 \
                --type-args $a_type $b_type \
                --args $vault $coina

