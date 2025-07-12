# 💸 Crowdfunding Smart Contract

A secure and transparent crowdfunding smart contract built in Solidity. It allows users to contribute ETH toward a campaign with a set goal and deadline. If the funding goal is met within the time limit, the project owner can withdraw the funds. Otherwise, contributors can claim refunds.

---

## 🚀 Features

- 🧑‍💼 Owner can start a campaign with goal and deadline
- 🪙 Users can contribute ETH to support the project
- 🔐 Owner can withdraw only if the funding goal is met before deadline
- 🧾 Contributors can claim a refund if the goal is not reached
- 📝 Event logs for contributions, withdrawals, and refunds

---

## 🛠 Technologies Used

- Solidity `^0.8.20`
- Remix IDE or Hardhat for development
- MetaMask for interacting with contract
- Goerli or Sepolia Testnet for deployment

---

## 📜 Smart Contract Functions

### `constructor(uint _goal, uint _duration)`
Initializes the campaign with a funding goal and duration in seconds.

### `contribute() payable`
Allows users to send ETH to support the campaign.

### `withdrawFunds()`
Lets the owner withdraw ETH if the goal is met and time hasn't expired.

### `claimRefund()`
Allows contributors to get refunds if the goal wasn’t reached by the deadline.

### `getContractBalance()`
Returns the total ETH held in the contract.

### `getTimeLeft()`
Returns time left before the campaign expires.

---

## 🧪 How to Use

1. Deploy using Remix with a goal (in wei) and duration (in seconds).
2. Use multiple wallets to call `contribute()` with ETH.
3. Once the campaign ends, test `withdrawFunds()` or `claimRefund()` as appropriate.

---

## 📢 Events

- `Contributed(address indexed contributor, uint amount)`
- `Withdrawn(address indexed owner, uint amount)`
- `Refunded(address indexed contributor, uint amount)`

---

## 📜 License

MIT License

---

## 🧠 Author

**Hilmi KT**  
Blockchain Developer | Web3 Explorer | Solidity Builder  
[LinkedIn](https://www.linkedin.com/in/hilmi-kt)