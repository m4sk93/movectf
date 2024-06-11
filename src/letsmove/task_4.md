# task4

### 如何使用task2的合约
```
[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/mainnet" }
m4sk93_faucet_coin= { local = "../../task2/m4sk93_faucet_coin" }
```
同时修改m4sk93_faucet_coin的Move.toml
```
[package]
published-at = "0xe799e4d1324db8877c827cb4ca78dc065a8f9ef70fbe705e4c8c37250e195982" # package id
[addresses]
m4sk93_faucet_coin = "0xe799e4d1324db8877c827cb4ca78dc065a8f9ef70fbe705e4c8c37250e195982" # package id
```
