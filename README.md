# CryptoCasinoDiceGame - 加密賭場骰子遊戲
* 前言:
```
看著兩個人擁有相同代幣，勾心鬥角，你爭我奪，
當其中一方把幣輸光，然後用惡魔的低語讓他充錢；
望著勝利的天平反覆橫擺，緊張刺激卻又置身事外的同時，
發揮出專題最好的效果。
```
* 結論：
```
賭博是不好，但官方真的很賺錢
```
* 參考資料:
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
    address payable public owner;  // 合約所有者的地址
    uint256 public lastDiceResult;  // 最後一次擲骰子的結果
    address payable public depositor1;  // 第一個存款者的錢包地址
    address payable public depositor2;  // 第二個存款者的錢包地址
    uint256 public depositor1Amount;  // 存款者1的存款金額
    uint256 public depositor2Amount;  // 存款者2的存款金額
    string private contractState;  // 合約狀態的 JSON 字符串
```
* 方法
```
    constructor() public {
        owner = msg.sender;  // 在合約部署時將部署者設置為合約所有者
        gameCount = 0;
    }
    function deposit() payable public {
        require(depositor1 == address(0) || depositor2 == address(0), "已達到最大存款數量。");  // 檢查是否已達到最大存款數量

        if (depositor1 == address(0)) {
            depositor1 = msg.sender;  // 將第一個存款者的錢包地址設置為呼叫者的地址
            depositor1Amount = msg.value;  // 設置存款者1的存款金額
        } else {
            depositor2 = msg.sender;  // 將第二個存款者的錢包地址設置為呼叫者的地址
            depositor2Amount = msg.value;  // 設置存款者2的存款金額
            if (depositor1Amount != depositor2Amount){
                depositor1.transfer(depositor1Amount);
                depositor2.transfer(depositor2Amount);
                depositor1 = address(0);  // 清除第一個存款者的地址
                depositor2 = address(0);  // 清除第二個存款者的地址
                depositor1Amount = 0;  // 清除存款者1的存款金額
                depositor2Amount = 0;  // 清除存款者2的存款金額
            }
        }
    }
    
```
 
