# Dynamic Matrix Traversal

https://docs.sui.io/references/framework/move-stdlib/vector#0x1_vector_EINDEX_OUT_OF_BOUNDS
```
const EINDEX_OUT_OF_BOUNDS: u64 = 131072;
```
vector最大长度是 131072 = 0x20000
可以穷举

由于数据不大，可以现在0x200范围内试试   

直接在题目里编写测试函数

```
    use std::debug;
    #[test]
    fun test_up() {
        bruteforce(14365);
        bruteforce(2794155);
    }
    #[test_only]
    fun bruteforce(target:u64) {
        let i:u64 = 1;
        while (i < 0x200){
            let j:u64 = 1;
            while(j < 0x200){
                if(target == up(i,j)){
                    debug::print(&target);
                    debug::print(&i);
                    debug::print(&j);
                    return
                };
                j = j + 1;
            };
            i = i + 1;
        };

    }
```




```
$ sui move test -i 10000000000000000000
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING dynamic_matrix_traversal
Running Move unit tests
[debug] 14365
[debug] 3
[debug] 169
[debug] 2794155
[debug] 5
[debug] 89
[ PASS    ] 0x0::matrix::test_up
Test result: OK. Total tests: 1; passed: 1; failed: 0
```
