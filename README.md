# 🔐 CryptoVault

## About

**CryptoVault** is a Solidity smart contract designed for securely storing **ERC20 tokens** in a vault on the blockchain. It allows users to deposit and withdraw tokens, while charging a small fee on withdrawals. The contract also stores collected fees, which can be withdrawn separately by the owner.

This project was developed as part of my **Blockchain Developer Cohort Assignment** to demonstrate core concepts in Solidity, contract security, and ERC20 token integration **without relying on OpenZeppelin libraries**.



## ✨ Features

* ✅ Deposit any ERC20-compliant token into the vault
* ✅ Withdraw tokens with a customizable percentage-based fee
* ✅ Automatically store withdrawal fees within the contract
* ✅ Allow the contract owner to withdraw accumulated fees
* ✅ Getter functions to check user balances and total fees
* ✅ Zero address protection for all external functions



## 🗂 Project Structure


/CryptoVaultProject
│
├── /src
│   ├── IERC20.sol        # ERC20 interface (custom)
│   ├── ERC20.sol         # Custom ERC20 implementation
│   └── CryptoVault.sol   # Main vault smart contract
│
└── /test
    └── CryptoVault.t.sol # Foundry test suite




## 🧪 Testing

This project uses **Foundry** for smart contract testing. To run the tests:

```bash
forge install
forge build
forge test
```



## 🔒 Security Practices

* Restricts all function calls from `address(0)`
* Implements `onlyOwner` for fee withdrawal
* Avoids external libraries for educational transparency
* Follows Solidity ^0.8.26 safety (no need for SafeMath)



## 📜 License

This project is licensed under the MIT License.