// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error FoundMe__NotOwner();

//880428
//841101
contract FundMe {
    using PriceConverter for uint256;
    // uint256 public myValue = 1;
    // uint256 public constant miniMumUsd = 5 * 1e18;

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 1e18;
    AggregatorV3Interface public s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        // myValue = myValue + 2;
        require(
            // getConversionRate(msg.value) >= miniMumUsd,
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "didnot send enough ETH!"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        // return
        //     AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
        //         .version();
        return s_priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 price, , , ) = s_priceFeed.latestRoundData();
        return uint256(price);
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function withdraw() public onlyOwner {
        // require(owner == msg.sender, "Must by owner");
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset
        // funders = new address[](0);
        //transfer
        // payable(msg.sender).transfer(address(this).balance);
        //send
        // bool sendSucess = payable(msg.sender).send(address(this).balance);
        // require(sendSucess, "Send failed");
        //call
        // (bool callSucess, bytes memory dataReturned) = payable(msg.sender).call{
        (bool callSucess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSucess, "Call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Sender is not owner");
        _;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    function getAddressToAmountFunded(
        address funder
    ) public view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    // uint256 public test;

    // function testFunc() public payable {
    //     test = msg.value.getConversionRate2();
    // }

    // int256 public getEthPrice;
    // function getPrice() internal {
    // function getPrice() public {
    //     //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //     //ABI
    //     AggregatorV3Interface feed = AggregatorV3Interface(
    //         0x694AA1769357215DE4FAC081bf1f309aDC325306
    //     );
    //     // (
    //     //     uint80 roundId,
    //     //     int256 answer,
    //     //     uint256 startedAt,
    //     //     uint256 updatedAt,
    //     //     uint80 answeredInRound
    //     // ) = feed.latestRoundData();
    //     (, int256 price, , , ) = feed.latestRoundData();
    //     getEthPrice = price;
    // }
}
