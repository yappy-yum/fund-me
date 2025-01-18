-include .env

# compile all the codes
build:; forge build

# deploy original contract (SRC)
DEPLOYCONTRACT:; forge create src/FundMe.sol:FundMe --rpc-url $(RPC_URL) --interactive

# deploy and run script contract (script)
DEPLOYSCRIPT:; forge script script/FundMe.s.sol --rpc-url $(RPC_URL)

# deploy and run test file
DEPLOYTEST_ANVIL:; forge test --match-path test/unit/FundMe.t.sol
DEPLOYTEST_TESTNET:; forge test --match-path test/unit/FundMe.t.sol --fork-url $(FORK_URL_SEPOLIA)
DEPLOYTEST_MAINNET:; forge test --match-path test/unit/FundMe.t.sol --fork-url $(FORK_URL_MAINNET)

DEPLOYTEST_ANVIL_VV:; forge test --match-path test/unit/FundMe.t.sol -vv
DEPLOYTEST_TESTNET_VV:; forge test --match-path test/unit/FundMe.t.sol -vv --fork-url $(FORK_URL_SEPOLIA)
DEPLOYTEST_MAINNET_VV:; forge test --match-path test/unit/FundMe.t.sol -vv --fork-url $(FORK_URL_MAINNET)

DEPLOYTEST_ANVIL_VVV:; forge test --match-path test/unit/FundMe.t.sol -vvv
DEPLOYTEST_TESTNET_VVV:; forge test --match-path test/unit/FundMe.t.sol -vvv --fork-url $(FORK_URL_SEPOLIA)
DEPLOYTEST_MAINNET_VVV:; forge test --match-path test/unit/FundMe.t.sol -vvv --fork-url $(FORK_URL_MAINNET)

DEPLOYTEST_ANVIL_VVVV:; forge test --match-path test/unit/FundMe.t.sol -vvvv
DEPLOYTEST_TESTNET_VVVV:; forge test --match-path test/unit/FundMe.t.sol -vvvv --fork-url $(FORK_URL_SEPOLIA)
DEPLOYTEST_MAINNET_VVVV:; forge test --match-path test/unit/FundMe.t.sol -vvvv --fork-url $(FORK_URL_MAINNET)

DEPLOYTEST_ANVIL_VVVVV:; forge test --match-path test/unit/FundMe.t.sol -vvvvv
DEPLOYTEST_TESTNET_VVVVV:; forge test --match-path test/unit/FundMe.t.sol -vvvvv --fork-url $(FORK_URL_SEPOLIA)
DEPLOYTEST_MAINNET_VVVVV:; forge test --match-path test/unit/FundMe.t.sol -vvvvv --fork-url $(FORK_URL_MAINNET)