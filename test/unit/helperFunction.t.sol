// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/FundMe.sol";

contract helperTestFunction is Test {
    FundMe immutable private i_fundme;
    
    constructor(FundMe fundMe) {
        i_fundme = fundMe;
    }

    // expect event emit
    function testEmitEvent_donate(uint ethAmount) private {
        vm.expectEmit(true, true, false, true);
        emit transaction(
            "deposit successfully, thanks for the donation :D",
            ethAmount,
            i_fundme.checkPrice(ethAmount)
        );
    }
    function testEmitEvent_Withdraw(uint addressBalInETH) private {                      
        vm.expectEmit(true, true, false, true);
        emit transaction(
            "withdraw successfully",
            addressBalInETH,
            i_fundme.checkPrice(addressBalInETH)
        );
    }

    // check ETH balance
    function testOwnerAndContractBalance(
        uint OwnerBalance, 
        uint ContractBalance
    ) external view {
        assertEq(
            address(123).balance,
            OwnerBalance
        );
        assertEq(
            address(i_fundme).balance,
            ContractBalance
        );
    }
    function testFunderBalance(
        address Funder,
        uint FunderETHBalance
    ) private view {
        assertEq(
            address(Funder).balance,
            FunderETHBalance
        );
    }

    // add donor for donation
    function testDonation(
        address Funder, 
        uint FunderBalanceBeforeFunded,
        uint FundAmount
    ) external {
        uint m_fundAmount = FundAmount / 1e18;

        // 1. expect emit
        testEmitEvent_donate(m_fundAmount);
        // 2. donor
        hoax(address(Funder), FunderBalanceBeforeFunded);
        i_fundme.donate{value: FundAmount}();
        // 3. check funder balance
        testFunderBalance(
            address(Funder),
            FunderBalanceBeforeFunded - FundAmount
        );

    }

    // owner withdraw
    function testWithdraw(uint addressBalInETH) external {
        testEmitEvent_Withdraw(addressBalInETH);

        vm.prank(address(123));
        i_fundme.withdraw();
    }
}