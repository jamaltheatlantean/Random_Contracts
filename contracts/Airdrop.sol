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

    modifier onlyAdmin {
        require(msg.sender == admin, "error: not admin");
        _;
    }

    constructor(address _token) {
        token = IERC20(_token);
        admin = msg.sender;
    }

    function updateAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }

    function claimTokens(
        address recipient,
        uint amount,
        bytes calldata signature
    ) external {
        bytes32 message = prefixed(keccak256(abi.encodePacked(
            recipient,
            amount
        )));
    }
    require(recoverSigner(message, signature) == admin, "error: wrong signature");

}