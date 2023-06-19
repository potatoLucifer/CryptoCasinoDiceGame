pragma solidity ^0.6.2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/Address.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/math/SafeMath.sol";

contract Wallet {
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
    
    function deposit() payable public {
        require(depositor1 == address(0) || depositor2 == address(0), "已達到最大存款數量。");

        if (depositor1 == address(0)) {
            depositor1 = msg.sender;
            depositor1Amount = msg.value;
        } else {
            depositor2 = msg.sender;
            depositor2Amount = msg.value;
            if (depositor1Amount != depositor2Amount){
                depositor1.transfer(depositor1Amount);
                depositor2.transfer(depositor2Amount);
                depositor1 = address(0);
                depositor2 = address(0);
                depositor1Amount = 0;
                depositor2Amount = 0;
            }
        }
    }
    
    function rollDice() public {
        require(msg.sender == owner, "只有合約所有者可以擲骰子並清除存款者地址。");
        require(address(this).balance > 0, "沒有可提取的餘額。");

        lastDiceResult = randomDiceRoll();

        if (lastDiceResult >= 1 && lastDiceResult <= 3) {
            uint256 amountToTransfer = address(this).balance * 9 / 10;
            depositor1.transfer(amountToTransfer);
            owner.transfer(address(this).balance);
        } else if (lastDiceResult >= 4 && lastDiceResult <= 6) {
            uint256 amountToTransfer = address(this).balance * 9 / 10;
            depositor2.transfer(amountToTransfer);
            owner.transfer(address(this).balance);
        }
        clearDepositors();
    }

    function refundDeposits() public {
        require(msg.sender == owner, "只有合約所有者可以退款。");
        require(depositor1 != address(0) || depositor2 != address(0), "沒有存款者可以退款。");

        if (depositor1 != address(0)) {
            depositor1.transfer(depositor1Amount);
        }

        if (depositor2 != address(0)) {
            depositor2.transfer(depositor2Amount);
        }
        depositor1 = address(0);
        depositor2 = address(0);
        depositor1Amount = 0;
        depositor2Amount = 0;
    }

    function clearDepositors() private {
        gameCount++;
        contractState = generateContractState();
        depositor1 = address(0);
        depositor2 = address(0);
        depositor1Amount = 0;
        depositor2Amount = 0;
    }
    
    function randomDiceRoll() private view returns (uint256) {
        return (uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 6) + 1;
    }

    function viewContractState() public view returns (string memory) {
        return contractState;
    }

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
}
