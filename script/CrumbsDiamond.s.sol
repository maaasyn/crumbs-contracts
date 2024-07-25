// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {CrumbsDiamond} from "src/crumbs-diamond/CrumbsDiamond.sol";
import {CommentsFacet} from "src/crumbs-diamond/CommentsFacet.sol";

contract CrumbsDiamondScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.envAddress("PUBLIC_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        CrumbsDiamond crumbsDiamond = new CrumbsDiamond();
        crumbsDiamond.initialize(address(owner));

        CommentsFacet commentsFacet = new CommentsFacet();
        commentsFacet.initialize(address(owner));

        // Add the CommentsFacet to the diamond
        crumbsDiamond.addFacet(commentsFacet.storeCommentAndReplaceTimestamp.selector, address(commentsFacet));

        console2.log("Crumbs Diamond deployed at address: %s", address(crumbsDiamond));
        console2.log("Crumbs Facet deployed at address: %s", address(commentsFacet));

        vm.stopBroadcast();
    }
}
