// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {CrumbsUpgradeable} from "src/crumbs-uups/CrumbsUUPS.sol";
import {CrumbsUpgradeableV2} from "src/crumbs-uups/CrumbsUUPSv2.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract CrumbsUpgradeableV2Script is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.envAddress("PUBLIC_ADDRESS");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");
        address v2Address = vm.envAddress("V2_CONTRACT_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the new implementation
        // CrumbsUpgradeableV2 crumbsUpgradeableV2 = new CrumbsUpgradeableV2();
        // crumbsUpgradeableV2.initialize(owner);
        // console2.log("CrumbsUpgradeableV2 implementation deployed at: %s", address(crumbsUpgradeableV2));

        // Get the proxy contract
        CrumbsUpgradeable proxy = CrumbsUpgradeable(proxyAddress);

        CrumbsUpgradeableV2 v2crumbs = CrumbsUpgradeableV2(v2Address);

        // v2.initialize(owner);x/
        //print owner
        console2.log("Owner of CrumbsUpgradeable: %s", proxy.owner());
        console2.log("Owner of CrumbsUpgradeableV2: %s", v2crumbs.owner());

        // v2
        //     .proxy
        // v2.initialize(owner);
        // console2.log("Owner of CrumbsUpgradeableV2: %s", ownerV2);

        // Upgrade the proxy to the new implementation
        proxy.upgradeToAndCall(address(v2crumbs), "");

        console2.log("Proxy upgraded to CrumbsUpgradeableV2");

        vm.stopBroadcast();
    }
}
