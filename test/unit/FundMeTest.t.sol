// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    // uint256 number = 1;
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // number += 1;
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        console.log("FundMe deployed to:", address(fundMe));
        console.log("FundMe owner:", fundMe.getOwner());
        console.log("FundMe User:", USER);
        vm.deal(USER, STARTING_BALANCE);
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
        console.log("FundMe owner:", fundMe.getOwner());
        console.log("Msg.sender:", msg.sender);
        console.log("Address(this):", address(this));
        assertEq(fundMe.getOwner(), msg.sender);
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

    function testPriceFeedVersion() public view {
        console.log(fundMe.getVersion());
        // 4
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        // uint256 insufficientAmount = 4 * 1e18; // less than 5 USD
        fundMe.fund{value: 0 * 1e18}();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);

        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFounded = fundMe.getAddressToAmountFunded(USER);

        assertEq(amountFounded, SEND_VALUE);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        console.log("Funded with:", SEND_VALUE);
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        console.log("Owner:", fundMe.getOwner());

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 balanceAfter = address(fundMe).balance;
        assertEq(balanceAfter, 0);
    }

    function testWithDrawWithASingleFunder() public funded {
        uint256 balanceBefore = address(fundMe).balance;
        console.log("Balance before withdraw:", balanceBefore);

        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * GAS_PRICE;
        console.log("Gas used for withdraw:", gasUsed);

        uint256 balanceAfter = address(fundMe).balance;
        console.log("Balance after withdraw:", balanceAfter);
        assertEq(balanceAfter, 0);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint256 numberOfFunders = 10;
        for (uint256 i = 0; i < numberOfFunders; i++) {
            // vm.prank(address(uint160(i + 1))); // Prank with different addresses
            hoax(address(uint160(i + 1)), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
            console.log(
                "Funded by:",
                address(uint160(i + 1)),
                "with amount:",
                SEND_VALUE
            );
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // vm.prank(fundMe.getOwner());
        // fundMe.withdraw();

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        console.log("Starting Owner Balance:", startingOwnerBalance);
        console.log("Ending Owner Balance:", endingOwnerBalance);
        console.log("Starting FundMe Balance:", startingFundMeBalance);
        console.log("Ending FundMe Balance:", endingFundMeBalance);

        uint256 ownerGetFounded = endingOwnerBalance - startingOwnerBalance;
        console.log("Owner got funded:", ownerGetFounded);
        assertEq(ownerGetFounded, startingFundMeBalance);
        assertEq(endingFundMeBalance, 0);
    }

    function testCheaperWithdrawFromMultipleFunders() public funded {
        uint256 numberOfFunders = 10;
        for (uint256 i = 0; i < numberOfFunders; i++) {
            hoax(address(uint160(i + 1)), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
            console.log(
                "Funded by:",
                address(uint160(i + 1)),
                "with amount:",
                SEND_VALUE
            );
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        console.log("Starting Owner Balance:", startingOwnerBalance);
        console.log("Ending Owner Balance:", endingOwnerBalance);
        console.log("Starting FundMe Balance:", startingFundMeBalance);
        console.log("Ending FundMe Balance:", endingFundMeBalance);

        uint256 ownerGetFounded = endingOwnerBalance - startingOwnerBalance;
        console.log("Owner got funded:", ownerGetFounded);
        assertEq(ownerGetFounded, startingFundMeBalance);
        assertEq(endingFundMeBalance, 0);
    }
}
