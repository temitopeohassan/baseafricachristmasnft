// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract BaseAfricaChristmasNFT is ERC721Enumerable, Ownable {
    // Price set to 0 since it's free for whitelisted members
    uint256 constant public _price = 0 ether;

    // Set your desired max supply
    uint256 constant public maxTokenIds = 1000;

    // Whitelist contract instance
    Whitelist whitelist;

    // Track claimed tokens
    uint256 public reservedTokens;
    uint256 public reservedTokensClaimed = 0;

    // Add this line near the top with other constants
    string public constant BASE_URI = "https://puredelightfoods.com/metadata.json";

    constructor (address whitelistContract) ERC721("Base Africa Christmas NFT", "BACNFT") Ownable(msg.sender) {
        whitelist = Whitelist(whitelistContract);
        reservedTokens = whitelist.maxWhitelistedAddresses();
    }

    function mint() public payable {
        require(totalSupply() < maxTokenIds, "EXCEEDED_MAX_SUPPLY");
        
        // Only allow whitelisted addresses to mint
        require(whitelist.whitelistedAddresses(msg.sender), "NOT_WHITELISTED");
        
        // Make sure user doesn't already own an NFT
        require(balanceOf(msg.sender) == 0, "ALREADY_OWNED");
        
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
        reservedTokensClaimed += 1;
    }

    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Override tokenURI function
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        // This will revert if the token doesn't exist
        ownerOf(tokenId);
        return BASE_URI;
    }

    // Override supportsInterface function
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Add this helper function at the bottom of the contract
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}