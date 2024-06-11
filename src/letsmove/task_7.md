# task7


完成 Move CTF Check in
- 上链网络: 测试网(testnet)


## 需求
- 完成 CLI 调用学习
- 理解合约交互传值
- 完成 Move CTF Check In
- 必须用Sui CLI 调用完成

## 任务指南

- 合约部署地址: `0x60695ee31f93add1f79909c884a55dff7e5f140bbd2e495819966bd2f7971d42`
- FlagStr Object:`0x011f9404e6f167e549b617a53eea058029167a2beac26c624cbc3550e04b5ad2`
- random: `0x8`
- github id:  填写自己的github id

### 题目源码
[Move CTF Check In](https://github.com/move-cn/letsmove-ctf/tree/main/src/01_check_in/check_in)




# 分析 
关于random   
https://docs.sui.io/guides/developer/advanced/randomness-onchain
```
Random has a reserved address 0x8. See random.move for the Move APIs for accessing randomness on Sui.
```

每次提交flag后string会变化，所以先在链上看看string的值是`N21X`   
https://suiscan.xyz/testnet/object/0x011f9404e6f167e549b617a53eea058029167a2beac26c624cbc3550e04b5ad2

```
#!/bin/bash

PackageID=0x60695ee31f93add1f79909c884a55dff7e5f140bbd2e495819966bd2f7971d42
FlagStr_Object=0x011f9404e6f167e549b617a53eea058029167a2beac26c624cbc3550e04b5ad2

github_id="m4sk93"
string="N21X"
rand="0x8"

sui client call --package $PackageID \
                --module check_in \
                --function get_flag \
                --args $string $github_id $FlagStr_Object $rand
```

Transaction Digest: BNKqqwLPDiA1th71C1qp8nAMzdYFC8WhkXaBjoNyZhWD
