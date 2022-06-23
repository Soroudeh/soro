//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;
    address owner;
    bool contractActive;

    modifier ownerOnly() {
		require(msg.sender == owner,"Owner only");
		_;
	}

    modifier activeOnly() {
        require(contractActive, "minting is stopped by creator");
        _;
    }

    constructor(address marketplaceAddr) ERC721("Soroudeh Token", "SORO") {
        owner = msg.sender;
        contractAddress = marketplaceAddr;
        contractActive = true;
    }

    function changeMarketPlaceAdress(address marketplaceAddr) external ownerOnly{
        contractAddress = marketplaceAddr;
    }

    function toggleContractActivation() external ownerOnly {
        contractActive = !contractActive;
    }

    function createToken(string memory tokenURI) public returns(uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        setApprovalForAll(contractAddress, true);
        
        return newItemId;
    }
}