# CryptoCasinoDiceGame - 加密賭場骰子遊戲
* 前言:
  ```
  看著兩個人擁有相同代幣，勾心鬥角，你爭我奪，當其中一方把幣輸光，然後用惡魔的低語讓他充錢；
  望著勝利的天平反覆橫擺，緊張刺激卻又置身事外的同時，發揮出專題最好的效果。
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
  ```c
  pragma solidity ^0.6.2;
  import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Address.sol";
  import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/math/SafeMath.sol";
  ```

* 變數
  ```c++
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
  * 建構
    ```c
    constructor() public {
        owner = msg.sender;  // 在合約部署時將部署者設置為合約所有者
        gameCount = 0;
    }
    ```
  * 主函數
    ```c
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
    
    function rollDice() public {
        require(msg.sender == owner, "只有合約所有者可以擲骰子並清除存款者地址。");  // 檢查是否為合約所有者
        require(address(this).balance > 0, "沒有可提取的餘額。");  // 檢查合約餘額是否大於零

        lastDiceResult = randomDiceRoll();  // 呼叫隨機擲骰子函數獲取結果

        if (lastDiceResult >= 1 && lastDiceResult <= 3) {
            uint256 amountToTransfer = address(this).balance * 9 / 10;  // 轉移90%的餘額給存款者1
            depositor1.transfer(amountToTransfer);
            owner.transfer(address(this).balance);  // 轉移剩餘的10%給合約所有者
        } else if (lastDiceResult >= 4 && lastDiceResult <= 6) {
            uint256 amountToTransfer = address(this).balance * 9 / 10;  // 轉移90%的餘額給存款者2
            depositor2.transfer(amountToTransfer);
            owner.transfer(address(this).balance);  // 轉移剩餘的10%給合約所有者
        }

        clearDepositors();  // 清除存款者的地址和存款金額
    }

    function refundDeposits() public {
        require(msg.sender == owner, "只有合約所有者可以退款。");  // 檢查是否為合約所有者
        require(depositor1 != address(0) || depositor2 != address(0), "沒有存款者可以退款。");  // 檢查是否有存款者

        if (depositor1 != address(0)) {
            depositor1.transfer(depositor1Amount);  // 將存款者1的金額退還給存款者1
        }

        if (depositor2 != address(0)) {
            depositor2.transfer(depositor2Amount);  // 將存款者2的金額退還給存款者2
        }
        depositor1 = address(0);  // 清除第一個存款者的地址
        depositor2 = address(0);  // 清除第二個存款者的地址
        depositor1Amount = 0;  // 清除存款者1的存款金額
        depositor2Amount = 0;  // 清除存款者2的存款金額
    }

    function clearDepositors() private {
        gameCount++;
        contractState = generateContractState();  // 生成合約狀態的 JSON 字符串並儲存
        depositor1 = address(0);  // 清除第一個存款者的地址
        depositor2 = address(0);  // 清除第二個存款者的地址
        depositor1Amount = 0;  // 清除存款者1的存款金額
        depositor2Amount = 0;  // 清除存款者2的存款金額
    }
    
    function randomDiceRoll() private view returns (uint256) {
        return (uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 6) + 1;  // 使用區塊信息生成偽隨機數，模擬骰子擲出結果
    }

    function viewContractState() public view returns (string memory) {
        return contractState;
    }
  * 副函數
    ```c
    // 輔助函數：生成合約狀態的 JSON 字符串
    function generateContractState() private view returns (string memory) {
        string memory state = string(abi.encodePacked(
            '{',
            '"GameCount": ', uint256ToString(gameCount), ',',
            '"owner": "', addressToString(owner), '",',
            '"lastDiceResult": ', uint256ToString(lastDiceResult), ',',
            '"depositor1": "', addressToString(depositor1), '",',
            '"depositor2": "', addressToString(depositor2), '",',
            '"depositor1Amount": ', uint256ToString(depositor1Amount), ',',
            '"depositor2Amount": ', uint256ToString(depositor2Amount),
            '}'
        ));

        return state;
    }

    // 輔助函數：將地址轉換為字符串
    function addressToString(address addr) private pure returns (string memory) {
        bytes32 value = bytes32(uint256(addr));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    // 輔助函數：將 uint256 轉換為字符串
    function uint256ToString(uint256 value) private pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
 
