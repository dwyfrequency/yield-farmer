pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
    }

    // TODO 1:03:34 https://www.youtube.com/watch?v=CgXQC4dbGUE&feature=youtu.be
    // 1. Stake Tokens

    // 2. Unstake Tokens
}
