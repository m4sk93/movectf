# task6


### dapp-kit helloword
- https://sdk.mystenlabs.com/dapp-kit
- [Let's move - Sui Dapp Kit Hello Sui交互](https://www.learnblockchain.cn/article/7514)

```
$ npm create @mysten/dapp
▸ react-client-dapp React Client dApp that reads data from wallet and the blockchain
  react-e2e-counter React dApp with a move smart contract that implements a distributed counter

$ cd my-first-sui-dapp && tree
.
├── index.html
├── package.json
├── prettier.config.cjs
├── README.md
├── src
│   ├── App.tsx
│   ├── main.tsx
│   ├── OwnedObjects.tsx
│   ├── vite-env.d.ts
│   └── WalletStatus.tsx
├── tsconfig.json
├── tsconfig.node.json
└── vite.config.ts

2 directories, 12 files
```
之前已经在chrome安装了钱包,直接执行查看一下效果
```
$ npm install
$ npm run dev

  VITE v4.5.3  ready in 186 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h to show help
```
连接钱包后显示
```
Wallet Status
Wallet connected
Address: 0xe13......
Objects owned by the connected wallet
Object ID: 0x287......
Object ID: 0xce0......
```

关于.tsx：在TypeScript语言中支持JSX语法.TypeScript编译器可以将JSX语法转换为React.createElement函数调用的形式，从而在运行时创建React组件。


### PDT

Programmable Transaction Blocks
https://docs.sui.io/concepts/transactions/prog-txn-blocks
PTBs allow a user to call multiple Move functions, manage their objects, and manage their coins in a single transaction--without publishing a new Move package.

```
npm i @mysten/sui.js
npm i navi-sdk
```
https://naviprotocol.gitbook.io/navi-protocol-developer-docs/how-to-interact-with-the-contract/navi-sdk#navi-flash-loan-sample
https://sdk.mystenlabs.com/dapp-kit/wallet-hooks/useSignAndExecuteTransactionBlock

Navi不能在devnet/testnet中使用？?
修改main.tsx 中的defaultNetwork
```
        <SuiClientProvider networks={networkConfig} defaultNetwork="mainnet">
```
https://suiscan.xyz/mainnet/tx/7Mt6Cu9xSEWRxCdPsczZEbi6NBCYYa2JnBN21pz3Nifh

Todo:
- withdrawCoin测试失败

