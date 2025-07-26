// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    // uint256 number = 1;
    FundMe fundMe;

    function setUp() external {
        // number += 1;
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        console.log("FundMe deployed to:", address(fundMe));
    }

    // function testDemo() public view {
    //     console.log(number);
    //     console.log("Hello World!");
    //     console.log(msg.sender);
    //     assertEq(number, 2);
    // }

    int256 public price = 5 * 1e18;

    function testMinimumDollarIsFive() public view {
        // console.log(price);
        // log number
        // 5000000000000000000
        // console.log(fundMe.MINIMUM_USD());
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        console.log(address(this));
        assertEq(fundMe.i_owner(), msg.sender);
        // assertEq(fundMe.i_owner(), address(this));
    }

    function testPrice() public view {
        // fundMe.fund{value: 1e18}();
        // vm.deal(address(this), 10e18);
        // fundMe.fund{value: 1e18}();
        // assertEq(fundMe.addressToAmountFunded(address(this)), 1e18);
        // assertEq(fundMe.funders(0), address(this));
        console.log(fundMe.getPrice());
        // 3753_36693323
    }

    // function testPriceFeedVersion() public view {
    //     console.log(fundMe.getVersion());
    //     // 4
    //     assertEq(fundMe.getVersion(), 4);
    // }
}
