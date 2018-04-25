pragma solidity ^0.4.0;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract SmartCoin is MintableToken {
    string public name = "SmartCoin token";

    string public symbol = "NOT";

    uint public decimals = 18;

    function SmartCoin(){


    }
}