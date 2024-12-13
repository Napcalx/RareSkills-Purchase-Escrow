// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NftPurchase is ERC721 {
    IERC20 public usdc;
    address private admin;

    uint256 private constant MINT_PRICE = 1e6;
    uint256 private tokenCounter;
    event mintSuccessful(address indexed user, uint256 tokenId);

    modifier onlyOwner() {
        require(msg.sender == admin);
        _;
    }

    constructor(address tokenAddress) ERC721("Scytale", "SCY") {
        usdc = IERC20(tokenAddress);
        tokenCounter = 0;
    }

    function mint() external {
        require(
            usdc.allowance(msg.sender, address(this)) >= MINT_PRICE,
            "Insufficient Allowance"
        ); // Check that user enabled usdc to trade for the NFT

        bool success = usdc.transferFrom(msg.sender, address(this), MINT_PRICE); // tranfers Usdc from user to contract
        require(success, "Transfer Failed"); // ensures transfer is successful and returns an error if it fails

        uint256 tokenId = tokenCounter++; // updates the tokenCounter by the token Id
        _mint(msg.sender, tokenId); // Mints the NFT to the User.

        emit mintSuccessful(msg.sender, tokenId); // emits an event on successful purchase
    }

    function withdraw() external onlyOwner {
        uint256 balance = usdc.balanceOf(address(this));
        require(balance > 0, "Not enough funds to withdraw");
        usdc.transfer(msg.sender, balance);
    }

    function getTokenCounter() public view returns (uint256) {
        return tokenCounter;
    }
}

// 0x036CbD53842c5426634e7929541eC2318f3dCF7e - base Sepolia Usdc
// 	0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238  - sepolia usdc
