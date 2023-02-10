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
    event AirdropProcessed(
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
        require(recoverSigner(message, signature) == admin, "error: wrong signature");
        require(processedAirdrops[recipient] == false, "error: recipient already received airdrop");
        require(currentAirdropAmount + amount <= maxAirdropAmount, "error: Airdropped 100% of available tokens");
        processedAirdrops[recipient] = true;
        currentAirdropAmount += amount;
        // transfer token
        token.transfer(recipient, amount);
        emit AirdropProcessed (recipient, amount, block.timestamp);
    }

    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            hash
        ));
    }

    function recoverSignature(bytes32 message, bytes memory sig) internal pure returns (address) {
        
    }

    function splitSignature(bytes memory sig) internal pure returns (uint8, bytes32, bytes32) {
        require(sig.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }
}