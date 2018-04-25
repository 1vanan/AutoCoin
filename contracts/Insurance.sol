pragma solidity ^0.4.0;
import "./Car.sol";

contract Insurance {
    Car[] carList;

    uint finishTime = 1546300800;

    mapping(address => uint) fee;

    function pushCar(Car car){
        carList.push(car);
    }

    function carWasHacked(Car car) returns (bool){
        //TODO: compare with data from @link carList.
        return false;
    }

    function getRevision(Car car)returns(uint[]){
        if(carWasHacked(car))
        car.setHackedStatus();
    }

    function getInsurance() returns(Insurance){
        return this;
    }

    function getFinishTime() returns(uint){
        return finishTime;
    }
}
