// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

error Deed__NotOwner();
error Deed__NotLawyer();

contract Deed {
    address public owner; // owner of deed
    address public lawyer; // address of lawyer
    address payable private james; // address of inheritor
    uint public shares; // shares of inheritor
    uint public timeSpan;

    modifier onlyOwner {
        if(msg.sender != owner)
            revert Deed__NotOwner();
        _;
    }

    modifier onlyLawyer {
        if(msg.sender != lawyer)
            revert Deed__NotLawyer();
        _;
    }

    constructor(address _lawyer, address payable _james) {
        owner = msg.sender;
        lawyer = _lawyer;
        james = _james;
        timeSpan = block.timestamp + 20 days;
    }

    function expandTimeSpan(uint _newTimeSpan) public onlyOwner {
        timeSpan = _newTimeSpan;
    }

    function transfer() public onlyLawyer {
        require(block.timestamp >= timeSpan, "warning: too early");
        james.transfer(address(this).balance);
    }
}