// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {CrumbsUpgradeable} from "src/crumbs-uups/CrumbsUUPS.sol";

contract CrumbsUpgradeableScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.envAddress("PUBLIC_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        CrumbsUpgradeable crumbsUpgradeable = new CrumbsUpgradeable();
        crumbsUpgradeable.initialize(address(owner));

        console2.log("Crumbs UUPS deployed at address: %s", address(crumbsUpgradeable));

        vm.stopBroadcast();
    }
}
