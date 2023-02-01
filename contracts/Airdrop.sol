// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.10;

// Imports
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop {
    address public admin;
    mapping(address => bool) public processedAirdrops;
    IERC20 public token;
    uint public currentAirdropAmount;
    uint public maxAirdropAmount = 10000 * 10 ** 18;
}