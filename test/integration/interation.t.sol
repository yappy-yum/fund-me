// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/FundMe.sol";
import "../../script/FundMe.s.sol";
import "../../script/interactions.s.sol";

contract FundMe__testIntegration is Test {
    
    FundMe fundme;
    function setUp() external {
        Deploy_FundMe deploy_fundMe = new Deploy_FundMe();
        fundme = deploy_fundMe.run();
    }

    function testDonationAndWithdrawalFundMe() public {
        address Fundme = address(fundme);
        address Owner = address(123);

        DonateAndWithdrawFundMe DonateAndWithdrawFundme = new DonateAndWithdrawFundMe();
        
        // before donation
        assertEq(Fundme.balance, 0 ether);
        assertEq(Owner.balance, 0 ether);

        // after donation
        DonateAndWithdrawFundme.donateFundMe(Fundme);
        assertEq(Fundme.balance, 1 ether);
        assertEq(Owner.balance, 0 ether);

        // after withdrawal
        DonateAndWithdrawFundme.withdrawFundMe(Fundme);
        assertEq(Fundme.balance, 0 ether);
        assertEq(Owner.balance, 1 ether);

        // - check donor
        assertEq(fundme.getTotalFunded(1), 1);
        assertEq(fundme.getFunders(1, address(300)), 1);

        // - check phase
        assertEq(fundme.getphase(), 2);
    }
}