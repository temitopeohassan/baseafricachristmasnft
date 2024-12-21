// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {BaseAfricaChristmasNFT} from "../src/BaseAfricaChristmasNFT.sol";

contract DeployNFTScript is Script {
    BaseAfricaChristmasNFT public nft;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address whitelistAddress = vm.envAddress("WHITELIST_ADDRESS");
        
        vm.startBroadcast(deployerPrivateKey);
        nft = new BaseAfricaChristmasNFT(whitelistAddress);
        console.log("BaseAfricaChristmasNFT deployed to:", address(nft));
        vm.stopBroadcast();
    }
} 