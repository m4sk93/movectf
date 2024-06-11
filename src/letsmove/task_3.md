# task3


https://medium.com/building-on-sui/code-in-move-6-minting-nfts-on-sui-with-kiosk-5d9ba1636a7b 


mint 一个 nft 发送到地址: 0x7b8e0864967427679b4e129f79dc332a885c6087ec9e187b53451a9006ee15f2
https://suiscan.xyz/mainnet/object/0xf01b9c73ad3b205ff2d4666266168173df0bd4d1c0661b80d59803c2ba64fe70/contracts

```
sui client call --function mint_and_transfer --module m4sk93_nft --package 0xf01b9c73ad3b205ff2d4666266168173df0bd4d1c0661b80d59803c2ba64fe70 --args first_m4sk93_nft 0x7b8e0864967427679b4e129f79dc332a885c6087ec9e187b53451a9006ee15f2  --gas-budget 50000000
```
https://suiscan.xyz/mainnet/tx/5QnRk6wUasMNYzXpVjHyMiBmtyhCJ4wEfMrUWLyrfio8

