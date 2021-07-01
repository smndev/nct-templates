const { ethers }    = require("hardhat");
const { BigNumber } = require("ethers");

async function main() {

    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const NCT = await ethers.getContractFactory("NCT");
    const nct = await NCT.deploy("100000");

    console.log("NCT deployed at:",  await nct.address);
    console.log("NCT total supply:", BigNumber.from(await nct.totalSupply()).toString());

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });