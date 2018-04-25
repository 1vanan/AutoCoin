pragma solidity ^0.4.0;

import "./Car.sol";
import "./SmartCoin.sol";
import "./Fabric.sol";
import "./Insurance.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract Participant {
    using SafeMath for uint256;

    uint private balance = coin.balanceOf(this);

    SmartCoin private coin;

    Car private car;

    function checkBuyPossibility(uint price) public returns (bool){
        return balance >= price;

    }

    function buyCar(Participant lastOwner, Car car, Insurance ins) public {
        uint price = calculatePrice(lastOwner.getCar());

        uint insPrice = price.div(10);

        if (availableInsurance(car))
            require(balance >= price);
        else
            require(balance >= price + insPrice);

        coin.transferFrom(lastOwner.getAddress(), this, price);
    }

    function buyNewCar(Fabric fabric, Specifications.Model model, Specifications.Color color){
        uint price = fabric.getPrice(model);

        uint insPrice = price.div(10);

        Insurance ins = new Insurance();

        require(price + insPrice <= balance);

        coin.transferFrom(ins, this, insPrice);

        coin.transferFrom(fabric.getAddress(), this, price);

        car = fabric.getCar(model, color, ins);
    }

    function availableInsurance(Car car) returns (bool){
        return car.getInsurance().getFinishTime() > now;
    }

    function getBalance() returns (uint){
        return balance;
    }

    function getCar() returns (Car){
        return car;
    }

    function calculatePrice(Car car) returns (uint){
        uint initialPrice = car.getEmissionFabric().getPrice(car.getSpecifications().getModel());
        return 3000;
    }

    function getAddress() returns (address){
        return this;
    }

    function fillUp(uint amount){
        coin.mint(this, amount);
    }
}
