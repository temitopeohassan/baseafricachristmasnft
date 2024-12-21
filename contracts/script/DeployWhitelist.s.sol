// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Whitelist} from "../src/Whitelist.sol";

contract DeployWhitelistScript is Script {
    Whitelist public whitelist;
    uint16 public constant MAX_WHITELISTED_ADDRESSES = 1000;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        whitelist = new Whitelist(MAX_WHITELISTED_ADDRESSES);
        console.log("Whitelist deployed to:", address(whitelist));
        vm.stopBroadcast();
    }
} 