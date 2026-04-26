# Gasless Meta-Transaction Relay

This repository provides an expert-level solution for onboarding users to Web3 without the friction of gas fees. It utilizes EIP-712 for secure off-chain signing and a Relayer pattern to submit transactions to the blockchain.

### Features
* **EIP-712 Integration:** Uses typed data hashing to ensure users know exactly what they are signing.
* **Relayer Logic:** A central or decentralized entity pays the gas in exchange for off-chain signatures.
* **Nonce Management:** Includes custom nonce tracking within the contract to prevent replay attacks across transactions.

### Workflow
1. User signs a message (off-chain) containing transaction details.
2. The Relayer receives the signature and transaction data.
3. The Relayer calls the `executeMetaTransaction` function on-chain.
4. The contract verifies the signature and executes the logic as if the user sent it.
