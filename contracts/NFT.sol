// contracts/NFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFT
 * @dev This is a very basic NFT that do not provide any name changing functionality.
 *
 * Authors: s.imo
 * Created: 01.07.2021
 */
contract NFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    // The maximum number of tokens, this is just an example
    uint256 public constant MAX_NFT_SUPPLY = 16384;
    // The NFT minting price, this is just an example
    uint256 public constant NFT_MINT_PRICE = 100000000000000000; // 0.1 ETH

    // counter of minted tokens
    Counters.Counter private _tokenIds;

    /**
     * @dev Constructor
     */
    constructor() ERC721("Your NFT without names", "XYZ") {}

    /**
     * @dev Retrieve the total supply
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    /**
     * @dev Mint 'numberOfNfts' new tokens
     */
    function mintNFT(uint256 numberOfNfts) public payable {
        require(totalSupply() <  MAX_NFT_SUPPLY, "Sale has already ended");
        require(numberOfNfts  >  0, "numberOfNfts cannot be 0");
        require(numberOfNfts  <= 20, "You may not buy more than 20 NFTs at once");
        require(totalSupply().add(numberOfNfts)  <= MAX_NFT_SUPPLY, "Sale has already ended");
        require(NFT_MINT_PRICE.mul(numberOfNfts) == msg.value, "Ether value sent is not correct");

        for (uint i = 0; i < numberOfNfts; i++) {
            _tokenIds.increment(); // the first token will have id set to 1

            uint256 newTokenId = _tokenIds.current();
            _mint(msg.sender, newTokenId);
        }
    }

}
