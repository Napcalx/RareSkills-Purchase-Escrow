// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {NftPurchase} from "../src/purchase.sol";
import {console} from "forge-std/Test.sol";

contract DeployMyContract {
    function run() public {
        // Deploy MyContract
        NftPurchase nftPurchase = new NftPurchase(
            0x036CbD53842c5426634e7929541eC2318f3dCF7e
        );
        console.log("NFT Purchase deployed at:", address(nftPurchase));
    }
}

// forge script script/purchase.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $BASESCAN_API_KEY -vvvvv

// forge script script/purchase.s.sol --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $BASESCAN_API_KEY -vvvvv

// forge create src/purchase.sol:NftPurchase --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $BASESCAN_API_KEY --constructor-args 0x036CbD53842c5426634e7929541eC2318f3dCF7e

// forge create src/approve.sol:ApproveUSDC --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $BASESCAN_API_KEY --constructor-args 0x036CbD53842c5426634e7929541eC2318f3dCF7e
