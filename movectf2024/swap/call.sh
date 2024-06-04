#!/bin/bash

PackageID=0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a

minta=0x5bc9a9a9ed82b9a0de90b6ec3926b162db1a5149937e88fb9c5e49e700d8cde9
#ObjectType: 0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a::ctfa::MintA<0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a::ctfa::CTFA>
a_type='0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a::ctfa::CTFA'

mintb=0xb6bfd99e4341eaa3e630982750bcd4b75b1cd9d86dbeac46a83b84731bb15fb9
#ObjectType: 0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a::ctfb::MintB<0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a::ctfb::CTFB>
b_type='0x2d1ee80d8152a1b3f941c915748a680a1467dcdffe3f261527b190deddf8e48a::ctfb::CTFB'

sui client call --package $PackageID \
                --module vault \
                --function initialize \
                --type-args $a_type $b_type \
                --args $minta $mintb \


#    public entry fun initialize<A,B>(capa: MintA<A>, capb: MintB<B>,ctx: &mut TxContext) {
#        let vault = Vault<A, B> {
#            id: object::new(ctx),
#            coin_a: coin::into_balance(ctfa::mint_for_vault(capa, ctx)),
#            coin_b: coin::into_balance(ctfb::mint_for_vault(capb, ctx)),
#            flashed: false
#        };
#        transfer::share_object(vault);
#    }
