pragma solidity ^0.4.24;

import "github.com/ethereum/dapp-bin/library/stringUtils.sol";

contract BuySell {//TODO: requires

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
        Model carModel;

        uint[] priceHistory;

        address[] ownersHistory;

        uint[] mileageHistory;

        uint[] statusHistory;

        bool onSale;

        uint ownerCount;
    }

    mapping(string => Car) availableCars;

    mapping(string => Model) models;

    string[] vins;

    function buyCar(string model) public payable {
        Car storage carOnSell = availableCars[geMostRelevantCar(models[model])];

        uint[] storage prices = carOnSell.priceHistory;

        address[] storage owners = carOnSell.ownersHistory;

        // require(msg.value == prices[prices.length - 1]);

        owners[owners.length - 1].transfer(msg.value);

        owners.push(msg.sender);

        carOnSell.ownerCount++;

        carOnSell.onSale = false;
    }

    function sellCar(string vin, uint milleage, uint price, uint status)
    public {
        Car storage sellingCar = availableCars[vin];
        sellingCar.onSale = true;

        sellingCar.priceHistory.push(price);

        sellingCar.mileageHistory.push(milleage);

        sellingCar.ownersHistory.push(msg.sender);

        sellingCar.statusHistory.push(status);
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

    // function getCarsOfGivenModel(Model model) public returns (string[]){
    //     string[] neededVins;
    //     for(uint i = 0; i < vins.length; i++){
    //         string vin = vins[i];
    //         if(availableCars[vin].carModel == model)
    //             neededVins.push(vin);
    //     }
    // }

    function offerCar(string vin, uint milleage, uint price, uint ownerCount,
        uint status) public {
        // require(!carAlreadyExist(vin));

        uint[] storage newPriceHistory;

        uint[] storage newMilleageHistory;

        uint[] storage newStatusHistory;

        address[] storage newOwnersHistory;

        newPriceHistory.push(price);

        newMilleageHistory.push(milleage);

        newStatusHistory.push(status);

        newOwnersHistory.push(msg.sender);

        availableCars[vin] = Car(checkModel(vin), newPriceHistory,
            newOwnersHistory, newMilleageHistory, newStatusHistory,
            true, ownerCount);

        vins.push(vin);
    }

    function carAlreadyExist(string vin) private returns (bool){
        Car memory offeredCar = availableCars[vin];

        if (offeredCar.ownersHistory.length - 1 == 0)
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

        return car.ownersHistory[car.ownersHistory.length - 1];
    }

    function checkOwners(string carVin) public constant returns (uint){
        return availableCars[carVin].ownerCount;
    }
}