# Building

## Project Setup
The project can be compiled, tested and deployes using [HardHat](https://hardhat.org/).

Secret keys shall be set the first time this repository is cloned:

```sh
cp env.example .env
```

and then edit the keys defines is this file as described in the following table.

| Key                     | Description |
| ----------------------- | ----------- |
| ``DEBUG``               | If set to ``true`` the code will not be optimized |
| ``ALCHEMY_API_KEY``     | Tke [Alchemy](https://docs.alchemy.com/alchemy/introduction/getting-started) API key        |
| ``RINKEBY_PRIVATE_KEY`` | The Rinkeby private key used for deployng the contract  |
| ``MAINNET_PRIVATE_KEY`` | The main net private key used for deployng the contract |
| ``ETHERSCAN_API_KEY``   | The [Ethescan](https://etherscan.io/apis) API key       |

## Compile and Test

 ```sh
npx run compile
npx run test
```

## Deploy

On the Rinkebit test net:
 ```sh
npx run deploy-rinkeby
```

On the Main-Net:
 ```sh
npx run deploy-mainnet
```

The deployment status is printed in your console as:
 ```sh
$ run deploy-rinkeby

=========================
TEST DEPLOYMENT COMPLETED
=========================

Deployed addresses:
- UC1:  0x8c83dee986200BaC4C97B597E6fF005B7eea3500
- UC2:  0xbeF9e747c9Da8A15b6633e7c7233A1164d687e4b
- NCT:  0x73bB34638F457eB9eb1776C7Ff663aA986e78247
- NFT:  0x95d1D1a2291dd7618c3681554A8d81f6a4f1Df25


To launch etherscan verification please run:
npx hardhat verify --network rinkeby  0x73bB34638F457eB9eb1776C7Ff663aA986e78247   10000000000000000000000
npx hardhat verify --network rinkeby  0x8c83dee986200BaC4C97B597E6fF005B7eea3500   0x73bB34638F457eB9eb1776C7Ff663aA986e78247
npx hardhat verify --network rinkeby  0x95d1D1a2291dd7618c3681554A8d81f6a4f1Df25
npx hardhat verify --network rinkeby  0xbeF9e747c9Da8A15b6633e7c7233A1164d687e4b   0x95d1D1a2291dd7618c3681554A8d81f6a4f1Df25   0x73bB34638F457eB9eb1776C7Ff663aA986e78247
```

The verification instructions are required in order to obtain the etherscan verification of your contract.