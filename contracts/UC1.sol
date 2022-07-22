// contracts/UC1.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./INCT.sol";

/**
 * @title UC1
 * @dev This is the simplest and most elegant use case: an NFT that contains name management within its main contract.
 * Similar to The Hashmasks, NCTs are burned when a name is changed.
 *
 * Authors: 0xSimo
 * Created: 01.07.2021
 * Last revision: 26.07.2021: set name change price already ready for a real example
 *                22.07.2022: gas optimizations
 */
contract UC1 is ERC721, Ownable {
    using Strings for uint256;
    using SafeMath for uint256;

    // The maximum number of tokens, this is just an example
    uint256 public constant MAX_NFT_SUPPLY    = 233;
    // The name change price, you can set your own
    uint256 public constant NAME_CHANGE_PRICE = 10 * (10 ** 18);
    // The NFT minting price, this is just an example
    uint256 public constant NFT_MINT_PRICE    = 0.1 ether;
    // the (current) total supply
    uint256 public totalSupply;

    // Mapping from token ID to name
    mapping (uint256 => string) private _tokenName;

    // Mapping if certain name string has already been reserved
    mapping (string => bool) private _nameReserved;

    // base URI for the images
    string private _imagesRootURI;

    // The NCT contract pointer
    INCT private _nct;


    // NameChange event
    event NameChange (uint256 indexed tokenIdx, string newName);


    /**
     * @dev Constructor that stores the NCT pointer
     * The parameters are:
     * nctAddress - address of the NCT contract
     */
    constructor(address nctAddress) ERC721("Your NFT with names", "XYZ") {
        //NOTE: here you can check if the required functions are implemented by IERC165
        _nct = INCT(nctAddress);
    }

    /**
     * @dev Returns name of the NFT at index.
     */
    function tokenNameByIndex(uint256 index) public view returns (string memory) {
        return _tokenName[index];
    }

    /**
     * @dev Returns if the name has been reserved.
     */
    function isNameReserved(string memory nameString) public view returns (bool) {
        return _nameReserved[toLower(nameString)];
    }

    /**
     * @dev Changes the name for Hashmask tokenId
     */
    function changeName(uint256 tokenId, string memory newName) public {
        address owner = ownerOf(tokenId);

        require(_msgSender() == owner, "ERC721: caller is not the owner");
        require(validateName(newName) == true, "Not a valid new name");
        require(sha256(bytes(newName)) != sha256(bytes(_tokenName[tokenId])), "New name is same as the current one");
        require(isNameReserved(newName) == false, "Name already reserved");

        _nct.transferFrom(msg.sender, address(this), NAME_CHANGE_PRICE);

        // If already named, dereserve old name
        if (bytes(_tokenName[tokenId]).length > 0) {
            toggleReserveName(_tokenName[tokenId], false);
        }
        toggleReserveName(newName, true);
        _tokenName[tokenId] = newName;
        _nct.burn(NAME_CHANGE_PRICE);
        emit NameChange(tokenId, newName);
    }


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

    function setImagesBaseURI(string memory uri) external onlyOwner() {
        _imagesRootURI = uri;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _imagesRootURI;
    }


    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        require(_exists(tokenId),                 "TokenId not valid");
        require(bytes(_imagesRootURI).length > 0, "Image base URI not yet set");

        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "', tokenNameByIndex(tokenId),'",',
                '"description": "your project description",',
                '"image": "', string(abi.encodePacked(_baseURI(), tokenId.toString())),
             '"}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }


    /**
     * @dev Reserves the name if isReserve is set to true, de-reserves if set to false
     */
    function toggleReserveName(string memory str, bool isReserve) internal {
        _nameReserved[toLower(str)] = isReserve;
    }

    /**
     * @dev Check if the name string is valid (Alphanumeric and spaces without leading or trailing space)
     */
    function validateName(string memory str) public pure returns (bool){
        bytes memory b = bytes(str);
        if(b.length < 1) return false;
        if(b.length > 25) return false; // Cannot be longer than 25 characters
        if(b[0] == 0x20) return false; // Leading space
        if (b[b.length - 1] == 0x20) return false; // Trailing space

        bytes1 lastChar = b[0];

        for(uint i; i<b.length; i++){
            bytes1 char = b[i];

            if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces

            if(!(char >= 0x30 && char <= 0x39) && //9-0
               !(char >= 0x41 && char <= 0x5A) && //A-Z
               !(char >= 0x61 && char <= 0x7A) && //a-z
               !(char == 0x20) //space
            ) return false;


            lastChar = char;
        }

        return true;
    }

    /**
     * @dev Converts the string to lowercase
     */
    function toLower(string memory str) public pure returns (string memory){
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            // Uppercase character
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
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
