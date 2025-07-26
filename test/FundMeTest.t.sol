// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

contract FundMeTest is Test {
    uint256 number = 1;

    function setUp() external {
        number += 1;
    }

    function testDemo() public view {
        console.log(number);
        console.log("Hello World!");
        console.log(msg.sender);
        assertEq(number, 2);
    }
}
