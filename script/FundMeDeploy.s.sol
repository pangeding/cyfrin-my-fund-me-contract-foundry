// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelpConfig.s.sol";

contract FundMeDeploy is Script{
    function run() external returns(FundMe){
        // things before the broadcasting -> isn't real tx

        HelperConfig helperConfig = new HelperConfig();
        (address priceFeed) = helperConfig.activeNetworkConfig();

        // things after the broadcasting -> real tx
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }

}