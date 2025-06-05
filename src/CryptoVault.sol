// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "./IERC20.sol";

contract CryptoVault {
    address public owner;
    uint256 public withdrawalFeePercent;

    mapping(address => mapping(address => uint256)) public userBalances;
    mapping(address => uint256) public accumulatedFees;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier noZeroAddress() {
        require(msg.sender != address(0), "Zero address not allowed");
        _;
    }

    constructor(uint256 _withdrawalFeePercent) {
        require(msg.sender != address(0), "Owner cannot be zero address");
        owner = msg.sender;
        withdrawalFeePercent = _withdrawalFeePercent;
    }

    function deposit(address token, uint256 amount) external noZeroAddress {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        userBalances[msg.sender][token] += amount;
    }

    function withdraw(address token, uint256 amount) external noZeroAddress {
        require(userBalances[msg.sender][token] >= amount, "Insufficient balance");

        uint256 fee = (amount * withdrawalFeePercent) / 100;
        uint256 netAmount = amount - fee;

        userBalances[msg.sender][token] -= amount;
        accumulatedFees[token] += fee;

        require(IERC20(token).transfer(msg.sender, netAmount), "Withdraw failed");
    }

    function withdrawFees(address token, address to) external onlyOwner noZeroAddress {
        uint256 feeAmount = accumulatedFees[token];
        require(feeAmount > 0, "No fees");

        accumulatedFees[token] = 0;
        require(IERC20(token).transfer(to, feeAmount), "Fee withdraw failed");
    }

    function getUserBalance(address user, address token) external view returns (uint256) {
        return userBalances[user][token];
    }

    function getAccumulatedFees(address token) external view returns (uint256) {
        return accumulatedFees[token];
    }
}
