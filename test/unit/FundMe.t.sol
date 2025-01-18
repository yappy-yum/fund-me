// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./helperFunction.t.sol";
import "../../script/FundMe.s.sol";

contract FundMe__test is Test {
    FundMe fundme;
    helperTestFunction HelperTestFunction;
    
    function setUp() external {    
        // method #1:
        // Deploy_FundMe deploy_FundMe = new Deploy_FundMe();
        // fundme = deploy_FundMe.run();

        Deploy_FundMe deploy_FundMe = new Deploy_FundMe();
        fundme = deploy_FundMe.run();
        
        HelperTestFunction = new helperTestFunction(fundme);
    }
    
    ////////////////////////////////////////////////////////
    ////////////// test chainlink function /////////////////
    ////////////////////////////////////////////////////////

    function testVersionAndOwner() external view {
        (uint version, string memory desc) = fundme.getVersion();
        
        console.log("contract address:", address(fundme.getpriceFeed()));
        console.log("chainlink price feed version", version);
        console.log("description:", desc);

        assertEq(version, 4);

        assertEq(fundme.getowner(), address(123));
        assertEq(fundme.getMINIMUM_USD(), 5);
    }

    function testPricePerToken() external view {
        // unicode significantly exhaust lots of gas than ASCII (string)
        console.log(unicode"1 ETH ≈ USD", fundme.checkPrice(1));
    }

    ////////////////////////////////////////////////////////
    ///////////////// test fail & revert ///////////////////
    ////////////////////////////////////////////////////////

    function testFailDonateAndWithdraw() external {
        // sending ETH amount that doesnt met the minimum requirement
        // 0.0001 ether ≈ USD 0.30 (at the time of writing)
        fundme.donate{value: 0.0001 ether}();
        fundme.donate{value: 1 gwei}();
        fundme.donate{value: 1 wei}();

        // calling withdraw() being not the owner
        fundme.withdraw();
    }

    ////////////////////////////////////////////////////////
    ////// test donation & withdrawal (first phase) ////////
    ////////////////////////////////////////////////////////
    
    function testFirstPhase() external {
        uint m_phase = fundme.getphase();
        
        // 1. ensures that the FundMe event is in first phase
        assertEq(m_phase, 1);

        // 2. ensures that this phase contain 0 ETH
        assertEq(fundme.getTotalFunded(m_phase), 0);

        // 3. donation
        //  - first donor: address(1)
        HelperTestFunction.testDonation(address(1), 50 ether, 30 ether);
        //  - second donor: address(2)
        HelperTestFunction.testDonation(address(2), 30 ether, 10 ether);

        // 4. check owner & contract balances
        HelperTestFunction.testOwnerAndContractBalance(0 ether, 40 ether);

        // 5. withdrawal
        HelperTestFunction.testWithdraw(40);

        // 6. check owner and contract balances
        HelperTestFunction.testOwnerAndContractBalance(40 ether, 0 ether);

        // 7. ensures that phase has incremented
        assertEq(fundme.getphase(), 2);
    }

    function testMultiplePhase() external {
        // -- first phase
        this.testFirstPhase();
        HelperTestFunction.testOwnerAndContractBalance(40 ether, 0 ether);

        // -- second phase
        assertEq(fundme.getphase(), 2);
        // -- donate
        HelperTestFunction.testDonation(address(10), 100 ether, 25 ether);
        HelperTestFunction.testDonation(address(20), 100 ether, 50 ether);
        HelperTestFunction.testDonation(address(30), 100 ether, 75 ether);
        HelperTestFunction.testDonation(address(40), 100 ether, 90 ether);
        HelperTestFunction.testDonation(address(50), 100 ether, 99 ether);

        HelperTestFunction.testOwnerAndContractBalance(40 ether, 339 ether);

        // -- withdraw
        HelperTestFunction.testWithdraw(339);
        HelperTestFunction.testOwnerAndContractBalance(379 ether, 0 ether);
        
        // -- third phase
        assertEq(fundme.getphase(), 3);
        // -- donate
        HelperTestFunction.testDonation(address(60), 100 ether, 25 ether);
        HelperTestFunction.testDonation(address(70), 100 ether, 50 ether);
        HelperTestFunction.testDonation(address(80), 100 ether, 75 ether);
        HelperTestFunction.testDonation(address(90), 100 ether, 90 ether);

        HelperTestFunction.testOwnerAndContractBalance(379 ether, 240 ether);

        // -- withdraw
        HelperTestFunction.testWithdraw(240);
        HelperTestFunction.testOwnerAndContractBalance(619 ether, 0 ether); // owner has 619 ether

        assertEq(fundme.getphase(), 4);

        // -- check funds history -- //
        // -- check phase
        assertEq(fundme.getTotalFunded(1), 40); // 1st phase: collected 40 ether
        assertEq(fundme.getTotalFunded(2), 339); // 2nd phase: collected 339 ether
        assertEq(fundme.getTotalFunded(3), 240); // 3rd phase: collect 240 ether
        
        // -- check funder history -- //
        // -- first phase
        assertEq(fundme.getFunders(1, address(1)), 30); // address(1) donated 30 ether
        assertEq(fundme.getFunders(1, address(2)), 10); // address(2) donated 10 ether
        // -- second phase
        assertEq(fundme.getFunders(2, address(10)), 25); // address(10) donated 25 ether
        assertEq(fundme.getFunders(2, address(20)), 50); // address(20) donated 50 ether
        assertEq(fundme.getFunders(2, address(30)), 75); // address(30) donated 75 ether
        assertEq(fundme.getFunders(2, address(40)), 90); // address(40) donated 90 ether
        assertEq(fundme.getFunders(2, address(50)), 99); // address(50) donated 99 ether
        // -- third phase
        assertEq(fundme.getFunders(3, address(60)), 25); // address(60) donated 25
        assertEq(fundme.getFunders(3, address(70)), 50); // address(70) donated 50
        assertEq(fundme.getFunders(3, address(80)), 75); // address(80) donated 75
        assertEq(fundme.getFunders(3, address(90)), 90); // address(90) donated 90
    }
}