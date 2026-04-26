// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./EIP712MetaTransaction.sol";

contract Relayer {
    function relay(
        address target,
        address user,
        bytes memory signature,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) external {
        EIP712MetaTransaction(target).executeMetaTransaction(user, signature, r, s, v);
    }
}
