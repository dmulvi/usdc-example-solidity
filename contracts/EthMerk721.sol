// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import 'solmate/src/tokens/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';

contract EthMerk721 is ERC721, Ownable {

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public cost = 0.005 ether;
    uint256 public minted;
    bytes32 public merkleRoot;
    string public uri = "https://nftstorage.link/ipfs/bafkreifyb5jetemu2qf2pbid7246kvsumzsqim5z3jabr5zrb3fukh35ki";

    constructor() payable ERC721("Ethereum Merkle Example NFT", "ETHMRK") {}
        
    // MODIFIERS

    modifier isCorrectPayment(uint256 _quantity) {
        require(cost * _quantity == msg.value, "Incorrect ETH value sent");
        _;
    }

    modifier isAvailable(uint256 _quantity) {
        require(minted + _quantity <= MAX_SUPPLY, "Not enough tokens left for quantity");
        _;
    }

    modifier isValidMerkleProof(address _to, bytes32[] calldata _proof) {
        if (!MerkleProof.verify(_proof, merkleRoot, keccak256(abi.encodePacked(_to)))) {
            revert("Invalid access list proof");
        }
        _;
    }

    // WHITELIST PHASE

    function whitelistMint(address _to, uint256 _quantity, bytes32[] calldata _proof) 
        external 
        payable 
        isValidMerkleProof(_to, _proof)
        isCorrectPayment(_quantity)
        isAvailable(_quantity)
    {
        for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(_to, minted++);
        }
    }

    // PUBLIC

    function mint(address _to, uint256 _quantity) 
        external 
        payable 
        isCorrectPayment(_quantity)
        isAvailable(_quantity) 
    {
        for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(_to, minted++);
        }
    }

    // ADMIN

    function setCost(uint256 _cost) external onlyOwner {
        cost = _cost;
    }

    function setMerkleRoot(bytes32 _root) external onlyOwner {
        merkleRoot = _root;
    }

    function setUri(string _uri) external onlyOwner {
        uri = _uri;
    }

    // VIEW

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        // just the same uri for all NFTs
        return uri;
    }
}