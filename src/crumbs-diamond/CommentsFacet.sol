// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "src/crumbs-diamond/LibDiamondStorage.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract CommentsFacet is Initializable, OwnableUpgradeable {
    address private _diamondAddress;

    event CommentStored(
        bytes32 indexed commitment,
        bytes32 commentHash,
        address indexed user,
        uint96 additionalData,
        uint256 commentIndex
    );

    // constructor() {
    //     _disableInitializers();
    // }

    // Modifier to restrict direct calls
    // modifier onlyViaDiamond() {
    //     require(msg.sender == _diamondAddress, "CommentsFacet: call not from diamond");
    //     _;
    // }

    // Initialize function to set the diamond address
    // function initialize(address diamondAddress) public initializer {
    //     _diamondAddress = diamondAddress;
    // }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
    }

    function storeCommentAndReplaceTimestamp(bytes32 _commitment, bytes32 _commentHash, uint96 _additionalData)
        public
    {
        uint40 timestamp = uint40(block.timestamp);
        uint56 rest = uint56(_additionalData);
        uint96 newAdditionalData = uint96(uint96(timestamp) << 56) | uint96(rest);

        LibDiamondStorage.DiamondStorage storage ds = LibDiamondStorage.diamondStorage();
        LibDiamondStorage.Comment memory newComment =
            LibDiamondStorage.Comment({commentHash: _commentHash, user: msg.sender, additionalData: newAdditionalData});

        ds.commentsByCrumbCommitment[_commitment].push(newComment);
        uint256 commentIndex = ds.commentsByCrumbCommitment[_commitment].length - 1;
        emit CommentStored(_commitment, _commentHash, msg.sender, newAdditionalData, commentIndex);
    }

    function getAllCommentsByCrumbCommitment(bytes32 _commitment)
        public
        view
        returns (LibDiamondStorage.Comment[] memory)
    {
        LibDiamondStorage.DiamondStorage storage ds = LibDiamondStorage.diamondStorage();
        return ds.commentsByCrumbCommitment[_commitment];
    }
}
