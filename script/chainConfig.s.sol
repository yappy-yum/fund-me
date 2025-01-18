// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1

import "forge-std/Script.sol";
import "./mock contract/mockV3Aggregator.s.sol";

contract chainConfig {
    struct networkConfig {
        address priceFeed;
    }
    networkConfig public activeNetwork;

    constructor() {
        if (block.chainid == 11155111) {
            // sepolia testnet 
            activeNetwork = add_testNet();
        
        } else if (block.chainid == 1) {
            // ethereum mainnet
            activeNetwork = add_mainNet();
        
        } else {
            // avail network: no --fork-url Alchemy link
            activeNetwork = add_avil();
        }
    }

    function add_testNet() public pure returns(networkConfig memory) {
        networkConfig memory networkTestNet = networkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return networkTestNet;
    }

    function add_mainNet() public pure returns(networkConfig memory) {
        networkConfig memory networkMainNet = networkConfig ({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return networkMainNet;
    }

    // avail network: no --fork-url Alchemy link
    function add_avil() public returns(networkConfig memory) {
        if (activeNetwork.priceFeed != address(0)) {
            return activeNetwork;
        }

        // new MockV3Aggregator(uint8 _decimals, int256 _initialAnswer);
        MockV3Aggregator MockContract = new MockV3Aggregator(8, 2_000e8);
        
        // avail contract address: networkAvail
        networkConfig memory networkAvail = networkConfig ({
            priceFeed: address(MockContract)
        });
        return networkAvail;
    }

}