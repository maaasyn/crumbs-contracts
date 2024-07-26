// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {CrumbsUpgradeable} from "src/crumbs-uups/CrumbsUpgradeable.sol";
// import {CrumbsUpgradeableV2} from "src/crumbs-uups/CrumbsUUPSv2.sol";

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

/**
 * @dev Sample script to deploy and upgrade contracts using UUPS
 */
contract ReadProxyComments is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.envAddress("PUBLIC_ADDRESS");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        console2.log("Deployer Address: %s", address(deployerAddress));
        console2.log("Proxy Address: %s", address(proxyAddress));

        // Ensure the deployer address is present
        require(deployerAddress != address(0), "Invalid deployer address");
        require(proxyAddress != address(0), "Invalid proxy address");

        vm.startBroadcast(deployerPrivateKey);

        bytes32 _commitment = keccak256("https://example.com/");

        CrumbsUpgradeable.Comment[] memory comments =
            CrumbsUpgradeable(proxyAddress).getAllCommentsByCrumbCommitment(_commitment);

        console2.log("Comments length: %s", comments.length);

        // // Read the comments
        // for (uint256 i = 0; i < comments.length; i++) {
        //     console2.log("Comment %s: %s", i, comments[i]);
        // }

        vm.stopBroadcast();
    }
}
