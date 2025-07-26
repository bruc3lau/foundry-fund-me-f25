// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external {
        vm.startBroadcast();
        FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        vm.stopBroadcast();

        console.log("FundMe deployed to:", address(fundMe));
    }
}
