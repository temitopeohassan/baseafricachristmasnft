// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Whitelist} from "../src/Whitelist.sol";

contract WhitelistTest is Test {
    Whitelist public whitelist;
    address public owner;
    address public user1;
    address public user2;
    uint8 public constant MAX_WHITELISTED_ADDRESSES = 2;

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        
        whitelist = new Whitelist(MAX_WHITELISTED_ADDRESSES);
    }

    function test_InitialState() public {
        assertEq(whitelist.maxWhitelistedAddresses(), MAX_WHITELISTED_ADDRESSES);
        assertEq(whitelist.numAddressesWhitelisted(), 0);
    }

    function test_AddAddressToWhitelist() public {
        vm.prank(user1);
        whitelist.addAddressToWhitelist();
        
        assertTrue(whitelist.whitelistedAddresses(user1));
        assertEq(whitelist.numAddressesWhitelisted(), 1);
    }

    function test_AddOtherAddressToWhitelist() public {
        whitelist.addAddressToWhitelist(user1);
        
        assertTrue(whitelist.whitelistedAddresses(user1));
        assertEq(whitelist.numAddressesWhitelisted(), 1);
    }

    function test_RevertWhenAddingSameAddressTwice() public {
        whitelist.addAddressToWhitelist(user1);
        
        vm.expectRevert("Address has already been whitelisted");
        whitelist.addAddressToWhitelist(user1);
    }

    function test_RevertWhenMaxLimitReached() public {
        // Add first address
        whitelist.addAddressToWhitelist(user1);
        // Add second address
        whitelist.addAddressToWhitelist(user2);
        
        address user3 = makeAddr("user3");
        vm.expectRevert("More addresses cant be added, limit reached");
        whitelist.addAddressToWhitelist(user3);
    }

    function test_AddressCanAddThemself() public {
        vm.prank(user1);
        whitelist.addAddressToWhitelist();
        
        assertTrue(whitelist.whitelistedAddresses(user1));
    }

    function test_AnyoneCanAddOthers() public {
        vm.prank(user1);
        whitelist.addAddressToWhitelist(user2);
        
        assertTrue(whitelist.whitelistedAddresses(user2));
    }

    function testFuzz_AddRandomAddress(address randomAddr) public {
        vm.assume(randomAddr != address(0));
        
        whitelist.addAddressToWhitelist(randomAddr);
        
        assertTrue(whitelist.whitelistedAddresses(randomAddr));
        assertEq(whitelist.numAddressesWhitelisted(), 1);
    }
} 