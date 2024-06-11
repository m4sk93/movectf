本文通过MoveCTF2022的签到题，介绍Sui基本的发布、测试方法。 
Sui开发环境搭建请参考 [使用VPS从0搭建Sui开发环境](https://m4sk93.github.io/posts/vps_sui_env/)
原题目在https://github.com/movebit/movectf-1/blob/master/sources/module.move

## 搭建题目环境
在testnet搭建  
由于Move2024版本的变化，调整了下源码
```
test@VM-0-7-debian:~$ sui client switch --env testnet
Active environment switched to [testnet]
test@VM-0-7-debian:~$ sui move new movectf2022_checkin
test@VM-0-7-debian:~$ cd movectf2022_checkin/
test@VM-0-7-debian:~/movectf2022_checkin$ ls
Move.toml  sources  tests
test@VM-0-7-debian:~/movectf2022_checkin$ cd sources/
test@VM-0-7-debian:~/movectf2022_checkin/sources$ ls
movectf2022_checkin.move
test@VM-0-7-debian:~/movectf2022_checkin/sources$ vim movectf2022_checkin.move
test@VM-0-7-debian:~/movectf2022_checkin/sources$ cat movectf2022_checkin.move
/// Module: movectf2022_checkin
module movectf2022_checkin::movectf2022_checkin {
    use sui::event;
    use sui::tx_context::{Self, TxContext};

    ///Visibility annotations are required on struct declarations from the Move 2024 edition onwards.
    ///struct Flag has copy, drop {
    public struct Flag has copy, drop {
        user: address,
        flag: bool
    }

    public entry fun get_flag(ctx: &mut TxContext) {
        event::emit(Flag {
            user: tx_context::sender(ctx),
            flag: true
        })
    }
}
test@VM-0-7-debian:~/movectf2022_checkin$ sui move build
......
test@VM-0-7-debian:~/movectf2022_checkin$  sui client publish
......
│ Published Objects:                                                                               │
│  ┌──                                                                                             │
│  │ PackageID: 0xa4dad4ee99aa00397e68a32173a36d4c0ad66fe79e4d448df2b5c9c09f90ab6b                 │
│  │ Version: 1                                                                                    │
│  │ Digest: CMCrLDaHtcLy8pvecy55xVvDVcAUz36hsqYBkEkpUThh                                          │
│  │ Modules: movectf2022_checkin                                                                  │
│  └──
```
## 获取flag
直接调用接口即可,通过event返回flag
```
test@VM-0-7-debian:~/movectf2022_checkin$ vim call.sh
test@VM-0-7-debian:~/movectf2022_checkin$ cat call.sh
#!/bin/bash

PackageID=0xa4dad4ee99aa00397e68a32173a36d4c0ad66fe79e4d448df2b5c9c09f90ab6b

sui client call --package $PackageID \
                --module movectf2022_checkin \
                --function get_flag
test@VM-0-7-debian:~/movectf2022_checkin$ chmod +x call.sh
test@VM-0-7-debian:~/movectf2022_checkin$ ./call.sh
...
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                    │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                        │
│  │ EventID: 3ntybkcdkNLriDtfYyiJ9yhCMdMEUzTbdgyLQzt2ww7p:0                                                  │
│  │ PackageID: 0xa4dad4ee99aa00397e68a32173a36d4c0ad66fe79e4d448df2b5c9c09f90ab6b                            │
│  │ Transaction Module: movectf2022_checkin                                                                  │
│  │ Sender: 0x041f524144f3b0607099f7370a3184f4093510ade5c123409ed76440c8a50537                               │
│  │ EventType: 0xa4dad4ee99aa00397e68a32173a36d4c0ad66fe79e4d448df2b5c9c09f90ab6b::movectf2022_checkin::Flag │
│  │ ParsedJSON:                                                                                              │
│  │   ┌──────┬────────────────────────────────────────────────────────────────────┐                          │
│  │   │ flag │ true                                                               │                          │
│  │   ├──────┼────────────────────────────────────────────────────────────────────┤                          │
│  │   │ user │ 0x041f524144f3b0607099f7370a3184f4093510ade5c123409ed76440c8a50537 │                          │
│  │   └──────┴────────────────────────────────────────────────────────────────────┘                          │
│  └──                                                                                                        │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
...
```
