// contracts/NCT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NCT
 * @dev A minimal NCT implementation (for test only!) where all tokens are pre-assigned to the creator.
 * The purpose of this contract is to very simply simulate real NCTs for testing purposes only.
 * The basic functions available in NCT are the same.
 *
 * Authors: s.imo
 * Created: 01.07.2021
 * Last revision: 26.07.2021: add the debugging-only increaseTotalSupply() function
 */
contract NCT is ERC20Burnable, Ownable {

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     * The parameters are:
     * initialSupply - initial supply of tokens
     */
    constructor (
        uint256 initialSupply
    ) ERC20("Name Change Token", "NCT") {
        _mint(msg.sender, initialSupply);
    }

    /**
    * @dev This function increases the total supply of the token.
    *      It exists ONLY in this example and not in the real NCT token.
    *      It is useful for DEBUGGING in case all the NCT have been burned.
    * The parameters are:
    * amount - the number of tokens to increase to the total supply
    */
    function increaseTotalSupply(uint256 amount) public onlyOwner() {
        _mint(_msgSender(), amount);
    }

}