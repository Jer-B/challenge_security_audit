// SPDX-License-Identifier: MIT
//0x822364cD1F4afB8EaE323126Da8718e3aAfAD347
//deploy with 0xf988Ebf9D801F4D3595592490D7fF029E438deCa
pragma solidity 0.8.24;

contract GuessRNG{
    address contractAddress = 0xf988Ebf9D801F4D3595592490D7fF029E438deCa;
    uint256 public rng = uint256(keccak256(abi.encodePacked(msg.sender, block.prevrandao, block.timestamp))) % 1_000_000;

constructor (address ContractToCall){
    contractAddress = ContractToCall;
}

    // Call solveChallenge()
    function callSolveChallenge(
        uint256 weakRNGNumber, string memory TwitterHandler
    ) public returns (bytes4, bool) {
        (
            bool success,
            bytes memory returnData
        ) = contractAddress.call(
                abi.encodeWithSignature("solveChallenge(uint256,string)", weakRNGNumber,TwitterHandler)
            );
        return (bytes4(returnData), success);
    }
}