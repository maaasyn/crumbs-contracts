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

pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";

contract Diamond is Initializable {
    mapping(bytes4 => address) public facets;

    event FacetAdded(bytes4 indexed selector, address indexed facet);
    event FacetReplaced(bytes4 indexed selector, address indexed oldFacet, address indexed newFacet);

    function initialize() public initializer {
        // Initialization code here
    }

    fallback() external payable {
        address facet = facets[msg.sig];
        require(facet != address(0), "Function does not exist");
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    function addFacet(bytes4 _selector, address _facet) external {
        require(facets[_selector] == address(0), "Facet already exists");
        facets[_selector] = _facet;
        emit FacetAdded(_selector, _facet);
    }

    function replaceFacet(bytes4 _selector, address _newFacet) external {
        address oldFacet = facets[_selector];
        require(oldFacet != address(0), "Facet does not exist");
        facets[_selector] = _newFacet;
        emit FacetReplaced(_selector, oldFacet, _newFacet);
    }
}

pragma solidity ^0.8.20;

import "./LibDiamondStorage.sol";

contract CommentsFacet {
    event CommentStored(
        bytes32 indexed commitment,
        bytes32 commentHash,
        address indexed user,
        uint96 additionalData,
        uint256 commentIndex
    );

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
