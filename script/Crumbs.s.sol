// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Crumbs} from "src/Crumbs.sol";

contract CrumbsScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        Crumbs crumbs = new Crumbs();

        console2.log("Crumbs deployed at address: %s", address(crumbs));

        vm.stopBroadcast();
    }
}
