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
    uint public totalShares; // total shares of members
    uint public availableFunds; // address(this).balance of contract
    uint public contributionEnd; // time for ending contributions
    uint public nextProposalId; // id for proposals
    uint public voteTime; // deadline for vote on proposal to end
    uint public minVotes; // minimal number of votes required
    address public admin;


    constructor(
        uint contributionTime,
        uint _voteTime,
        uint _minVotes) {
        require(_minVotes > 0 && minVotes < 200, "minVotes should be between 0 and 200");
        contributionEnd = block.timestamp + contributionTime;
        voteTime = _voteTime;
        minVotes = _minVotes;
        admin = msg.sender;
    }

    function contribute() payable external {
        require(block.timestamp < contributionEnd, "error: contribution over");
        investors[msg.sender] = true; // make contributor an investor
        shares[msg.sender] += msg.value;
        totalShares += msg.value; // total shares = how muuch contributed so far
    }


}