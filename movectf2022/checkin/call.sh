#!/bin/bash

PackageID=0xa4dad4ee99aa00397e68a32173a36d4c0ad66fe79e4d448df2b5c9c09f90ab6b

sui client call --package $PackageID \
                --module movectf2022_checkin \
                --function get_flag 
