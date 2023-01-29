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
    address to; // address receiving payment
    uint value; // value of eth
    bytes data; // data of tx
    bool executed; // has tx been confirmed?
    uint totalConfirmations; // total amount of votes for tx
}

mapping(uint => mapping(address => bool)) public isConfirmed // mapping from txIndex => owner => bool

Transaction[] public transactions;

modifier onlyOwner() {
    require(isOwner[msg.sender], "error: not owner");
    _;
}
modifier txExists(uint _txIndex) {
    require(_txIndex < transactions.length, "error: tx does not exist");
    _;
}

modifier notExecuted(uint _txIndex) {
    require(!transactions[_txIndex].executed, "error: tx already executed");
    _;
}

modifier notConfirmed(uint _txIndex) {
    require(!isConfirmed[_txIndex][msg.sender], "error: tx already confirmed");
    _;
}

} 