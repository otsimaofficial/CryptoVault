// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {CryptoVault} from "../src/CryptoVault.sol";
import {ERC20} from "../src/ERC20.sol";

contract CryptoVaultTest is Test {
    CryptoVault public vault;
    ERC20 public token;

    address user;
    address owner;
    address zero = address(0);

    function setUp() public {
        owner = address(this);
        user = address(0xBEEF);

        token = new ERC20("TestToken", "TTK", 1_000_000);
        vault = new CryptoVault(2); // 2% withdrawal fee

        token.transfer(user, 1_000 * 1e18); 
        vm.startPrank(user);
        token.approve(address(vault), type(uint256).max);
        vm.stopPrank();
    }

    function testDeposit() public {
        vm.startPrank(user);
        vault.deposit(address(token), 500 * 1e18);
        vm.stopPrank();

        uint256 balance = vault.getUserBalance(user, address(token));
        assertEq(balance, 500 * 1e18, "Deposit failed");
    }

    function testWithdrawWithFee() public {
        vm.startPrank(user);
        vault.deposit(address(token), 500 * 1e18);
        vault.withdraw(address(token), 100 * 1e18);
        vm.stopPrank();

        uint256 userBalance = vault.getUserBalance(user, address(token));
        uint256 expectedRemaining = 400 * 1e18;
        assertEq(userBalance, expectedRemaining, "Incorrect user balance");

        uint256 fee = 2 * 1e18;
        uint256 accumulated = vault.getAccumulatedFees(address(token));
        assertEq(accumulated, fee, "Fee not correctly collected");
    }

    function testWithdrawFeesAsOwner() public {
        // User deposits and withdraws some to generate fees
        vm.startPrank(user);
        vault.deposit(address(token), 200 * 1e18);
        vault.withdraw(address(token), 100 * 1e18); // 2 TTK fee
        vm.stopPrank();

        uint256 before = token.balanceOf(owner);
        vault.withdrawFees(address(token), owner);
        uint256 afterBalance = token.balanceOf(owner);

        assertEq(afterBalance - before, 2 * 1e18, "Owner didn't receive correct fee amount");
    }

    function testZeroAddressCannotCall() public {
        // Simulate a call from address(0)
        vm.startPrank(zero);
        vm.expectRevert("Zero address not allowed");
        vault.deposit(address(token), 10);
        vm.stopPrank();
    }

    function testNonOwnerCannotWithdrawFees() public {
        vm.startPrank(user);
        vm.expectRevert("Not the owner");
        vault.withdrawFees(address(token), user);
        vm.stopPrank();
    }
}
