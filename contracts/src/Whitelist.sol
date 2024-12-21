// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Whitelist {

    // Max number of whitelisted addresses allowed
    uint16 public maxWhitelistedAddresses;

    // Create a mapping of whitelistedAddresses
    // if an address is whitelisted, we would set it to true, it is false by default for all other addresses.
    mapping(address => bool) public whitelistedAddresses;

    // numAddressesWhitelisted would be used to keep track of how many addresses have been whitelisted
    uint16 public numAddressesWhitelisted;

    // Setting the Max number of whitelisted addresses
    // User will put the value at the time of deployment
    constructor(uint16 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses =  _maxWhitelistedAddresses;
    }

    /**
        addAddressToWhitelist - This function adds the sender's address to the whitelist
     */
    function addAddressToWhitelist() public {
        addAddressToWhitelist(msg.sender);
    }

    /**
        addAddressToWhitelist - This function adds any specified address to the whitelist
        @param _address The address to be whitelisted
     */
    function addAddressToWhitelist(address _address) public {
        // check if the address has already been whitelisted
        require(!whitelistedAddresses[_address], "Address has already been whitelisted");
        // check if the numAddressesWhitelisted < maxWhitelistedAddresses, if not then throw an error.
        require(numAddressesWhitelisted < maxWhitelistedAddresses, "More addresses cant be added, limit reached");
        // Add the specified address to the whitelistedAddress mapping
        whitelistedAddresses[_address] = true;
        // Increase the number of whitelisted addresses
        numAddressesWhitelisted += 1;
    }

}