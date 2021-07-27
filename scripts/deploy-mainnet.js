/**
 * Deploy the contract on the main net
 *
 * @author s.imo
 *
 * Created at: 27.07.2021
 *
 */
const { ethers } = require("hardhat");

async function main() {

    const [deployer] = await ethers.getSigners();

    console.log("Deploying release contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    console.log("");

    // NCT real token
    const nctAddress = "0x8a9c4dfe8b9d8962b31e4e16f8321c44d48e246e";

    const UC1 = await ethers.getContractFactory("UC1");
    const uc1 = await UC1.deploy(nctAddress);

    const NFT = await ethers.getContractFactory("NFT");
    const nft = await NFT.deploy();

    const UC2  = await ethers.getContractFactory("UC2");
    const uc2  = await UC2.deploy(nft.address, nctAddress);


    console.log("============================");
    console.log("MAINNET DEPLOYMENT COMPLETED");
    console.log("============================");
    console.log("");
    console.log("Deployed addresses:");
    console.log("- UC1: ", uc1.address);
    console.log("- UC2: ", uc2.address);
    console.log("- NFT: ", nft.address);
    console.log("");
    console.log("");
    console.log("To launch etherscan verification please run:")
    console.log("npx hardhat verify --network NETWORK ", uc1.address, " ", nctAddress)
    console.log("npx hardhat verify --network NETWORK ", nft.address)
    console.log("npx hardhat verify --network NETWORK ", uc2.address, " ", nft.address, " ", nctAddress)

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });