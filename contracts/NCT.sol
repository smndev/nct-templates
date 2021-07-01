// contracts/NCT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
//import "./INCT.sol";

/**
 * @title NCT
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * The purpose of this contract is to very simply simulate real NCTs for testing purposes only.
 * The basic functions available in NCT are the same.
 *
 * Authors: s.imo
 * Created: 01.07.2021
 */
contract NCT is ERC20Burnable {

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

}