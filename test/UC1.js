const { expect } = require('chai')
const { ethers } = require("hardhat");

/**
 * @title UC1 test
 * @dev NFT with embedded NCT functionality test.
 *
 * Authors: s.imo
 * Created: 01.07.2021
 */
describe('UC1: NFT with embedded NCT functionality', () => {
    let NCT, nct, NFT, nft, owner, addr1, addr2;

    beforeEach(async () => {

    });

    describe('Deployement', () => {
        it('Setup', async () => {
            NCT = await ethers.getContractFactory("NCT");
            nct = await NCT.deploy("100000");

            NFT = await ethers.getContractFactory("UC1");
            nft = await NFT.deploy(nct.address);

            [owner, addr1, addr2] = await ethers.getSigners();
            // console.debug("NCT address: " + await nct.address);
        });

        it('Should assign all the NCT supply to the owner', async () => {
            expect(await nct.totalSupply()).to.equal(await nct.balanceOf(owner.address));
            // console.debug("owner: " + await nct.balanceOf(owner.address));
            // console.debug("addr1: " + await nct.balanceOf(addr1.address));

        });

        it('Transfer some NCT to others wallet', async () => {
            numTokens = Math.floor((await nct.totalSupply()) / 3);

            await nct.connect(owner).transfer(addr1.address, numTokens);
            await nct.connect(owner).transfer(addr2.address, numTokens);

            // console.debug("owner: " + await nct.balanceOf(owner.address));
            // console.debug("addr1: " + await nct.balanceOf(addr1.address));
            // console.debug("addr2: " + await nct.balanceOf(addr2.address));

            expect(await nct.balanceOf(addr1.address)).to.equal(numTokens);
            expect(await nct.balanceOf(addr2.address)).to.equal(numTokens);
        });
    });


    describe('Minting', () => {
        it('mint 1 token for each address', async () => {
            await nft.connect(owner).mintNFT(1, { value: ethers.utils.parseEther("0.1") });
            await nft.connect(addr1).mintNFT(1, { value: ethers.utils.parseEther("0.1") });
            await nft.connect(addr2).mintNFT(1, { value: ethers.utils.parseEther("0.1") });

            await expect(
                nft.ownerOf(0)
            ).to.be.revertedWith("ERC721: owner query for nonexistent token");

            expect(await nft.ownerOf(1)).to.equal(owner.address);
            expect(await nft.ownerOf(2)).to.equal(addr1.address);
            expect(await nft.ownerOf(3)).to.equal(addr2.address);

        });

        it('mint 10 token for addr1', async () => {
            await nft.connect(addr1).mintNFT(10, { value: ethers.utils.parseEther("1") });

            for (i = 0; i < 10; i++) {
                expect(await nft.ownerOf(3 + i + 1)).to.equal(addr1.address);
            }
        });
    });

    describe('Changing name', () => {
        it('owner change name of a NFT token', async () => {
            console.log("NCT address: " + nct.address)
            console.log("OWN address: " + owner.address)
            console.log("NCT balance: " + await nct.connect(owner).balanceOf(owner.address))
            //await nct.connect(owner).burn(10);

            //FIXME still have 'ERC20: transfer amount exceeds allowance' error afetr calling changeName()
            // that contains the transferFrom
            await nct.connect(owner).approve(nct.address, 10);
            //await nct.connect(owner).increaseAllowance(nct.address, 1000);

            await nft.connect(owner).changeName("1", "hello world");

        });

        it('only the owner can change name of a NFT token', async () => {

            await expect(
                nft.connect(addr1).changeName("1", "hello world")
            ).to.be.revertedWith("ERC721: caller is not the owner");

        });


    });

});