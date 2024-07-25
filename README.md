## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
source .env; forge script script/Crumbs.s.sol:CrumbsScript --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify

```

```sh
source .env; forge script script/Crumbs.s.sol:Crumbs --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

inspect:

```
forge inspect ./src/Crumbs.sol:Crumbs storage-layout --pretty
```

<!--
  Crumbs Diamond deployed at address: 0x498099e413aC3c0b214bA181B3787b7F637a2c21
  Crumbs Facet deployed at address: 0x51C8e2ca67F800115f16C4B18DCf17BF7Ed44f8b -->

```sh

cast calldata "storeCommentAndReplaceTimestamp(bytes32,bytes32,uint96)" 0x00238809d48a86b3a841a3f501d566475cde08f38cb75969645733a83e43306a 0x77dcd57beb1f0f2e28ea0f01df187f9912d3a78de5e0bd8abf37307a7e9b7596 0

cast send --private-key $PRIVATE_KEY --rpc-url $RPC_URL $PROXY_CONTRACT_ADDRESS $(cast calldata "storeCommentAndReplaceTimestamp(bytes32,bytes32,uint96)" 0x00238809d48a86b3a841a3f501d566475cde08f38cb75969645733a83e43306a 0x77dcd57beb1f0f2e28ea0f01df187f9912d3a78de5e0bd8abf37307a7e9b7596 0)

```

Get all comments by commitment:

```sh
source .env; cast call $PROXY_CONTRACT_ADDRESS "getAllCommentsByCrumbCommitment(bytes32)((bytes32,address,uint96)[])" 0x00238809d48a86b3a841a3f501d566475cde08f38cb75969645733a83e43306a --rpc-url $RPC_URL
[(0x77dcd57beb1f0f2e28ea0f01df187f9912d3a78de5e0bd8abf373
```

<!-- proper implementation of diamond -->

https://louper.dev/diamond/0x10e138877df69ca44fdc68655f86c88cde142d7f?network=mainnet
