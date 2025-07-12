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

    // @dev Timestamp when campaign ends
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

    ///@dev Modifier to check if campaign still active
    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Campaign has ended");
        _;
    }

    ///@dev Modifier to check if campaign is over
    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Campaign is still active");
        _;
    }

    // @dev Event fired when a user contributes ETH
    event Contributed(address indexed contributor, uint amount);

    /// @notice Contribute ETH to the crowdfunding campaign
    /// @dev Increments total raised and tracks per-address contribution
    function contribute() public payable beforeDeadline {
        require(msg.value > 0, "Contribution must be greater than 0");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;

        emit Contributed(msg.sender, msg.value);
    }

    // @dev Event fired when the owner withdraws raised funds
    event Withdrawn(address indexed owner, uint amount);

    /// @notice Allows owner to withdraw raised funds if goal is met
    /// @dev Only callable once, after deadline and if goal is reached
    function withdrawFunds() public onlyOwner afterDeadline {
        require(!fundsWithdrawn, "Funds already withdrawn");
        require(totalRaised >= fundingGoal, "Funding goal not reached");

        fundsWithdrawn = true;

        uint amount = address(this).balance;
        payable(owner).transfer(amount);

        emit Withdrawn(owner, amount);
    }

    // @dev Event fired when a contributor claims a refund
    event Refunded(address indexed contributor, uint amount);

    /// @notice Allows contributors to claim refund if goal not reached
    /// @dev Refunds only allowed after deadline and only once per address
    function claimRefund() public afterDeadline {
        require(totalRaised < fundingGoal, "Funding goal was met");
        uint contributedAmount = contributions[msg.sender];
        require(contributedAmount > 0, "No contribution to refund");

        contributions[msg.sender] = 0; // Prevent re-entrancy
        payable(msg.sender).transfer(contributedAmount);

        emit Refunded(msg.sender, contributedAmount);
    }

    /// @notice Returns contract's current ETH balance
    /// @return balance Amount of ETH (in wei) held by this contract
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    /// @notice Returns seconds remaining until campaign deadline
    /// #return timeLeft Seconds left; returns 0 if deadline has passed
    function getTimeLeft() public view returns (uint) {
        if (block.timestamp >= deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }

}