// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library LibDiamondStorage {
    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.diamond.storage");

    struct Comment {
        bytes32 commentHash;
        address user;
        uint96 additionalData;
    }

    struct DiamondStorage {
        mapping(bytes32 => Comment[]) commentsByCrumbCommitment;
    }

    function diamondStorage() internal pure returns (DiamondStorage storage ds) {
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }
}
