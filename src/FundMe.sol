// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "./priceConverter.sol";

event transaction(
    string indexed message, 
    uint256 indexed ethAmount, 
    uint256 indexed totalPriceInUSD
);

error must_at_least_$5();
error notOwner();

contract FundMe {
    
    ////////////////////////////////////////////////////////
    //////////////////// state variable ////////////////////
    ////////////////////////////////////////////////////////
    
    address private immutable i_owner;
    AggregatorV3Interface private immutable i_priceFeed;
    uint private constant MINIMUM_USD = 5;
    uint private s_phase = 1; // The number of funding events currently being held

    function getowner() external view returns(address) {
        return i_owner;
    }
    function getpriceFeed() external view returns(AggregatorV3Interface) {
        return i_priceFeed;
    }
    function getMINIMUM_USD() external pure returns(uint) {
        // state variable with `constant` restrict to pure mutability
        // it embedded directly into the contract's bytecode during compilation
        // therefore don't read from the blockchain storage
        // and dont resides in blockchain
        return MINIMUM_USD; 
    }
    function getphase() external view returns(uint) {
        return s_phase;
    }
    
    ////////////////////////////////////////////////////////
    //////////////////////// mapping ///////////////////////
    ////////////////////////////////////////////////////////
    
    mapping(uint phase => mapping(address funder => uint fundedAmountInETH)) private s_Funders;
    mapping(uint phase => uint totalFundedInETH) private s_TotalFunded;

    function getFunders(uint Phase, address Funder) external view returns(uint) {
        return s_Funders[Phase][Funder];
    }
    function getTotalFunded(uint TotalFunded_phase) external view returns(uint) {
        return s_TotalFunded[TotalFunded_phase];
    }

    ////////////////////////////////////////////////////////
    /////////////////////// modifier ///////////////////////
    ////////////////////////////////////////////////////////
    
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert notOwner();
        }
        _;
    }

    ////////////////////////////////////////////////////////
    ///////////////////// constructor //////////////////////
    ////////////////////////////////////////////////////////

    constructor(address PriceFeed) {
        i_owner = msg.sender;
        i_priceFeed = AggregatorV3Interface(PriceFeed);
    }

    ////////////////////////////////////////////////////////
    //////////////// chainlink priceFeed////////////////////
    ////////////////////////////////////////////////////////

    /* get chainlink priceFeed details */
    function getVersion() public view returns(uint256 version, string memory desc) {
        return (
            i_priceFeed.version(), 
            i_priceFeed.description()
        );
    }

    /* check total price in $USD of the given token amount */
    function checkPrice(uint ethAmount) public view returns(uint256 totalPrice) {
        // returned value is in $USD with 0 decimals
        return (
            l_priceConverter.checkPrice(i_priceFeed, ethAmount)
        );
    }

    ////////////////////////////////////////////////////////
    ////////////////// funding event ///////////////////////
    ////////////////////////////////////////////////////////

    function donate() external payable {
        uint donationInETH = msg.value / 1e18;
        
        uint totalPrice = l_priceConverter.checkPrice(i_priceFeed, donationInETH);
        if (totalPrice < MINIMUM_USD) {
            revert must_at_least_$5();
        }

        s_Funders[s_phase][msg.sender] += donationInETH;
        s_TotalFunded[s_phase] += donationInETH;

        emit transaction("deposit successfully, thanks for the donation :D", donationInETH, totalPrice);
    }

    function withdraw() external onlyOwner() {
        uint bal = address(this).balance;
        
        (bool ok, ) = i_owner.call{value: bal}("");
        require(ok, "transaction failed :(");

        uint totalFundedInETH = (bal / 1e18);
        uint TotalFundedInUSD = l_priceConverter.checkPrice(i_priceFeed, totalFundedInETH);
        s_phase ++ ;

        emit transaction("withdraw successfully", totalFundedInETH, TotalFundedInUSD);
    }

}