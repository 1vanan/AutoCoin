pragma solidity ^0.4.24;

import "github.com/Arachnid/solidity-stringutils/src/strings.sol";

contract BuySell {

    constructor(){
    models["VW"] = Model.VW;
    models["SKODA"] = Model.SKODA;
    models["MERCEDES"] = Model.MERCEDES;
    }

    enum Model {
        VW,
        SKODA,
        MERCEDES
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
        string storage vin;

        bool carIsAvailable = geMostRelevantCar(models[model], vin);

        require(carIsAvailable);

        Car storage carOnSell = availableCars[vin];

        require(msg.value == carOnSell.price);

        carOnSell.owner.transfer(msg.value);

        carOnSell.ownersCount ++;

        carOnSell.owner = msg.sender;
    }

    function geMostRelevantCar(Model model, string vin) private
    returns (bool){
        Car bestCar;
        bool wasFound = false;
        string vinOfRelevantCar;

        for (uint i = 0; i < vins.length; i++) {
            vinOfRelevantCar = vins[i];

            Car probCar = availableCars[vinOfRelevantCar];

            if (probCar.carModel == model) {
                vin = vinOfRelevantCar;

                wasFound = true;

                break;
            }
        }
        return wasFound;
    }

    function getCarsOfGivenModel(Model model) private returns (string[]){

    }

    function offerCar(string vin, uint price) public {
        require(!carAlreadyExist(vin));

        availableCars[vin] = Car(msg.sender, CheckModel(vin), price, 1);

        vins.push(vin);
    }

    function carAlreadyExist(string vin) private returns (bool){
        Car memory offeredCar = availableCars[vin];

        if (offeredCar.ownersCount == 0)
            return false;
        else
            return true;
    }

    function CheckModel(string vin) private returns (Model){
        return Model.VW;
    }

    function calculatePrice(uint vin) private returns (uint){
        return 10;
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