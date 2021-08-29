// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OwnableDelegateProxy {}

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}

/**
 * @title Rupert
 * Rupert - a contract for Rupert's non-fungible tokens.
 */
contract Rupert is ERC721Enumerable, ERC721URIStorage, Ownable {
    uint256 public constant MAX_TOKEN_COUNT = 10;

    address proxyRegistryAddress;
    uint256 private _currentTokenId = 0;

    constructor(address _proxyRegistryAddress, string[] memory _ipfsHashes)
        ERC721("Rupert", "ROUX")
    {
        proxyRegistryAddress = _proxyRegistryAddress;

        for (uint256 i; i < _ipfsHashes.length; i++) {
            mintTo(msg.sender, _ipfsHashes[i]);
        }
    }

    /**
     * @dev Mints a token to an address with a tokenURI.
     * @param _to address of the future owner of the token
     * @param _ipfsHash address of the future owner of the token
     */
    function mintTo(address _to, string memory _ipfsHash) public onlyOwner {
        uint256 newTokenId = _getNextTokenId();
        require(
            newTokenId <= MAX_TOKEN_COUNT,
            "All of Rupert's NFTs have already been minted"
        );
        _safeMint(_to, newTokenId);
        _setTokenURI(newTokenId, _ipfsHash);
        _incrementTokenId();
    }

    /**
     * @dev calculates the next token ID based on value of _currentTokenId
     * @return uint256 for the next token ID
     */
    function _getNextTokenId() private view returns (uint256) {
        return _currentTokenId + 1;
    }

    /**
     * @dev increments the value of _currentTokenId
     */
    function _incrementTokenId() private {
        _currentTokenId++;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://";
    }

    /**
     * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
     */
    function isApprovedForAll(address owner, address operator)
        public
        view
        override
        returns (bool)
    {
        // Whitelist OpenSea proxy contract for easy trading.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }

        return super.isApprovedForAll(owner, operator);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
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
        return super.supportsInterface(interfaceId);
    }
}
