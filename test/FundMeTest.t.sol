// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {FundMeDeploy} from "../script/FundMeDeploy.s.sol";

contract FundMeTest is Test { 
    FundMe public fundMe;

    address USER = makeAddr("user"); 
    uint256 constant SEND_VALUE = 1 ether;
    uint256 constant STARTING_BALANCE = 1000 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        FundMeDeploy fundMeDeploy = new FundMeDeploy();
        fundMe = fundMeDeploy.run();
        vm.deal(USER, STARTING_BALANCE);
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
    
    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testFundUpdatesFundedDataStructure() public funded{
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArraysOfFunders() public funded{
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }
    
    function testOnlyOwnerCanWithdraw() public funded{
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }
    
    function testWithdrawWithSingleFunder() public funded{
        // arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        // act
        //uint256 gasStart = gasleft();
        //vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        /**uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log("gas start", gasStart);
        console.log("gas end", gasEnd);
        console.log("gas price", tx.gasprice);
        console.log("Gas used: ", gasUsed);*/


        // assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingOwnerBalance, startingOwnerBalance + startingContractBalance);
        assertEq(endingContractBalance, 0);
    }   

    function testWithdrawWithMultipleFunders() public {
        // 1. arrange all the funders
        uint160 startingFunderIndex = 1;
        uint160 numberOfFunders = 10;
        for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
            //address funder = makeAddr(string.concat("funder", vm.toString(i)));
            //vm.deal(funder, STARTING_BALANCE);
            //vm.prank(funder);
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        // 2. owner act the withdraw
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // 3. assert the balances
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingOwnerBalance, startingOwnerBalance + startingContractBalance);
        assertEq(endingContractBalance, 0);

    }



}