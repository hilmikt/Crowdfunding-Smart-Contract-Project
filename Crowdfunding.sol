// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


/// @title Crowdfunding Smart Contract
/// @author Hilmi
/// @notice Allows ETH-based crowdfunding with a goal, deadline, withdrawal, and refunds


contract Crowdfunding {
    // @dev Address of the campaign creator (admin)
    address public owner;

    // @dev Target amount to raise (in wei)
    uint public fundingGoal;

    // @dev Timestamp when campaign ends;
    uint public deadline;

    // @dev Total amount of ETH raised so far
    uint public totalRaised;

    // @dev Track contribution per address
    mapping(address => uint) public contributions;

    // @dev Track whether owner has already withdrawn
    bool public fundsWithdrawn;

    /// @notice Set funding goal and campaign duration (in seconds)
    /// @param _goal The target amount in wei
    /// @param _duration Campaign duration from now (in seconds)
    constructor(uint _goal, uint _duration) {
        require(_goal > 0, "Goal must be greater than zero");
        require(_duration > 0, "Duration must be positive");

        owner = msg.sender;
        fundingGoal = _goal;
        deadline = block.timestamp + _duration;
    }

    /// @dev Modifier to restrict actions to campaign owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    ///@dev Modifier to check  if campaign is over
    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Campaign is still active");
        _;
    }

}