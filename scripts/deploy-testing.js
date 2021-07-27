/**
 * Deploy the contract on a test network (e.g., Rinkeby)
 *
 * @author s.imo
 *
 * Created at: 27.07.2021
 *
 */
const { ethers } = require("hardhat");

async function main() {

    const [deployer] = await ethers.getSigners();

    console.log("Deploying test contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    console.log("");

    // NCT initial supply
    const initSupply = ethers.utils.parseUnits("10000.0", "18");
    const NCT = await ethers.getContractFactory("NCT");
    const nct = await NCT.deploy(initSupply);

    const UC1 = await ethers.getContractFactory("UC1");
    const uc1 = await UC1.deploy(nct.address);

    const NFT = await ethers.getContractFactory("NFT");
    const nft = await NFT.deploy();

    const UC2  = await ethers.getContractFactory("UC2");
    const uc2  = await UC2.deploy(nft.address, nct.address);


    console.log("=========================");
    console.log("TEST DEPLOYMENT COMPLETED");
    console.log("=========================");
    console.log("");
    console.log("Deployed addresses:");
    console.log("- UC1: ", uc1.address);
    console.log("- UC2: ", uc2.address);
    console.log("- NCT: ", nct.address);
    console.log("- NFT: ", nft.address);
    console.log("");
    console.log("");
    console.log("To launch etherscan verification please run:")
    console.log("npx hardhat verify --network NETWORK ", nct.address, " ", initSupply.toString())
    console.log("npx hardhat verify --network NETWORK ", uc1.address, " ", nct.address)
    console.log("npx hardhat verify --network NETWORK ", nft.address)
    console.log("npx hardhat verify --network NETWORK ", uc2.address, " ", nft.address, " ", nct.address)

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });