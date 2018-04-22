pragma solidity ^0.4.0;

import "./Car.sol";
import "./SmartCoin.sol";

contract Participant {
    uint private balance = 0;

    SmartCoin private coins;

    function checkBuyPossibility(uint price) public returns (bool){
        return balance >= price;

    }

    function buyCar(address lastOwner, Car car) public {

    }
}
