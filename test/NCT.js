const { expect } = require('chai')
const { ethers } = require("hardhat");

/**
 * @title NCT test
 * @dev Simple basic tests for the contract emulating NCTs.
 * Tests performed are standard ones for a simple ERC20 token.
 *
 * Authors: s.imo
 * Created: 01.07.2021
 */
describe('NCT token contract', () => {
    let NCT, nct, owner, addr1, addr2;

    beforeEach(async () => {

    });

    describe('deployement', () => {
        it('setup', async () => {
            NCT = await ethers.getContractFactory("NCT");
            nct = await NCT.deploy(ethers.utils.parseUnits("10000.0", "18"));

            [owner, addr1, addr2] = await ethers.getSigners();
            // console.debug("NCT address: " + await nct.address);
        });

        it('should assign all the supply to the owner', async () => {
           expect(await nct.totalSupply()).to.equal(await nct.balanceOf(owner.address));
            // console.debug("owner: " + await nct.balanceOf(owner.address));
            // console.debug("addr1: " + await nct.balanceOf(addr1.address));

        });
    });

    describe('transactions', () => {
        it('transfer tokens between addresses', async () => {
            await nct.transfer(addr1.address, ethers.utils.parseUnits("50", "18"));
            expect(await nct.balanceOf(addr1.address)).to.equal(ethers.utils.parseUnits("50", "18"));
            await nct.connect(addr1).transfer(addr2.address, ethers.utils.parseUnits("50", "18"));

           // console.info("addr1: " + await nct.balanceOf(addr1.address));
           // console.info("addr2: " + await nct.balanceOf(addr2.address));

        });

        it('transfer fail testing', async () => {
            // console.info("addr1: " + await nct.balanceOf(addr1.address));
            // console.info("addr2: " + await nct.balanceOf(addr2.address));

            await expect(
                nct.connect(addr1).transfer(owner.address, 1)
            ).to.be.revertedWith("ERC20: transfer amount exceeds balance");
        });

        it('balances are correct', async () => {
           // console.info("addr1: " + await nct.balanceOf(addr1.address));
           // console.info("addr2: " + await nct.balanceOf(addr2.address));

            expect(await nct.balanceOf(addr1.address)).to.equal(0);
            expect(await nct.balanceOf(addr2.address)).to.equal(ethers.utils.parseUnits("50", "18"));
        });

        it('increase total supply', async () => {
            await nct.connect(owner).increaseTotalSupply(ethers.utils.parseUnits("10.0", "18"));
            expect(await nct.totalSupply()).to.equal(ethers.utils.parseUnits("10010.0", "18"));
        });
    });


});