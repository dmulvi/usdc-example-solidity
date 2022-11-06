// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ExampleUSDC is ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    event Mint(uint256 tokenId);
    event NewRoot(bytes32 oldRoot, bytes32 newRoot);
    event NewURI(string oldURI, string newURI);

    Counters.Counter internal nextId;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public price = 10000000; // 10 USDC
    uint256 public minted;
    bytes32 public merkleRoot;
    string public baseUri = "https://bafkreic6xug4ia6n2ogb5b5vfmjmrvjuhypii6cek4uwaf7wi4mgyupse4.ipfs.nftstorage.link";

    // Address of USDC contract
    IERC20 public USDC;

    constructor(IERC20 _USDC) payable ERC721("Example NFT with USDC", "USDCNFT") {
        USDC = _USDC;
    }
        
    // MODIFIERS

    modifier isCorrectPayment(uint256 _quantity) {
        require(USDC.balanceOf(msg.sender) >= price * _quantity, "Insufficient USDC Funds.");
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

    // ALLOWLIST PHASE

    function allowlistMint(address _to, uint256 _quantity, bytes32[] calldata _proof) 
        external  
        isValidMerkleProof(_to, _proof)
        isCorrectPayment(_quantity)
        isAvailable(_quantity)
    {
        USDC.transferFrom(msg.sender, address(this), price * _quantity );

        mintInternal(_to, _quantity);
    }

    // PUBLIC

    function mint(address _to, uint256 _quantity) 
        external  
        isCorrectPayment(_quantity)
        isAvailable(_quantity) 
    {
        USDC.transferFrom(msg.sender, address(this), price * _quantity );

        mintInternal(_to, _quantity);
    }

    // INTERNAL

    function mintInternal(address _to, uint256 _quantity) internal {
        for (uint256 i = 0; i < _quantity; i++) {
            uint256 tokenId = nextId.current();
            nextId.increment();

            _safeMint(_to, tokenId);

            emit Mint(tokenId);
        }
    }
        

    // ADMIN

    function setPrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }

    function setMerkleRoot(bytes32 _newRoot) external onlyOwner {
        emit NewRoot(merkleRoot, _newRoot);
        merkleRoot = _newRoot;
    }

    function setUri(string calldata _newUri) external onlyOwner {
        emit NewURI(baseUri, _newUri);
        baseUri = _newUri;
    }

    function setUsdcAddress(IERC20 _USDC) public onlyOwner {
        USDC = _USDC;
    }
    
    function withdraw(uint256 _amount) public onlyOwner {
        require(USDC.balanceOf(address(this)) >= _amount, "Cannot withdraw more than current balance.");
        USDC.transfer(msg.sender, _amount);
    }

    // VIEW

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        // same uri for all NFTs, logic looks wrong but is intended to use the _tokenId
        // argument to avoid compiler warnings about it not being used
        return
            bytes(baseUri).length > 0
                ? baseUri // this will always be the intended return
                : string(abi.encodePacked(baseUri, _tokenId.toString(), ".json")); 
    }
}