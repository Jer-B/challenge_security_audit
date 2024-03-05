// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {S5Pool} from "../../src/S5Pool.sol";
import {S5Token} from "../mocks/S5Token.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TestInvariant is StdInvariant, Test {
    using SafeERC20 for IERC20;
    // supply 1e18 * 1000
    // 1000000000000000000000 = 1000 ethers

    S5Pool pool;
    S5Token tokenA; // S5TokenA
    S5Token tokenB; // S5TokenB
    S5Token tokenC; // S5TokenC

    address liquidityProvider = makeAddr("liquidityProvider");
    address user = makeAddr("user");

    function setUp() public {
        tokenA = new S5Token("A");
        tokenB = new S5Token("B");
        tokenC = new S5Token("C");

        pool = new S5Pool(tokenA, tokenB, tokenC);

        tokenA.approve(address(pool), type(uint256).max);
        tokenB.approve(address(pool), type(uint256).max);
        tokenC.approve(address(pool), type(uint256).max);
        pool.deposit(tokenA.INITIAL_SUPPLY(), uint64(block.timestamp));
    }

    function test_fuzz_invariant(uint256 randomAmount) public {
        vm.assume(randomAmount > 1000 && randomAmount < 100000000000000000);

        uint256 initialSupplyTokenA = tokenA.INITIAL_SUPPLY();
        uint256 initialSupplyTokenB = tokenB.INITIAL_SUPPLY();
        uint256 initialSupplyTokenAB = initialSupplyTokenA + initialSupplyTokenB;

        // vm.deal(liquidityProvider, randomAmount);
        vm.startPrank(liquidityProvider);

        tokenA.mint(liquidityProvider);
        tokenB.mint(liquidityProvider);
        tokenC.mint(liquidityProvider);
        tokenA.approve(address(pool), type(uint256).max);
        tokenB.approve(address(pool), type(uint256).max);
        tokenC.approve(address(pool), type(uint256).max);

        uint256 balanceTokenABeforeDeposit = tokenA.balanceOf(address(liquidityProvider));
        console.log("balanceTokenABeforeDeposit", balanceTokenABeforeDeposit);

        pool.deposit(randomAmount, uint64(block.timestamp));

        // Swap C to A
        pool.swapFrom(tokenC, tokenA, randomAmount);

        // CHECK FEE //
        uint256 checkFee = pool.calculateFee(randomAmount);
        console.log("checkFee", checkFee);
        // CHECK FEE //

        // need to swap before collecting fee else no fee calculated
        pool.collectOwnerFees(tokenA);

        // REDEEM //
        console.log("Balance token A before redeem", tokenA.balanceOf(address(liquidityProvider)));
        pool.redeem(uint64(block.timestamp));

        uint256 balanceAfterRedeem = tokenA.balanceOf(address(liquidityProvider));
        console.log("balanceAfterRedeem", balanceAfterRedeem);
        console.log("Pool balance Token A", tokenA.balanceOf(address(pool)));
        // REDEEM //

        uint256 contractBalanceA = tokenA.balanceOf(address(pool));
        console.log("contractBalanceA", contractBalanceA);
        uint256 contractBalanceB = tokenB.balanceOf(address(pool));
        console.log("contractBalanceB", contractBalanceB);

        assertLt(contractBalanceA + contractBalanceB, initialSupplyTokenAB);
    }
}
