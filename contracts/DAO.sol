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

    modifier onlyInvestors {
        require(investors[msg.sender] = true, "error: Not investor");
        _;
    }


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

    receive() external payable {
        availableFunds += msg.value;
    }

    function contribute() payable external {
        require(block.timestamp < contributionEnd, "error: contribution over");
        investors[msg.sender] = true; // make contributor an investor
        shares[msg.sender] += msg.value; // increase shares of investor
        totalShares += msg.value; // increase totalShares
        availableFunds += msg.value; // increase available funds
    }

    function redeemShare(uint amount) external onlyInvestors {
        require(shares[msg.sender] >= amount, "error: not enough shares");
        require(availableFunds >= amount, "error: not enough available funds");
        shares[msg.sender] -= amount;
        availableFunds -= amount;
        payable(msg.sender).transfer(amount);
    }

    function transferShare(uint amount, address to) external onlyInvestor {
        require(shares[msg.sender] >= amount, "error: insufficient shares");
        shares[msg.sender] -= amount;
        shares[to] += amount;
        investors[to] = true;
    }

    function createProposal(
        string memory name,
        uint amount,
        address payable receipient
    ) public onlyInvestors {
        require(availableFunds >= amount, "error: insufficient funds");
        proposals[nextProposalId] = Proposal(
            nextProposalId,
            name,
            amount,
            receipient,
            0,
            block.timestamp + voteTime,
            false
        );
        availableFunds -= amount;
        nextProposalId++;
    }

    function voteOnProposal(uint proposalId) external onlyInvestors {
        Proposal storage proposal = proposals[proposalId];
        require(votes[msg.sender][proposalId] == false, "error: investor can only vote once");
        require(block.timestamp < proposal.end, "error: proposal already ended");
        votes[msg.sender] = true;
        proposal.votes += shares[msg.sender];
    }

}