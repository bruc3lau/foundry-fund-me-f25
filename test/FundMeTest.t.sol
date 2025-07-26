// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    // uint256 number = 1;
    FundMe fundMe;

    function setUp() external {
        // number += 1;
        fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
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
        // assertEq(fundMe.i_owner(), msg.sender);
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersion() public view {
        console.log(fundMe.getVersion());
        // 4
        assertEq(fundMe.getVersion(), 4);
    }
}
