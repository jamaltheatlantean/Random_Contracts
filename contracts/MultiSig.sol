// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract MultiSig {

event Deposit(address indexed sender, uint amount, uint balance);
event SubmitTransaction(
    address indexed owner,
    uint indexed txIndex,
    address indexed to,
    uint value,
    bytes data
);
event ConfirmTransaction(address indexed owner, uint indexed txIndex);
event RevokeConfirmation(address indexed owner, uint indexed tcIndex);
event ExecuteTransaction(address indexed owner, uint indexed txIndex);

address [] public owners;
mapping(address => bool) public isOwner; // keep track of owners
uint public numOfConfirmationsRequired;

struct Transaction {
    address to;
    uint value;
    bytes data;
    bool executed;
    uint totalConfirmations;
}

} 