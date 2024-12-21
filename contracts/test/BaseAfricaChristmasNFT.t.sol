// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BaseAfricaChristmasNFT} from "../src/BaseAfricaChristmasNFT.sol";
import {Whitelist} from "../src/Whitelist.sol";

contract BaseAfricaChristmasNFTTest is Test {
    BaseAfricaChristmasNFT public nft;
    Whitelist public whitelist;
    address public owner;
    address public user1;
    address public user2;
    uint16 public constant MAX_WHITELISTED_ADDRESSES = 10;

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        
        vm.startPrank(owner);
        whitelist = new Whitelist(MAX_WHITELISTED_ADDRESSES);
        nft = new BaseAfricaChristmasNFT(address(whitelist));
        vm.stopPrank();
    }

    function test_InitialState() public {
        assertEq(nft._price(), 0);
        assertEq(nft.maxTokenIds(), 1000);
        assertEq(nft.reservedTokens(), MAX_WHITELISTED_ADDRESSES);
        assertEq(nft.reservedTokensClaimed(), 0);
        assertEq(nft.owner(), owner);
    }

    function test_MintWhitelisted() public {
        // Add user1 to whitelist
        whitelist.addAddressToWhitelist(user1);
        
        vm.prank(user1);
        nft.mint();
        
        assertEq(nft.balanceOf(user1), 1);
        assertEq(nft.ownerOf(0), user1);
        assertEq(nft.reservedTokensClaimed(), 1);
    }

    function test_RevertWhenNotWhitelisted() public {
        vm.prank(user1);
        vm.expectRevert("NOT_WHITELISTED");
        nft.mint();
    }

    function test_RevertWhenMintingTwice() public {
        whitelist.addAddressToWhitelist(user1);
        
        vm.startPrank(user1);
        nft.mint();
        
        vm.expectRevert("ALREADY_OWNED");
        nft.mint();
        vm.stopPrank();
    }

    function test_RevertWhenMaxSupplyReached() public {
        // First whitelist and mint for all allowed addresses
        for(uint i = 0; i < MAX_WHITELISTED_ADDRESSES; i++) {
            address user = makeAddr(string(abi.encodePacked("user", i)));
            whitelist.addAddressToWhitelist(user);
            
            vm.prank(user);
            nft.mint();
        }
        
        // Try to mint one more with a new user
        address extraUser = makeAddr("extraUser");
        vm.expectRevert("More addresses cant be added, limit reached");
        whitelist.addAddressToWhitelist(extraUser);
    }

    function test_WithdrawByOwner() public {
        // First add some ETH to the contract
        vm.deal(address(nft), 1 ether);
        
        uint256 initialBalance = owner.balance;
        
        vm.prank(owner);
        nft.withdraw();
        
        assertEq(address(nft).balance, 0);
        assertEq(owner.balance, initialBalance + 1 ether);
    }

    function test_RevertWithdrawByNonOwner() public {
        vm.deal(address(nft), 1 ether);
        
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", user1));
        nft.withdraw();
    }

    function testFuzz_MintWhitelisted(address user) public {
        vm.assume(user != address(0));
        // Ensure the address is an EOA (has no code)
        vm.assume(user.code.length == 0);
        
        whitelist.addAddressToWhitelist(user);
        
        vm.prank(user);
        nft.mint();
        
        assertEq(nft.balanceOf(user), 1);
        assertTrue(nft.ownerOf(0) == user);
    }
}