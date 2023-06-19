# CryptoCasinoDiceGame - 加密賭場骰子遊戲
## 前言:
```
看著兩個人擁有相同代幣，勾心鬥角，你爭我奪，
當其中一方把幣輸光，然後用惡魔的低語讓他充錢；
望著勝利的天平反覆橫擺，緊張刺激卻又置身事外的同時，
發揮出專題最好的效果。

結論：
賭博是不好，但官方真的很賺錢

參考資料:

1.The Impact of Blockchain Technology on Casino Sites

2.Blockchain Bets — The Future of Gambling: How $BCB is Changing the Game

3.How blockchain is revolutionizing the gaming industry?

```

pragma solidity ^0.6.2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Address.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/math/SafeMath.sol";


contract Wallet  {

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

    constructor() public {
        owner = msg.sender;
        gameCount = 0;
    }
    
    function deposit() payable public {}
    
    function rollDice() public {}

    function refundDeposits() public {}

    function clearDepositors() private {}
    
    function randomDiceRoll() private view returns (uint256) {}

    function viewContractState() public view returns (string memory) {}

    function generateContractState() private view returns (string memory) {}

    function addressToString(address addr) private pure returns (string memory) {}

    function uint256ToString(uint256 value) private pure returns (string memory) {}
 }
