# task2

### coin

- 10_coin协议_move编程语言2024版本
https://www.bilibili.com/video/BV1tf42127Co/?spm_id_from=333.788
https://www.bilibili.com/video/BV1Kw4m197ae/?spm_id_from=333.788.recommend_more_video.13

- https://docs.sui.io/guides/developer/sui-101/create-coin
示例有错
```
struct MYCOIN has drop {}
```
应该添加public

- https://sui-book.com/framework/02.coin.html

```
│  ┌──                                                                                                                                  │
│  │ ObjectID: 0xc826cb5f07f8e4b65e9e6170d9be14f6c2bd1b2f65d7835a9f31562786ea77a4                                                       │
│  │ Sender: 0xfd72aa1c93c65b9487ca060a32bff2851624117d35078f54618384b1e0d16849                                                         │
│  │ Owner: Account Address ( 0xfd72aa1c93c65b9487ca060a32bff2851624117d35078f54618384b1e0d16849 )                                      │
│  │ ObjectType: 0x2::coin::TreasuryCap<0x2a056973b19d7ac2a202acdb7ec1d952a51dde475a9ee579ba6b2d594bf1dea6::m4sk93_coin::M4SK93_COIN>   │
│  │ Version: 1248931                                                                                                                   │
│  │ Digest: 3ywK1W96939rB6A3Ar6Htd8wCQ17erKFVXnDs6SomuZK
...
PackageID: 0x2a056973b19d7ac2a202acdb7ec1d952a51dde475a9ee579ba6b2d594bf1dea6
```
```
sui client call --function mint --module mycoin --package <PACKAGE-ID> --args <TREASURY-CAP-ID> <COIN-AMOUNT> <RECIPIENT-ADDRESS> --gas-budget <GAS-AMOUNT>
sui client call --function mint --module m4sk93_coin --package 0x2a056973b19d7ac2a202acdb7ec1d952a51dde475a9ee579ba6b2d594bf1dea6 --args 0xc826cb5f07f8e4b65e9e6170d9be14f6c2bd1b2f65d7835a9f31562786ea77a4 100 0xe13769b8c84f7c4011d001c1d9e5c471e8d5fb612cb44b76fcfbf0eebaa08ced --gas-budget 50000000
```
https://suiscan.xyz/testnet/tx/5cReZ9J9pXPJK9FoTPJA4TFk1ZLERs1dHqXqJbn9Esj8

### faucet

- public_transfer 独享 mint权限 
- public_share_object 共享 mint权限

两个改动 
```
    ...
        ///transfer::public_transfer(treasury, tx_context::sender(ctx));
        ///The Coin<T> is a generic implementation of a coin on Sui.
        ///Access to the TreasuryCap provides control over the minting and burning of coins.
        ///Further transactions can be sent directly to the sui::coin::Coin with TreasuryCap object as authorization.


        transfer::public_share_object(treasury)
    }

    ///public fun mint(
    public entry fun mint(
    ...
```

```
PackageID: 0x8194063d47171bcbdd6e7ddce605aa8a6bd8b482315ca236a909695d9e5a9fe2
TreasuryCap: 0x00f68f1b2d0c87e6d1aa55f2dc82e16683e18eee72d7e1f871349f2a18776aac
sui client call --function mint --module m4sk93_faucet_coin --package 0x8194063d47171bcbdd6e7ddce605aa8a6bd8b482315ca236a909695d9e5a9fe2 --args 0x00f68f1b2d0c87e6d1aa55f2dc82e16683e18eee72d7e1f871349f2a18776aac 200 0xe13769b8c84f7c4011d001c1d9e5c471e8d5fb612cb44b76fcfbf0eebaa08ced --gas-budget 50000000
```
也可以在网页版mint  
https://suiscan.xyz/testnet/object/0x8194063d47171bcbdd6e7ddce605aa8a6bd8b482315ca236a909695d9e5a9fe2/txs

### coin(主网测试)

** sui client publish ** 报错
```
Failed to publish the Move module(s), reason: [warning] Multiple source verification errors found:

- Local dependency did not match its on-chain version at 0000000000000000000000000000000000000000000000000000000000000002::Sui::deny_list
- Local dependency did not match its on-chain version at 0000000000000000000000000000000000000000000000000000000000000001::MoveStdlib::type_name
- Local dependency did not match its on-chain version at 0000000000000000000000000000000000000000000000000000000000000002::Sui::object

This may indicate that the on-chain version(s) of your package's dependencies may behave differently than the source version(s) your package was built against.

Fix this by rebuilding your packages with source versions matching on-chain versions of dependencies, or ignore this warning by re-running with the --skip-dependency-verification flag.
```
解决办法:把Move.toml中依赖修改为** framework/mainnet ** 还不行就
```
sui client publish --skip-dependency-verification
```

```
TreasuryCap:
0x5eeffd6ca1fb38d63701ea8e1a3c1f3bff348441aec0a1eeae45f023eb62d120
PackageID: 
0x38974bd3a9dad0e8274024b49642e2f0fa94fc4889219791e3742c8730528fd0
sui client call --function mint --module m4sk93_coin --package 0x38974bd3a9dad0e8274024b49642e2f0fa94fc4889219791e3742c8730528fd0 --args 0x5eeffd6ca1fb38d63701ea8e1a3c1f3bff348441aec0a1eeae45f023eb62d120 100 0xe13769b8c84f7c4011d001c1d9e5c471e8d5fb612cb44b76fcfbf0eebaa08ced --gas-budget 50000000
```

### faucet coin (主网测试)

```
TreasuryCap:
0xaa6391b1bd2e95cd3d10418c540c79c4aac371677aa9e4c6f54c6551a48cc38e
PackageID: 
0xe799e4d1324db8877c827cb4ca78dc065a8f9ef70fbe705e4c8c37250e195982
sui client call --function mint --module m4sk93_faucet_coin --package 0xe799e4d1324db8877c827cb4ca78dc065a8f9ef70fbe705e4c8c37250e195982 --args 0xaa6391b1bd2e95cd3d10418c540c79c4aac371677aa9e4c6f54c6551a48cc38e 200 0xe13769b8c84f7c4011d001c1d9e5c471e8d5fb612cb44b76fcfbf0eebaa08ced --gas-budget 50000000
```
网页再mint一下  
https://suiscan.xyz/mainnet/object/0xe799e4d1324db8877c827cb4ca78dc065a8f9ef70fbe705e4c8c37250e195982/contracts
https://suiscan.xyz/mainnet/object/0xe799e4d1324db8877c827cb4ca78dc065a8f9ef70fbe705e4c8c37250e195982/txs

