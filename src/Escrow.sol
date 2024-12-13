// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NftEscrow {
    address public alice;
    address public bob;
    IERC20 public usdc;
    ERC721 public nftContract;
    uint256 public nftId;
    uint256 public constant PAYMENT_AMOUNT = 2e6;

    bool public alicePaid = false;
    bool public bobApprovedNFT = false;

    event PaymentReceived(address indexed sender, uint256 amount);
    event NftApproved(address indexed spender, uint256 nftId);
    event NftTransferred(
        address indexed sender,
        address indexed reciever,
        uint256 nftId
    );
    event PaymentTransferred(
        address indexed sender,
        address indexed receiver,
        uint256 amount
    );

    modifier onlyAlice() {
        require(
            msg.sender == alice,
            "Only Alice can initiate this transaction"
        );
        _;
    }

    modifier onlyBob() {
        require(msg.sender == bob, "Only Bob can call this function");
        _;
    }

    modifier onlyWhenBothPartiesHaveAgreed() {
        require(
            alicePaid && bobApprovedNFT == true,
            "Only be called when Alice has paid and Bob has approved his nft to be transferred"
        );
        _;
    }

    constructor(
        address usdcAddy,
        address nftContractAddy,
        uint256 _nftId,
        address _bob
    ) {
        alice = msg.sender;
        bob = _bob;
        usdc = IERC20(usdcAddy);
        nftContract = ERC721(nftContractAddy);
        nftId = _nftId;
    }

    function pay() external onlyAlice {
        require(!alicePaid, "Alice has already paid");
        require(
            usdc.transferFrom(msg.sender, address(this), PAYMENT_AMOUNT),
            "Payment Failed"
        );

        alicePaid = true;
        emit PaymentReceived(msg.sender, PAYMENT_AMOUNT);
    }

    function TransferNFT() external onlyBob {
        require(!bobApprovedNFT, "Bob has already approved");
        require(nftContract.ownerOf(nftId) == bob, "Bob must own the NFT");

        bobApprovedNFT = true;
        emit NftApproved(address(this), nftId);
    }

    function finalizeTransaction() external onlyWhenBothPartiesHaveAgreed {
        nftContract.safeTransferFrom(bob, alice, nftId); //  transfer the NFT from Bob to alice.
        emit NftTransferred(bob, alice, nftId);

        require(usdc.transfer(bob, PAYMENT_AMOUNT), "Payment Failed");
        emit PaymentTransferred(alice, bob, PAYMENT_AMOUNT);

        resetTransaction();
    }

    function resetTransaction() private {
        alicePaid = false;
        bobApprovedNFT = false;
    }
}

// forge verify-contract --rpc-url $BASE_SEPOLIA_URL --etherscan-api-key $BASESCAN_API_KEY 0x56a1a0decD217Ad58bC9892FC20bf7B602CF9488 src/Escrow.sol:NftEscrow

// forge verify-contract --rpc-url $BASE_SEPOLIA_URL --etherscan-api-key $BASESCAN_API_KEY --constructor-args "0x036CbD53842c5426634e7929541eC2318f3dCF7e" "0x0D00fA4F4d40cC270E4403bc04D7F3d57E2bc5DA" "1" "0x3D7a4E450B324E656E0F79fC4aFb5FEd72Bb5f68" 0x56a1a0decD217Ad58bC9892FC20bf7B602CF9488 src/Escrow.sol:NftEscrow
