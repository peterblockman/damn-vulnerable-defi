// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Address.sol";
import "hardhat/console.sol";

interface IFlashLoanEtherReceiver {
    function execute() external payable;
}

/**
 * @title SideEntranceLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract SideEntranceLenderPool {
    using Address for address payable;

    mapping (address => uint256) private balances;

    function deposit() external payable {
        console.log("msg.sender in pool: %s, value: %s", msg.sender, msg.value);
        balances[msg.sender] += msg.value;
    }

    // this function has cei
    function withdraw() external {
        uint256 amountToWithdraw = balances[msg.sender];
        console.log("amountToWithdrawin pool: %s,",amountToWithdraw);

        balances[msg.sender] = 0;
        payable(msg.sender).sendValue(amountToWithdraw);
    }

    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = address(this).balance;
        require(balanceBefore >= amount, "Not enough ETH in balance");
        // if execute call deposit
        // msg.sender in execute is 
        IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();
        console.log("balance before: %s, balance after: %s", balanceBefore,address(this).balance );
        // only check if the balance has not decreased, it does not change balances[msg.sender]
        // so we can deposit eth to by pass the balance check below, then withdraw the fund
        // means: we now got the loan without paying back
        require(address(this).balance >= balanceBefore, "Flash loan hasn't been paid back");        
    }
}
 