pragma solidity ^0.4.24;

import "github.com/ethereum/dapp-bin/library/stringUtils.sol";

contract BuySell {

    constructor(){
        models["VW"] = Model.VW;
        models["SKODA"] = Model.SKODA;
        models["LEXUS"] = Model.LEXUS;
    }

    enum Model {
        VW,
        SKODA,
        LEXUS
    }

    struct Car {
        address owner;

        Model carModel;

        uint price;

        uint ownersCount;
    }

    mapping(string => Car) availableCars;

    mapping(string => Model) models;

    string[] vins;

    function buyCar(string model) public payable {
        Car storage carOnSell = availableCars[geMostRelevantCar(models[model])];

        require(msg.value == carOnSell.price);

        carOnSell.owner.transfer(msg.value);

        carOnSell.ownersCount ++;

        carOnSell.owner = msg.sender;
    }

    function geMostRelevantCar(Model model) private returns (string){
        string vinOfRelevantCar;
        bool wasFound = false;

        for (uint i = 0; i < vins.length; i++) {
            vinOfRelevantCar = vins[i];

            Car probCar = availableCars[vinOfRelevantCar];

            if (probCar.carModel == model) {
                wasFound = true;

                return vinOfRelevantCar;
            }
        }

        require(wasFound);
    }

    function getCarsOfGivenModel(Model model) private returns (string[]){

    }

    function offerCar(string vin, uint price) public {
        require(!carAlreadyExist(vin));

        availableCars[vin] = Car(msg.sender, checkModel(vin), price, 1);

        vins.push(vin);
    }

    function carAlreadyExist(string vin) private returns (bool){
        Car memory offeredCar = availableCars[vin];

        if (offeredCar.ownersCount == 0)
            return false;
        else
            return true;
    }

    function checkModel(string vin) private returns (Model){
        string memory modelStr = substring(vin, 3, 4);

        if (StringUtils.equal(modelStr, "W"))
            return models["WV"];

        if (StringUtils.equal(modelStr, "B"))
            return models["SKODA"];

        if (StringUtils.equal(modelStr, "8"))
            return models["LEXUS"];
    }

    function substring(string str, uint startIndex, uint endIndex) private
    constant returns (string) {
        bytes memory strBytes = bytes(str);

        bytes memory result = new bytes(endIndex - startIndex);

        for (uint i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }

        return string(result);
    }

    function checkCarOwner(string carVin) public constant returns (address){
        Car car = availableCars[carVin];

        return car.owner;
    }

    function checkOwners(string carVin) public constant returns (uint){
        Car car = availableCars[carVin];

        return car.ownersCount;
    }
}