// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/// @custom:security-contact vitto@alchemy.com
contract UkraineFrens is ERC721,ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint private MAX_SUPPLY = 10000;
    string private globalContractURI;
    uint96 private royaltyFeesInBips;
    address private tresuryAddress;


    struct Owner {
        uint256 tokensQuantity;
    }

    mapping(address => Owner) addressToTokens;

    constructor(uint96 _royaltyFeesInBips, string memory _contractURI) ERC721("UkraineFrens", "UKF") {
        globalContractURI = _contractURI;
        royaltyFeesInBips = _royaltyFeesInBips;
        tresuryAddress = owner();
    }

    function safeMint(address to, string memory uri) public payable {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "All tokens have been minted");
        require(addressToTokens[msg.sender].tokensQuantity < 3, "You reached the maximum amount of nfts");
        if(_tokenIdCounter.current() < MAX_SUPPLY / 100 * 30){
            require(msg.value >= 0.005 * 10**18, "Mint costs 0.5ETH");
        }else if(_tokenIdCounter.current()  < MAX_SUPPLY / 100 * 50){
            require(msg.value >= 0.7 * 10**18, "Mint costs 0.7ETH");
        }else if(_tokenIdCounter.current()  < MAX_SUPPLY / 100 * 70){   
            require(msg.value >= 1 * 10**18, "Mint costs 1ETH");
        }

        addressToTokens[msg.sender].tokensQuantity = addressToTokens[msg.sender].tokensQuantity + 1;

        payable(owner()).transfer(msg.value);

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        
    }


    function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner{
        tresuryAddress = _receiver;
        royaltyFeesInBips = _royaltyFeesInBips;
    }

    function setContractURI(string calldata _contractURI) public onlyOwner {
        globalContractURI = _contractURI;
    }

     function contractURI() public view returns (string memory) {
        return globalContractURI;
    }

    function royaltyInfo(uint256 _salePrice)
        external
        view
        virtual
        returns (address, uint256)
    {
        return (tresuryAddress, calculateRoyalty(_salePrice));
    }

    function calculateRoyalty(uint256 _salePrice) view public returns (uint256) {
        return (_salePrice / 10000) * royaltyFeesInBips;
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }


    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }


    function supportsInterface(bytes4 interfaceId)
            public
            view
            override(ERC721, ERC721Enumerable)
            returns (bool)
    {
        return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
    }
}