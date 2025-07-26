// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    //wei
    function getPrice() internal view returns (uint256) {
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI
        AggregatorV3Interface feed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        // (
        //     uint80 roundId,
        //     int256 answer,
        //     uint256 startedAt,
        //     uint256 updatedAt,
        //     uint80 answeredInRound
        // ) = feed.latestRoundData();
        (, int256 price, , , ) = feed.latestRoundData();

        //2000.00000000

        //get wei price/1e8 *1e18
        return uint256(price * 1e10);
    }

    //amount -> usd
    function getConversionRate(uint256 ethWeiAmount)
        internal
        view
        returns (uint256)
    {
        //wei
        uint256 ethWeiPrice = getPrice();
        uint256 ethWeiAmountInUsd = (ethWeiPrice * ethWeiAmount) / 1e18;
        return ethWeiAmountInUsd;
    }

      //amount -> usd
    function getConversionRate2(uint256 ethWeiAmount)
        internal
        pure 
        returns (uint256)
    {
        //wei
        uint256 ethWeiPrice = 3664_270000000000000000;
        uint256 ethWeiAmountInUsd = (ethWeiPrice * ethWeiAmount) / 1e18;
        return ethWeiAmountInUsd;
    }

    function getVersion() internal view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }
}
