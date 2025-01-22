# Fund Me Contract

**A smart contract powered by Chainlink that enables secure donations with real-time token price conversions.**

- Fetches real-time token price using Chainlink Price Feeds.
- Users can make donations to the contract using token they choose.
- Owner-only withdrawal functionality to manage funds securely.
- Transparent event logging for donations and withdrawals.

<br>

## 🎯 Requirements

- [Visual Studio Code](https://code.visualstudio.com/download): A code editor for Solidity and project files
- [Git](https://git-scm.com/downloads): Best terminal for managing your project.
- [Foundry](https://getfoundry.sh): A development environment for Solidity smart contracts.
- [Alchemy API Key](https://www.alchemy.com): Required to connect to Ethereum Mainnet or Sepolia.

To verify the installation, run the following command:

<br>

> **git**
> ``` bash
> git --version
> ```
> An ouput similar to `git version X.X.X` indicates a successful installation


> **foundry**
> ```bash
> forge --version
> ```
> An ouput similar to `forge 0.2.0 (...)` indicates a successful installation

<br>

## ⏩ Quickstart

To get all the contracts installed in your compiler, run the following command:

```bash
git clone https://github.com/yappy-yum/fund-me
```

<br>

## 🌟 Main Contract Overview

The `src` folder has two key contracts:



### 🏛️ **FundMe.sol**

The main contract with essential features:

- 🎯 **Choose Your Token:** Set a [Chainlink Price Feed Address](https://docs.chain.link/data-feeds/price-feeds) for your favorite token.
- 💸 **Donate Funds:** Call `donate()` to make a secure donation.
- 🔍 **Check Prices:** Use `checkPrice(uint ethAmount)` to view token value in USD (`ethAmount` being quantity of ETH).
- 📜 **Get Version:** Call `getVersion()` to see the Chainlink feed version.
- 🛡️ **Withdraw Donations:** Owners can securely withdraw funds using `withdraw()`.


### 🔧 **PriceConverter.sol**

This utility contract handles price calculations:

- 🔗 **Fetch Prices:** Gets token prices directly from Chainlink feeds.
- 💱 **Convert to USD:** Computes the USD value of any token quantity.


<br>

## ⚙️ Script Overview

The project includes the following scripts for deployment and testing:


### 🗂️ 1. **`chainConfig.s.sol`**
- 📌 Prepares Chainlink price feed addresses based on different networks chainid (API Key), including **SEPOLIA**, **MAINNET** and **ANVIL (local)**


### 🛠️ 2. **Mock Contracts**
- 📂 Located in the `mock` folder.
- 🧪 Mock type of contracts simulates Chainlink price feed contract for local testing on the **Anvil network**.


### 🚀 3. **`FundMe.s.sol`**
- 🏗️ Deploys the `FundMe` contract using the address provided by `chainConfig.s.sol`.


### 🔄 4. **`interactions.s.sol`**
- ⚙️ Extends `FundMe.s.sol` with DevOps testing functionality.
- 🎯 **Focus Areas:**
  - **`donate()`** function.
  - **`withdraw()`** function.


<br>

## 🧪 Foundry Test Overview

The project employs two types of tests: **Unit Tests** and **Integration Tests**.
For testing purposes, price feed address with the conversion of **ETH/USD** is used.


### 1.  **Unit Tests**
- 🏗️ Validate the overall functionality of the `FundMe` contract deployed by `FundMe.s.sol`.
- 🧩 **Details:**
  - All test cases are written in **`FundMe.t.sol`**.
  - Includes helper functions defined in **`helperFunction.t.sol`**.


### 2.  **Integration Tests**
- 🎯 Focus on specific critical functions.
- 🔍 **Details:**  
  - Tests the **`donate()`** and **`withdraw()`** functions in isolation.


<br>

## 🚀 Running test Contracts: A Brief Guide

Follow these steps to deploy and test your contracts effectively:

### 🛠️ 1. Ensuring Correct Price Feed Address

To verify that the price feed address is implemented correctly, execute the deployment script with the following command:

> Run script
> ```bash
> forge script /script/FundMe.s.sol --rpc-url http://<ANVIL RPC>
> ```
>
> ✅ Expected Output Example:
> ```bash
> == Return ==
> 0: contract FundMe 0x......
> ```

### 🔄 2. Testing the Deployment

To ensure smooth deployment and proper functionality, run the test files as outlined below:

> ⚙️ Run Unit Tests `FundMe.t.sol`
> ```bash
> forge test --match-path test/unit/FundMe.t.sol --fork-url <ALCHEMY FORK URL>
> ```
>
> ✅ Expected Output Example:
> ```bash
> Ran 5 tests for test/unit/FundMe.t.sol:FundMe__test
> [PASS] testFailDonateAndWithdraw() (gas: 26910)
> [PASS] testFirstPhase() (gas: 187040)
> [PASS] testMultiplePhase() (gas: 785393)
> [PASS] testPricePerToken() (gas: 24412)
> [PASS] testVersionAndOwner() (gas: 26961)
> Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 2.98ms (2.78ms CPU time)
> ```

### 🔍 3. Run Integration Tests `interaction.t.sol`
> ```bash
> forge test --match-path test/integration/interation.t.sol --fork-url <ALCHEMY FORK URL>
> ```
> ✅ Expected Output Example:
> ```bash
> Ran 1 test for test/integration/interation.t.sol:FundMe__testIntegration
> [PASS] testDonationAndWithdrawalFundMe() (gas: 1892759)
> Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 9.00s (3.00s CPU time)
>
> Ran 1 test suite in 10.28s (9.00s CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
> ```


<br>

## 🛠️ Final Notes and Resources

- For more details on Foundry's built-in features, refer to the official [Foundry Book](https://book.getfoundry.sh).  
- The `FundMe.sol` contract's functionality is thoroughly demonstrated in the unit test file `test/unit/FundMe.t.sol`, particularly in **`testFirstPhase()` function** and **`testMultiplePhase()` function**.  

### ⚡ **Note:** Due to the in-depth testing, these test functions contained higher gas costs.


<br>

## 🙏 Attribution

This portfolio project was inspired and made possible by the guidance and resources provided by **Cyfrin Updraft**: [github](https://github.com/Cyfrin/foundry-full-course-cu)/[official website](https://www.cyfrin.io/updraft).  
