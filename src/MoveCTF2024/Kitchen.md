# Kitchen

## cook

```
assert!( bcs::to_bytes(&p) == x"0415a5b8a6f8c946bb0300bd9d997eb7038ad784faf2b802c5f122e1", 0);
```

```
04  
15a5
b8a6
f8c9
46bb
03  
00bd
9d99
7eb7
03  
8ad7
84fa
f2b8
02  
c5f1
22e1
```
数据是按照小端存储的，还需要调整下

```
0xa515
0xa6b8
0xc9f8
0xbb46

0xbd00
0x999d
0xb77e

0xd78a
0xfa84
0xb8f2

0xf1c5
0xe122
```

## recook

直接在题目里编写一个测试函数
```
    use std::debug;
    #[test]
    fun test_recook() {
    ///public fun recook (out: vector<u8>, status: &mut Status) {
        let p = Pizza {
            olive_oils: Cook<Olive_oil> {
                source: vector<Olive_oil>[
                    get_Olive_oil(0xb9d9),
                    get_Olive_oil(0xeb54),
                    get_Olive_oil(0x9268),
                    get_Olive_oil(0xc5f7),
                    get_Olive_oil(0xa1ec),
                    get_Olive_oil(0xd084),
                ]
            },
            yeast: Cook<Yeast> {
                source: vector<Yeast>[
                    get_Yeast(0xbd00),
                    get_Yeast(0xfc81),
                    get_Yeast(0x999d),
                    get_Yeast(0xb77e),
                ]
            },
            flour: Cook<Flour> {
                source: vector<Flour>[
                    get_Flour(0xdcc7),
                    get_Flour(0xcc7a),
                    get_Flour(0x8f19),
                    get_Flour(0x96b1),
                    get_Flour(0x8a6d),
                ]
            },
            salt: Cook<Salt> {
                source: vector<Salt>[
                    get_Salt(0x8b01),
                    get_Salt(0xf1c5),
                    get_Salt(0xc6ec),
                ]
            },
        };

        let out= bcs::to_bytes(&p);
        debug::print(&out);

    }
```


```
$ sui move test
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING kitchen
Running Move unit tests
[debug] 0x06d9b954eb6892f7c5eca184d00400bd81fc9d997eb705c7dc7acc198fb1966d8a03018bc5f1ecc6
[ PASS    ] 0x0::kitchen::test_recook
Test result: OK. Total tests: 1; passed: 1; failed: 0
```
