require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('hardhat-gas-reporter');
require('hardhat-deploy');
require('dotenv').config();

const env = process.env;

module.exports = {
    solidity: {
        compilers: [{
            version: '0.8.0', settings: {
                optimizer: {enabled: true},
            },
        },]
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            live: false,
            saveDeployments: true,
            tags: ["test", "local"]
        },
        rinkeby: {
            url: `https://eth-rinkeby.alchemyapi.io/v2/${env.ALCHEMY_API_KEY}`,
            accounts: [`0x${env.RINKEBY_PRIVATE_KEY}`],
            live: true,
            saveDeployments: true,
            tags: ["test"]
        },
        mainnet: {
            url: `https://eth-mainnet.alchemyapi.io/v2/${env.ALCHEMY_API_KEY}`,
            accounts: [`0x${env.MAINNET_PRIVATE_KEY}`],
            live: true,
            saveDeployments: true,
            tags: ["release"] }
    },
    etherscan: {
        apiKey: `${env.ETHERSCAN_API_KEY}`
    },
    paths: {
        sources: "./contracts",
        tests: "./test",
        cache: "./cache",
        artifacts: "./artifacts"
    },
    gasReporter: {
        currency: 'USD',
    }
};
