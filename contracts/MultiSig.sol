// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.10;

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

mapping(uint => mapping(address => bool)) public isConfirmed; // mapping from txIndex => owner => bool

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

// hardcode owners
constructor(address[] memory _owners, uint _numOfConfirmationsRequired) {
    require(_owners.length > 0, "error: owners required");
    require(
        _numOfConfirmationsRequired > 0 && 
        _numOfConfirmationsRequired <= _owners.length,
        "error: invalid number of required confirmations"
    );

    for (uint i; i < _owners.length; i++) {
        address owner = _owners[i];

        require(owner != address(0), "error: invalid owner");
        require(!isOwner[owner], "error: owner is not unique");

        isOwner[owner] = true;
        owners.push(owner);
    }

    numOfConfirmationsRequired = _numOfConfirmationsRequired;
}

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTx(
        address _to,
        uint _value,
        bytes memory _data
    ) public onlyOwner {
        uint txIndex = transactions.length; // declare index of tx

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
             totalConfirmations: 0
            })
        );

        // emit event
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    // use function to confirm transaction as part of the approval system
    function confirmTx(uint _txIndex) public 
    onlyOwner 
    txExists(_txIndex)
    notExecuted(_txIndex) 
    notConfirmed(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        transaction.totalConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;
        // emit event
        emit ConfirmTransaction(msg.sender, _txIndex);
    }
    
    function executeTx(uint _txIndex) public 
    onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.totalConfirmations >= numOfConfirmationsRequired, "error: need more confirmations");
        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "error: tx failed");
        // emit event
        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    function revokeTx(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "error: tx not confoirmed");
        transaction.totalConfirmations -= 1; // cancels confirmation of user
        isConfirmed[_txIndex][msg.sender] = false;

        // emit event
        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    // Getter functions
    function getOwners() public view returns(address [] memory) {
        return owners;
    }

    function getTx(uint _txIndex) 
    public 
    view 
    returns (
        address to, 
        uint value, 
        bytes memory data, 
        bool executed, 
        uint totalConfirmations
        )
    {
        Transaction storage transaction = transactions[_txIndex];
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.totalConfirmations
        );
    }
}

/**
 * This is a contract to test sending a transaction from the multiSig wallet
 */

pragma solidity 0.8.10;

contract TestContract {
    uint public i;

    function callMe(uint j) public {
        i += j;
    }

    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("callMe(uint256)", 123);
    }
}