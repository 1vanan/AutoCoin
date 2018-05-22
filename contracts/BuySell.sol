pragma solidity ^0.4.24;

import "github.com/ethereum/dapp-bin/library/stringUtils.sol";

//TODO: fix function getCarsOfGivenModel()
//TODO: getMostRelevantCar должен выбирать авто с наивысшим статусом, а возвращать bool
contract BuySell {

    struct Car {
        string carModel;

        uint[] priceHistory;

        address[] ownersHistory;

        uint[] mileageHistory;

        uint[] statusHistory;

        bool onSale;

        uint ownerCount;

        uint blockchainCount;
    }

    mapping(string => Car) availableCars;

    string[] vins;

    function buyCar(string model, uint status) public payable {
        Car storage carOnSell = availableCars[getMostRelevantCar(model,
            status)];

        uint[] memory prices = carOnSell.priceHistory;

        address[] storage owners = carOnSell.ownersHistory;

        uint[] memory statuses = carOnSell.statusHistory;

        require(carOnSell.onSale);

        require(msg.value == prices[prices.length - 1]);

        require(statuses[statuses.length - 1] >= status);

        carOnSell.ownersHistory[carOnSell.ownersHistory.length - 1].
        transfer(msg.value);

        require(transferKeys(vins[carOnSell.blockchainCount - 1], msg.sender));

        owners.push(msg.sender);

        carOnSell.ownerCount++;

        carOnSell.onSale = false;
    }

    function getMostRelevantCar(string modelStr, uint status) constant private
    returns (string){
        bool wasFound = false;

        Car memory probCar;

        string memory probVin;

        for (uint i = 0; i < vins.length; i++) {
            probVin = vins[i];
            probCar = availableCars[probVin];

            if (StringUtils.equal(probCar.carModel, modelStr) && probCar.statusHistory[probCar.
            statusHistory.length - 1] >= status) {
                wasFound = true;

                return vins[i];
            }
        }

        require(wasFound);
    }

    function transferKeys(string vin, address newOwner) private returns (bool){
        Car memory car = availableCars[vin];

        address prevOwner = car.ownersHistory[car.ownersHistory.length - 1];

        return true;
    }

    function sellCar(string vin, uint milleage, uint price, uint status)
    public {
        require(carAlreadyExist(vin));

        require(checkStatus(vin, milleage, status));

        Car storage sellingCar = availableCars[vin];

        require(!sellingCar.onSale);

        sellingCar.onSale = true;

        sellingCar.priceHistory.push(price);

        uint lastMileage = sellingCar.mileageHistory[sellingCar.mileageHistory.
        length - 1];

        require(milleage >= lastMileage);

        sellingCar.mileageHistory.push(milleage);

        sellingCar.ownersHistory.push(msg.sender);

        sellingCar.statusHistory.push(status);
    }

    function offSale(string vin) public {
        require(carAlreadyExist(vin));

        Car storage sellingCar = availableCars[vin];

        require(sellingCar.ownersHistory[sellingCar.ownersHistory.length - 1]
            == msg.sender);

        sellingCar.onSale = false;
    }

    function offerCar(string vin, uint milleage, uint price, uint ownerCount,
        uint status) public {
        require(!carAlreadyExist(vin));

        require(checkStatus(vin, milleage, status));

        vins.push(vin);

        Car memory car = Car(checkModel(vin), new uint[](0), new address[](0),
            new uint[](0), new uint[](0), true, ownerCount, vins.length);

        availableCars[vin] = car;

        availableCars[vin].priceHistory.push(price);
        availableCars[vin].mileageHistory.push(milleage);
        availableCars[vin].statusHistory.push(status);
        availableCars[vin].ownersHistory.push(msg.sender);
    }

    function checkStatus(string vin, uint milleage, uint status) private
    returns (bool){
        //compare offered auto status with insurance and auto services
        return true;
    }

    function carAlreadyExist(string vin) private returns (bool){
        Car memory offeredCar = availableCars[vin];

        if (offeredCar.ownersHistory.length >= 1)
            return true;
        else
            return false;
    }

    function checkModel(string vin) constant private returns (string){
        string memory modelStr = substring(vin, 3, 4);

        if (StringUtils.equal(modelStr, "W")) {
            return "VW";
        }

        if (StringUtils.equal(modelStr, "B")) {
            return "SKODA";
        }

        if (StringUtils.equal(modelStr, "8")) {
            return "LEXUS";
        }
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

    function getCarOwner(string carVin) public constant returns (address){
        Car memory car = availableCars[carVin];

        require(car.onSale);

        return car.ownersHistory[car.ownersHistory.length - 1];
    }

    function getOwnersCount(string carVin) public constant returns (uint){
        Car memory car = availableCars[carVin];

        require(car.onSale);

        return car.ownerCount;
    }

    function getPrice(string carVin) public constant returns (uint){
        Car memory car = availableCars[carVin];

        require(car.onSale);

        return car.priceHistory[car.priceHistory.length - 1];
    }

    function getMileage(string carVin) public constant returns (uint){
        Car memory car = availableCars[carVin];

        require(car.onSale);

        return car.mileageHistory[car.mileageHistory.length - 1];
    }

    function getStatus(string carVin) public constant returns (uint){
        Car memory car = availableCars[carVin];

        require(car.onSale);

        return car.statusHistory[car.statusHistory.length - 1];
    }

    function getAllCarsCount() public constant returns (uint){
        return vins.length;
    }

    function getCarModel(string vin) public constant returns (string){
        Car memory car = availableCars[vin];

        require(car.onSale);

        return car.carModel;
    }

    function getCarsOfGivenModel(string model) constant public
    returns (uint[]){
        uint[] memory neededVinNums = new uint[](5);

        for (uint i = 0; i < vins.length; i++) {
            string memory vin = vins[i];

            if (StringUtils.equal(availableCars[vin].carModel, model))
                neededVinNums[i] = i;
        }

        return neededVinNums;
    }

    function getVinByNum(uint num) constant public returns (string vin){
        return vins[num];
    }
}