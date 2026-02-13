// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {FundMeDeploy} from "../script/FundMeDeploy.s.sol";

contract FundMeTest is Test { 
    FundMe public fundMe;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        FundMeDeploy fundMeDeploy = new FundMeDeploy();
        fundMe = fundMeDeploy.run();
    }

    function testMinUSDIsFive() public {
        //console.log("MinUSD: ", fundMe.MINIMUM_USD());
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        //console.log("Owner: ", fundMe.i_owner());
        //console.log("Msg.sender: ", msg.sender);
        //assertEq(fundMe.i_owner(), msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
        // before use script to deploy, 
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }


    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }
    
    function testFundUpdatesFundedDataStructure() public {
        fundMe.fund{value:1e18}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(address(this));
        assertEq(amountFunded, 1e18);
    }

    
}