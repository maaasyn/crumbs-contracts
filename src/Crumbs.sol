// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract CrumbsSocial {
    // Event to emit when a comment is stored
    event CommentStored(bytes32 indexed url, bytes32 commentHash, address indexed user);

    // Mapping from URL hash to a list of comment hashes
    mapping(bytes32 => bytes32[]) public commentsByUrl;

    function storeComment(bytes32 _url, bytes32 _commentHash) public {
        commentsByUrl[_url].push(_commentHash);

        emit CommentStored(_url, _commentHash, msg.sender);
    }

    function storeCommentByUrlAndString(string calldata _url, string calldata _comment) public {
        bytes32 urlHash = keccak256(abi.encodePacked(_url));
        bytes32 commentHash = keccak256(abi.encodePacked(_comment));
        storeComment(urlHash, commentHash);
    }

    function getCommentsByUrlHash(bytes32 url) public view returns (bytes32[] memory) {
        return commentsByUrl[url];
    }

    function getCommentsByUrl(string calldata _url) public view returns (bytes32[] memory) {
        bytes32 urlHash = keccak256(abi.encodePacked(_url));
        return commentsByUrl[urlHash];
    }

    // Function to verify a comment with its hash
    function verifyComment(string calldata comment, string calldata _url) public view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(comment));
        bytes32 urlHash = keccak256(abi.encodePacked(_url));
        bytes32[] memory storedHashes = commentsByUrl[urlHash];
        for (uint256 i = 0; i < storedHashes.length; i++) {
            if (storedHashes[i] == hash) {
                return true;
            }
        }
        return false;
    }
}
