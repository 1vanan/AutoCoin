pragma solidity ^0.4.0;

import "./Car.sol";
import "./SmartCoin.sol";
import "./Fabric.sol";

contract Participant {
    uint private balance = coin.balanceOf(this);

    SmartCoin private coin;

    Car car;

    address myAddr = this;

    function checkBuyPossibility(uint price) public returns (bool){
        return balance >= price;

    }

    function buyCar(Participant lastOwner, Car car) public {
        uint price = calculatePrice(lastOwner.getCar());
        require(price <= balance);

        coin.transferFrom(lastOwner.getAddress(), myAddr, price);
    }

    function buyNewCar(Fabric fabric, Specifications specs){
        uint price = fabric.getPrice(specs.getModel());

        require(price <= balance);

        coin.transferFrom(fabric.getAddress(), myAddr, price);
    }

    function getBalance() returns (uint){
        return balance;
    }

    function getCar() returns (Car){
        return car;
    }

    function calculatePrice(Car car) returns (uint){
        return 3000;
    }

    function getAddress() returns (address){
        return myAddr;
    }
}
