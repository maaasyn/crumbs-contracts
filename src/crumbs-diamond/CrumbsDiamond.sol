// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract CrumbsDiamond is Initializable, OwnableUpgradeable {
    mapping(bytes4 => address) public facets;

    event FacetAdded(bytes4 indexed selector, address indexed facet);
    event FacetReplaced(bytes4 indexed selector, address indexed oldFacet, address indexed newFacet);

    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
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
