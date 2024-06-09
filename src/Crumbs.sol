// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Crumbs {
    /// TOTAL 2 storage slots
    struct Comment {
        bytes32 commentHash;
        address user; // 20 bytes - 160 bits
        uint96 additionalData; // 12 bytes, 40 bits timestamp, 56 bits rest data (e.g., thumbs up counter)
    }

    event CommentStored(
        bytes32 indexed commitment,
        bytes32 commentHash,
        address indexed user,
        uint96 additionalData,
        uint256 commentIndex
    );

    mapping(bytes32 => Comment[]) public commentsByCrumbCommitment;

    function storeCommentAndReplaceTimestamp(bytes32 _commitment, bytes32 _commentHash, uint96 _additionalData)
        public
    {
        // Block producers can lie about the timestamp, but it's still useful for ordering comments
        uint40 timestamp = uint40(block.timestamp);
        uint56 rest = uint56(_additionalData);
        uint96 newAdditionalData = uint96(uint96(timestamp) << 56) | uint96(rest);

        Comment memory newComment =
            Comment({commentHash: _commentHash, user: msg.sender, additionalData: newAdditionalData});

        commentsByCrumbCommitment[_commitment].push(newComment);
        uint256 commentIndex = commentsByCrumbCommitment[_commitment].length - 1;
        emit CommentStored(_commitment, _commentHash, msg.sender, newAdditionalData, commentIndex);
    }

    function storeComment(bytes32 _commitment, bytes32 _commentHash, uint96 _additionalData) public {
        storeCommentAndReplaceTimestamp(_commitment, _commentHash, _additionalData);
    }

    function getAllCommentsByCrumbCommitment(bytes32 _commitment) public view returns (Comment[] memory) {
        return commentsByCrumbCommitment[_commitment];
    }

    function getCommentsByUrlHash(bytes32 _commitment) public view returns (Comment[] memory) {
        return getAllCommentsByCrumbCommitment(_commitment);
    }

    function storeCommentRaw(bytes32 _commitment, bytes32 _commentHash, uint96 _additionalData) public {
        Comment memory newComment =
            Comment({commentHash: _commentHash, user: msg.sender, additionalData: _additionalData});

        commentsByCrumbCommitment[_commitment].push(newComment);
        uint256 commentIndex = commentsByCrumbCommitment[_commitment].length - 1;
        emit CommentStored(_commitment, _commentHash, msg.sender, _additionalData, commentIndex);
    }

    function getCurrentTimestamp() public view returns (uint256) {
        return uint256(block.timestamp);
    }

    function packAdditionalData(uint40 timestamp, uint56 rest) public pure returns (uint96) {
        return uint96(uint96(timestamp) << 56) | uint96(rest);
    }

    function unpackAdditionalData(uint96 data) public pure returns (uint40 timestamp, uint56 rest) {
        timestamp = uint40(data >> 56);
        rest = uint56(data);
    }

    function getComment(bytes32 _commitment, uint256 index) public view returns (bytes32, address, uint96) {
        require(index < commentsByCrumbCommitment[_commitment].length, "Index out of bounds");
        Comment storage comment = commentsByCrumbCommitment[_commitment][index];
        return (comment.commentHash, comment.user, comment.additionalData);
    }
}
