// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface ITrusterLenderPool {
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external;
}