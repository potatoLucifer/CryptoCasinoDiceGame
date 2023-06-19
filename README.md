# CryptoCasinoDiceGame - 加密賭場骰子遊戲
## 前言:
```
看著兩個人擁有相同代幣，勾心鬥角，你爭我奪，
當其中一方把幣輸光，然後用惡魔的低語讓他充錢；
望著勝利的天平反覆橫擺，緊張刺激卻又置身事外的同時，
發揮出專題最好的效果。
```
## 結論：
```
賭博是不好，但官方真的很賺錢
```
## 參考資料:
```
1.The Impact of Blockchain Technology on Casino Sites

2.Blockchain Bets — The Future of Gambling: How $BCB is Changing the Game

3.How blockchain is revolutionizing the gaming industry?

```
## 智能合約
* 引用
```
pragma solidity ^0.6.2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Address.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/math/SafeMath.sol";
```
* 變數
```
using Address for address payable;
using SafeMath for uint256;
uint256 private gameCount;
address payable public owner;
uint256 public lastDiceResult;
address payable public depositor1;
address payable public depositor2;
uint256 public depositor1Amount;
uint256 public depositor2Amount;
string private contractState;
```
* 方法
```
constructor() public {
  owner = msg.sender;
  gameCount = 0;
}

```
 
