// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "foundry-devops/src/DevOpsTools.sol";
import "../src/FundMe.sol";

// 1. call donate() 
// 2. call withdraw()

contract DonateAndWithdrawFundMe is Script {

    function donateFundMe(address MostRecentlyDeployed) public {
        
        vm.deal(address(300), 10 ether);
        
        vm.startBroadcast(address(300));
        FundMe(
            payable(MostRecentlyDeployed)
        ).donate{value: 1 ether}();        
        vm.stopBroadcast();

    }
    function withdrawFundMe(address MostRecentlyDeployed) public {
        vm.startBroadcast(address(123));
        FundMe(
            MostRecentlyDeployed
        ).withdraw();
        vm.stopBroadcast();
    }
    function run() external {
        address MostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        donateFundMe(MostRecentlyDeployed);
        withdrawFundMe(MostRecentlyDeployed);
    }
}