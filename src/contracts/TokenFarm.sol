pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public owner;
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;
    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public isStaking;
    mapping(address => bool) public hasStaked;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        owner = msg.sender;
        dappToken = _dappToken;
        daiToken = _daiToken;
    }

    modifier isOwner(address _sender) {
        require(_sender == owner, "Only owner can issue tokens");
        _;
    }

    modifier positiveAmount(uint256 _amount) {
        require(_amount > 0, "Please enter a positive amount");
        _;
    }

    modifier hasFunds(address _investor) {
        require(stakingBalance[_investor] > 0, "You do not have any funds.");
        _;
    }

    // TODO 1:03:34 https://www.youtube.com/watch?v=CgXQC4dbGUE&feature=youtu.be
    // 1. Stake Tokens
    function stakeTokens(uint256 _amount) public positiveAmount(_amount) {
        // Transfer Mock Dai Tokens to TokenFarm for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update staking balance
        stakingBalance[msg.sender] += _amount;

        // Add user to stakers array only if they haven't staked already
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
            // Update staking status
            isStaking[msg.sender] = true;
            hasStaked[msg.sender] = true;
        }
    }

    // 2. Unstake Tokens
    function unstakeTokens(uint256 _amount)
        public
        positiveAmount(_amount)
        hasFunds(msg.sender)
    {
        // Transfer Mock Dai Tokens from TokenFarm to investor
        daiToken.transfer(msg.sender, _amount);

        for (uint256 index = 0; index < stakers.length; index++) {
            if (stakers[index] == msg.sender) {}
        }
        // stakers = stakers.splice
        // Update staking status
        isStaking[msg.sender] = false;
        hasStaked[msg.sender] = false;
    }

    // Issuing Tokens
    function issueTokens() public isOwner(msg.sender) {
        for (uint256 i = 0; i < stakers.length; i++) {
            address staker = stakers[i];
            uint256 balance = stakingBalance[staker];
            if (balance > 0) {
                dappToken.transfer(staker, balance);
            }
        }
    }
}
