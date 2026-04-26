// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract EIP712MetaTransaction is EIP712 {
    using ECDSA for bytes32;

    mapping(address => uint256) private _nonces;

    bytes32 private constant EXECUTE_TYPEHASH = keccak256(
        "Execute(address user,uint256 nonce,bytes functionSignature)"
    );

    event MetaTransactionExecuted(address userAddress, address relayerAddress, bytes functionSignature);

    constructor(string memory name, string memory version) EIP712(name, version) {}

    function executeMetaTransaction(
        address userAddress,
        bytes memory functionSignature,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) public payable returns (bytes memory) {
        bytes32 digest = _hashTypedDataV4(
            keccak256(abi.encode(EXECUTE_TYPEHASH, userAddress, _nonces[userAddress], keccak256(functionSignature)))
        );

        address signer = digest.recover(v, r, s);
        require(signer == userAddress, "Signature mismatch");
        require(signer != address(0), "Invalid signer");

        _nonces[userAddress]++;

        emit MetaTransactionExecuted(userAddress, msg.sender, functionSignature);

        (bool success, bytes memory returnData) = address(this).call(
            abi.encodePacked(functionSignature, userAddress)
        );
        require(success, "Function execution failed");

        return returnData;
    }

    function getNonce(address user) public view returns (uint256) {
        return _nonces[user];
    }
}
