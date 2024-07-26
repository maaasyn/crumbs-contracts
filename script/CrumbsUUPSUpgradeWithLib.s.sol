// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

import {CrumbsUpgradeable} from "src/crumbs-uups/CrumbsUpgradeable.sol";
import {CrumbsUpgradeableV2} from "src/crumbs-uups/CrumbsUpgradeableV2.sol";

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

/**
 * @dev Sample script to deploy and upgrade contracts using UUPS
 */
contract UpgradesUUPSProxyScript is Script {
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

        address proxyOwner = CrumbsUpgradeable(proxyAddress).owner();
        console2.log("Proxy Owner: %s", address(proxyOwner));

        require(proxyOwner == deployerAddress, "Deployer is not the owner of the proxy contract");

        // Perform the upgrade
        Upgrades.upgradeProxy(proxyAddress, "CrumbsUpgradeableV2.sol", "", deployerAddress);

        vm.stopBroadcast();
    }
}
