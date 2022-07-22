// contracts/NFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title NFT
 * @dev This is a very basic NFT that do not provide any name changing functionality.
 *
 * Authors: 0xSimo
 * Created: 01.07.2021
 * Last revision: 22.07.2022: gas optimizations
 */
contract NFT is ERC721, Ownable {
    using SafeMath for uint256;

    // The maximum number of tokens, this is just an example
    uint256 public constant MAX_NFT_SUPPLY = 233;
    // The NFT minting price, this is just an example
    uint256 public constant NFT_MINT_PRICE = 0.1 ether;
    // the (current) total supply
    uint256 public totalSupply;


    /**
     * @dev Constructor
     */
    constructor() ERC721("Your NFT without names", "XYZ") {}

    /**
     * @dev Mint 'numberOfNfts' new tokens
     */
    function mintNFT(uint256 numberOfNfts) public payable {
        require(totalSupply <  MAX_NFT_SUPPLY, "Sale has already ended");
        require(numberOfNfts  >  0, "numberOfNfts cannot be 0");
        require(numberOfNfts  <= 20, "You may not buy more than 20 NFTs at once");
        require(totalSupply.add(numberOfNfts)  <= MAX_NFT_SUPPLY, "Sale has already ended");
        require(NFT_MINT_PRICE.mul(numberOfNfts) == msg.value, "Ether value sent is not correct");

        for (uint i = 0; i < numberOfNfts; i++) {
            if (totalSupply < MAX_NFT_SUPPLY) {
                _mint(_msgSender(), totalSupply);
                totalSupply += 1; // can be unchecked no overflow here
            }
        }
    }

    /**
    * @dev Withdraw ETH from this contract (Callable by owner)
    */
    function withdraw() onlyOwner() public returns (bool) {
        uint balance = address(this).balance;
        (bool success, ) = _msgSender().call{value:balance}("");
        // no need to call throw here or handle double entry attack
        // since only the owner is withdrawing all the balance
        return success;
    }


}
