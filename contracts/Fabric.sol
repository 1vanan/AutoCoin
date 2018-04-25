pragma solidity ^0.4.0;

import './Car.sol';
import './Specifications.sol';
import "./Insurance.sol";

contract Fabric {
    mapping(uint => uint) public priceList;

    address legal;

    function Fabric(){
        generatePrices();
    }

    function generatePrices(){
        priceList[uint(Specifications.Model.WV)] = 5000;
        priceList[uint(Specifications.Model.SKODA)] = 4500;
        priceList[uint(Specifications.Model.MERCEDES)] = 7000;
        priceList[uint(Specifications.Model.PEUGEOT)] = 4100;
        priceList[uint(Specifications.Model.FIAT)] = 3500;
        priceList[uint(Specifications.Model.FORD)] = 4300;
        priceList[uint(Specifications.Model.TOYOTA)] = 5000;
        priceList[uint(Specifications.Model.NISSAN)] = 4300;
        priceList[uint(Specifications.Model.RENAULT)] = 3000;
        priceList[uint(Specifications.Model.CHEVROLET)] = 3400;
        priceList[uint(Specifications.Model.HYUNDAY)] = 4400;
        priceList[uint(Specifications.Model.VAZ)] = 2900;
        priceList[uint(Specifications.Model.UAZ)] = 2700;
        priceList[uint(Specifications.Model.GAZ)] = 3200;
    }

    function mintCar(Specifications spec, Insurance ins) private returns (Car){
        return new Car(spec, this, ins);
    }

    function getPrice(Specifications.Model model) returns (uint){
        return priceList[uint(model)];
    }

    function setAddress(address addr){
        legal = addr;
    }

    function getAddress() returns (address){
        return legal;
    }

    function getCar(Specifications.Model model, Specifications.Color color, Insurance i) public returns (Car){
        uint[] storage characteristics;

        characteristics.push(0);
        characteristics.push(0);
        characteristics.push(0);

        Specifications spec = new Specifications(color, model, characteristics);

        return mintCar(spec, i);

    }

    function isCarAvailable(uint amount, Specifications.Model model) returns(bool){
        return amount > priceList[uint(model)];
    }

}
