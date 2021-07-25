const { ethers }    = require("hardhat");
const { BigNumber } = require("ethers");

async function main() {

    //TODO add your deployment code here
    const [deployer] = await ethers.getSigners();

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });