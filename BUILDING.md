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
| ``ALCHEMY_API_KEY``     | Tke [Alchemy](https://docs.alchemy.com/alchemy/introduction/getting-started) API key        |
| ``RINKEBY_PRIVATE_KEY`` | The Rinkeby private key used for deployng the contract  |
| ``MAINNET_PRIVATE_KEY`` | The main net private key used for deployng the contract |
| ``ETHERSCAN_API_KEY``   | The [Ethescan](https://etherscan.io/apis) API key       |

## Compile and Test

 ```sh
npm run compile
npm run test
```

## Deploy

On the Rinkebit test net:
 ```sh
npm run deploy-rinkeby
```

On the Main-Net:
 ```sh
npm run deploy-mainnet
```
