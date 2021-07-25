# NCT usage examples

## <a name="s1"></a> 1. Introduction 

<img align="right" width="200" height="200" src="./doc/12398.png">

This repository provides a concise and quick guide on how to integrate Name Changing Token (NCT) to a new or existing 
NFT project. The document is structured as follows:
- [Section 2](#s2) provides an introduction on NCTs illustrating what they are and their possible use-cases;
- [Section 3](#s3) explains how to integrate NCTs into an unpublished Ethereum smart contract in an embedded way;
- [Section 4](#s4) describes some possible solutions on how to integrate NCTs into a published Ethereum smart contract 
  project and is therefore no longer editable.

The repository is structured as follows:
- [contracts](./contracts): contracts implementation source code
- [test](./test): hardhat regression test
- [scripts](./scripts): hardhat deployment scripts


## <a name="s2"></a> 2. What is NCT
The Name Change Token (NCT) is the native token of Hashmasks. The NCT has only one purpose: it allows its holder to 
give its Hashmask a unique name that is permanently stored and publicly visible on the Ethereum Blockchain. 
NCTs is the first ERC20 tokens to appear in the world of NFTs (birthday January 2021) and is used through a burn 
system to change the name of a Hashmask.
As stated on The Hashmasks website, *"this opens up a whole new dimension for collecting where the hierarchy of the 
value of individual pieces of the entire collective art is highly influenced by consumer preferences."*

The address of the NCT contract is:  [0x8a9c4dfe8b9d8962b31e4e16f8321c44d48e246e](https://etherscan.io/token/0x8a9c4dfe8b9d8962b31e4e16f8321c44d48e246e) 

Each year, approximately 3,660 NCTs will be accumulated by each Hashmask. One needs 1,830 NCTs to change a Hashmasks’ name. 
In order to give early participants more decision power, each participant in the distribution period (14 days) received 
an additional 1,830 NCTs. After 10 years, the emission of new NCTs comes to a halt. From then on, NCTs can only be burnt 
until one day no NCTs are left and the names of the Hashmasks cannot be altered anymore. 
The artwork is then considered complete.

In summary:
- Number of NCTs emitted per year per NFT token: 3,660
- Number of NCTs required for one name change: 1,830
- Bonus NCTs for initial sales phase: 1,830

The rules for assigning a name to an NFT token are also followed in the implementation examples:
- No name can be identical
- There is a limit of 25 symbols (including spaces)
- Uniqueness is case insensitive (i.e. «John» and «john» are considered the same for the blockchain)
- There are no leading or trailing «spaces»
- Only alphanumeric symbols are eligible for use
- Used names become available immediately after the name of the NFT token was changed

## <a name="s3"></a> 3. Integrating a new NFT Project
This section discusses how to include NCT in a not-yet-deployed NFT contract thereby granting the ability to assign 
each NFTa name and charge for this functionality in NCT. A similar guide to this use case can be found 
[here](https://hackmd.io/@cgEsbYIST_6la5EYjGAJEg/rJB-ZKA_d).
This case can be solved with a single contract as shown in the image below. The contract in our example is called 
UC1 and it is the one implemented in [UC1.sol](./contracts/UC1.sol).

![UC1](./doc/UC1.png)

``UC1`` contains the map of names associated with each token. The ``changeName()`` function is used to change the name 
of an NFT token and imposes the following conditions:
- No two NFT tokens can have the same name.
- Only the owner of the NFT token can change the name.

To change the name in this example  the ``NAME_CHANGE_PRICE NCT`` must be burned. This policy can be changed to suit 
the needs of the project.

It is important to note that for the operation to be successful, the owner of the token must:
- have enough NCTs in his wallet.
- call the ``approve()`` function on the NCT contract before calling ``changeName()`` function (e.g., see [UC1.js, line 102](./test/UC1.js#L102)).

## <a name="s4"></a> 4. Integrating into an existing NFT project
This section describes how to develop a parallel contract for an  Ethereum Mainnet deployed NFT contract that can be 
used to add naming functionality to NFTs. This example consists of 3 contracts: 
1. Original NFT already deployed, 
2. NCT already deployed, and
3. UC2 which is the contract used to manage the NFTs’ names in the contract. 

The contract in our UC2 example is the one implemented in [UC2.sol](./contracts/UC2.sol).

![UC2](./doc/UC2.png)

``UC2`` contains the map of names associated with each NFT token and uses the ``changeName()`` function to change the 
NFT token names’ name to a token while imposing the following conditions:
- No two tokens can have the same name
- Only the owner of the token can change the name: guaranteed by making the “ownerOf” query to the NFT contract

In this example, the ``NAME_CHANGE_PRICE NCT`` sets the NCT quantity  that must be burned to change the name. 
This price can be changed to suit the project’s needs.


It is important to note that for the operation to be successful, the owner of the token must:
- have enough NCTs in his wallet.
- call the ``approve()`` function on the NCT contract before calling ``changeName()`` function (e.g., see [UC1.js, line 102](./test/UC1.js#L102)).



