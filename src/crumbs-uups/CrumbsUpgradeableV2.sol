// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {CrumbsUpgradeable} from "src/crumbs-uups/CrumbsUpgradeable.sol";

/// @custom:oz-upgrades-from CrumbsUpgradeable
contract CrumbsUpgradeableV2 is CrumbsUpgradeable {
    //     95                   55       40           0
    // |---- timestamp -----|replyToIndex|-unused-|
    //    (40 bits)           (16 bits)   (40 bits)

    function replyToComment(bytes32 _commitment, bytes32 _commentHash, uint16 _replyToIndex) public {
        require(_replyToIndex < commentsByCrumbCommitment[_commitment].length, "Reply to index out of bounds");

        uint40 timestamp = uint40(block.timestamp);
        uint56 rest = uint56(_replyToIndex) << 40; // Shift replyToIndex to the higher 16 bits of the 56-bit space
        uint96 newAdditionalData = (uint96(timestamp) << 56) | rest;

        Comment memory newReply =
            Comment({commentHash: _commentHash, user: msg.sender, additionalData: newAdditionalData});

        commentsByCrumbCommitment[_commitment].push(newReply);
        uint256 commentIndex = commentsByCrumbCommitment[_commitment].length - 1;

        emit CommentStored(_commitment, _commentHash, msg.sender, newAdditionalData, commentIndex);
    }

    function getReplyToIndex(uint96 _additionalData) public pure returns (uint16) {
        return uint16(_additionalData << 40 >> 80); // Extract the reply index from bits 55-40
    }

    function getTimestamp(uint96 _additionalData) public pure returns (uint40) {
        return uint40(_additionalData >> 56);
    }
}
