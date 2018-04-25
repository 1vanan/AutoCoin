pragma solidity ^0.4.0;

contract Specifications {
    uint[] characteristics;

    uint public mileage = characteristics[0];

    uint public pigeonholesStatus = characteristics[1];

    uint public carcassStatus = characteristics[2];

    uint public crashes = characteristics[3];

    uint public checkUp = characteristics[4];

    enum Color {RED, BLUE, YELLOW, WHITE, BLACK}

    enum Model {WV, SKODA, MERCEDES, PEUGEOT, FIAT, FORD, TOYOTA, NISSAN, RENAULT,
        CHEVROLET, HYUNDAY, VAZ, UAZ, GAZ}

    Color color;

    Model model;

    function Specifications(Color c, Model m, uint[] ch) public {
        color = c;

        model = m;

        characteristics = ch;
    }

    function getColor() returns (Color){
        return color;
    }

    function getModel() returns (Model){
        return model;
    }
}
