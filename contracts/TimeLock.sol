pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract TimeLock {
    using SafeMath for uint;

    mapping(address => uint) public balances;

    mapping(address => uint) public lockTime;

    //////////////////////////////////////////////////////////
    function deposit() external payable {
        balances[msg.sender] += msg.value;

        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "insufficient funds");

        require(block.timestamp > lockTime[msg.sender], "locktime not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "failed");
    }
}