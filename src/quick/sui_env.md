
本文记录在一个全新的VPS上，从0开始搭建Sui的开发环境。  

## 搭建环境

ssh登录vps后，如果使用的是root账户,一定要新建一个普通权限账户(有些软件不允许使用root运行，比如马上用到的brew),并且将他添加到sudo组里.
```
root@VM-0-7-debian:~# useradd -m test
root@VM-0-7-debian:~# echo 'test  ALL=(ALL)  NOPASSWD:ALL' >> /etc/sudoers
root@VM-0-7-debian:~# su test
$ bash
test@VM-0-7-debian:/root$ ls
ls: cannot open directory '.': Permission denied
test@VM-0-7-debian:/root$ cd
test@VM-0-7-debian:~$ ls
```
参考官方文档搭建环境  
https://docs.sui.io/guides/developer/getting-started/sui-install

### 使用brew安装sui
由于VPS的性能不够，所以不能使用源码安装sui，采用brew安装，先安装brew.  
使用普通权限账户执行一下命令
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/test/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
然后安装sui
```
test@VM-0-7-debian:~$ brew install sui
==> Auto-updating Homebrew...
Adjust how often this is run with HOMEBREW_AUTO_UPDATE_SECS or disable with
HOMEBREW_NO_AUTO_UPDATE. Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Downloading https://ghcr.io/v2/homebrew/core/sui/manifests/1.26.0
###################################################################################################################################################### 100.0%
==> Fetching sui
==> Downloading https://ghcr.io/v2/homebrew/core/sui/blobs/sha256:a68e100359a64e93b42de54a296e23c246e4cd15be3ecbc21e1c7ee942a2e126
###################################################################################################################################################### 100.0%
==> Pouring sui--1.26.0.x86_64_linux.bottle.tar.gz
🍺  /home/linuxbrew/.linuxbrew/Cellar/sui/1.26.0: 9 files, 127.6MB
==> Running `brew cleanup sui`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
test@VM-0-7-debian:~$ sui -V
sui 1.26.0-homebrew
```
### client设置testnet
第一次执行`sui client` 会生成配置文件`~/.sui/sui_config/client.yaml`
```
test@VM-0-7-debian:~$ sui client
Config file ["/home/test/.sui/sui_config/client.yaml"] doesn't exist, do you want to connect to a Sui Full node server [y/N]?y
Sui Full node server URL (Defaults to Sui Testnet if not specified) : https://fullnode.testnet.sui.io:443
Environment alias for [https://fullnode.testnet.sui.io:443] : testnet
Select key scheme to generate keypair (0 for ed25519, 1 for secp256k1, 2: for secp256r1):
0
```
初始化钱包后，会打印助记词，记录下来

### 获取测试币

获取钱包地址
```
test@VM-0-7-debian:~$ sui client addresses
╭──────────────────────┬────────────────────────────────────────────────────────────────────┬────────────────╮
│ alias                │ address                                                            │ active address │
├──────────────────────┼────────────────────────────────────────────────────────────────────┼────────────────┤
│ youthful-hypersthene │ 0x041f524144f3b0607099f7370a3184f4093510ade5c123409ed76440c8a50537 │ *              │
╰──────────────────────┴────────────────────────────────────────────────────────────────────┴────────────────╯
```
使用curl在水龙头拿币
```
curl --location --request POST 'https://faucet.testnet.sui.io/gas' \
--header 'Content-Type: application/json' \
--data-raw '{
    "FixedAmountRequest": {
        "recipient": "0x041f524144f3b0607099f7370a3184f4093510ade5c123409ed76440c8a50537"
    }
}'
```

## 开始第一个应用
自此环境搭建完毕,建议新手再学习下vim的基本操作
https://docs.sui.io/guides/developer/first-app/write-package 

后续需要切换到主网
```
test@VM-0-7-debian:~$ sui client envs
╭─────────┬─────────────────────────────────────┬────────╮
│ alias   │ url                                 │ active │
├─────────┼─────────────────────────────────────┼────────┤
│ testnet │ https://fullnode.testnet.sui.io:443 │ *      │
╰─────────┴─────────────────────────────────────┴────────╯
test@VM-0-7-debian:~$ sui client new-env --alias=mainnet --rpc https://fullnode.mainnet.sui.io:443
Added new Sui env [mainnet] to config.
test@VM-0-7-debian:~$ sui client switch --env mainnet
Active environment switched to [mainnet]
test@VM-0-7-debian:~$ sui client envs
╭─────────┬─────────────────────────────────────┬────────╮
│ alias   │ url                                 │ active │
├─────────┼─────────────────────────────────────┼────────┤
│ testnet │ https://fullnode.testnet.sui.io:443 │        │
│ mainnet │ https://fullnode.mainnet.sui.io:443 │ *      │
╰─────────┴─────────────────────────────────────┴────────╯
```

