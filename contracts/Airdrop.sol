// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.10;

// Imports
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop {
    address public admin; // address of the admin
    mapping(address => bool) public processedAirdrops; // keep track of already produced tokens
    IERC20 public token;
    uint public currentAirdropAmount;
    uint public maxAirdropAmount = 10000 * 10 ** 18; // maximum airdrop amount

    // event
    event AirDropProcessed(
        address recipient,
        uint amount,
        uint date
    ); 

    constructor(address _token) {
        token = IERC20;
        admin = msg.sender;
    }


}