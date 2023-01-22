// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * A DAO making contract, for proposals, and contributions, and voting.
 * collects money from investors and allocates shares.
 * Keep track of contributions and shares.
 * Allow investors transfer shares.
 * Allow investment proposals to be created and voted.
 * Execute successful investment proposals.
 */

contract DAO {

    struct Proposal{
        uint id;
        uint amount;
        uint votes;
        uint end;
        string name;
        address payable receipient;
        bool executed;
    }

    mapping(address => bool) public investors; // keep track of investors
    mapping(address => uint) public shares; // keep track of shares
    mapping(address => mapping(uint => bool)) public votes; // keep track of individual votes
    mapping(uint => Proposal) public proposals; // maps proposals


    constructor() {
        
    }


}