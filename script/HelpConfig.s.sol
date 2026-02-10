// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
//import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

// Script to use vm to broadcast the transaction
contract HelperConfig is Script{
    // If we are on a local anvil, we'll deploy mocks!
    // Otherwise, grab the existing address from the live network!

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig{
        address priceFeed;
    }

    constructor() {
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }else{
            activeNetworkConfig = getAnvilEthConfig();
        }
    }



    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public pure returns(NetworkConfig memory){
        // price feed address

        // 1. deploy the mocks


        // 2. return the mock address

    }

}