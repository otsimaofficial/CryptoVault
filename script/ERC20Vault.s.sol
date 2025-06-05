// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CryptoVault} from "../src/CryptoVault.sol";

contract CryptoVaultScript is Script {
    CryptoVault public ERC20VaultInstance;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        vm.stopBroadcast();
    }
}
