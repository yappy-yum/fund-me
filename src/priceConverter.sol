// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library l_priceConverter {
    function pricePerToken(AggregatorV3Interface priceFeed) internal view returns(uint) {
        ( , int256 answer, , , ) = priceFeed.latestRoundData();
        // `answer` contain 8 decimals  
        // multiply by 10 zeros to have 18 decimals 
        // ethereum contains 18 decimals
        return uint(answer * 10_000_000_000);

        // returns: 2000000000000000000000
        // real value: 2000.000_000_000_000_000_000 (18 deciamals)
        // ≈ USD 2000.00
    }

    function checkPrice(AggregatorV3Interface priceFeed, uint ethAmount) internal view returns(uint) {
        uint totalPrice = pricePerToken(priceFeed) * ethAmount;
        // totalPrice contain 18 decimals
        // remove all the decimals to return a whole value

        // totalPrice: 2000000000000000000000
        // real value: 2000.000_000_000_000_000_000 (18 deciamals)
        return (totalPrice / 1_000_000_000_000_000_000);
        // after removed: 2000
        // ≈ USD 2000
    } 
}