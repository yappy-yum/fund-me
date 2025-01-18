// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "./chainConfig.s.sol";
import "../src/FundMe.sol";

contract Deploy_FundMe is Script {

    FundMe fundme;
    
    function run() external returns (FundMe) {
        // method #1: (without using chainConfig.s.sol)
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // return fundme
        
        chainConfig contAddr = new chainConfig(); 
        // contAddr stores deployed contract address
        // not the address returned from the function called
        // constructor wont return any values
        (address Addr) = contAddr.activeNetwork();
        
        
        // making msg.sender who deploy FundMe contract as address(123)
        vm.deal(address(123), 0 ether);
        
        vm.startBroadcast(address(123));
        fundme = new FundMe(Addr);
        vm.stopBroadcast();


        return fundme;
    }
}