// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract MultiSig {

event DepositConfirmed(address indexed sender, uint amount, uint balance);
event SubmitTransaction(
    address indexed owner,
    uint indexed txIndex,
    address indexed to,
    uint value,
    bytes data
);

} 