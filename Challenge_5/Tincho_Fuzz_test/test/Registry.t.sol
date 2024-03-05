// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Registry} from "../src/Registry.sol";

contract RegistryTest is Test {
    Registry registry;
    address alice;

    function setUp() public {
        alice = makeAddr("alice");

        registry = new Registry();
    }

    function test_register() public {
        uint256 amountToPay = registry.PRICE();

        vm.deal(alice, amountToPay);
        vm.startPrank(alice);

        uint256 aliceBalanceBefore = address(alice).balance;

        registry.register{value: amountToPay}();

        uint256 aliceBalanceAfter = address(alice).balance;

        assertTrue(registry.isRegistered(alice), "Did not register user");
        assertEq(address(registry).balance, registry.PRICE(), "Unexpected registry balance");
        assertEq(aliceBalanceAfter, aliceBalanceBefore - registry.PRICE(), "Unexpected user balance");
    }

    function test_Fuzz_CheckChangeIfTooMuch(uint256 randomPrice) public {
        // minimum of 2 ether
        vm.assume(randomPrice >= 2 ether);

        vm.deal(alice, randomPrice);
        vm.startPrank(alice);

        // uint256 aliceBalanceBefore = address(alice).balance;

        registry.register{value: randomPrice}();

        uint256 aliceBalanceAfter = address(alice).balance;

        // calculate if the user get back the change when paying too much
        uint256 change = randomPrice - registry.PRICE();
        uint256 balanceWithChange = aliceBalanceAfter + change;

        assertTrue(registry.isRegistered(alice), "Did not register user");
        assertEq(address(registry).balance, randomPrice, "Unexpected registry balance");

        // Can use 2 assert to check the result.
        // first assert, User ending balance is less than the expected balance including the change
        assertLt(
            aliceBalanceAfter,
            balanceWithChange,
            "User ending balance is more than expected balance including the change"
        );
        // second assert user ending balance is equal to the expected balance including the change
        assertEq(aliceBalanceAfter, balanceWithChange, "Change not reflected in user balance");
    }
}
