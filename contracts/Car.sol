pragma solidity ^0.4.0;

import "./Participant.sol";
import "./Specifications.sol";
import "./Fabric.sol";
import "./Insurance.sol";

contract Car {
    Participant private owner;

    Specifications private specs;

    Fabric private emisFabric;

    Insurance insurance;

    bool private hacked = false;

    function Car(Specifications s, Fabric f, Insurance i) public {
        specs = s;

        emisFabric = f;

        insurance = i;
    }

    function setOwner(Participant carOwner) public {
        owner = carOwner;
    }

    function getOwner() public returns (Participant){
        return owner;
    }

    function getSpecifications() public returns (Specifications){
        return specs;
    }

    function setHackedStatus(){
        hacked = false;
    }

    function wasHacked() returns (bool){
        return hacked;
    }

    function getEmissionFabric() returns (Fabric){
        return emisFabric;
    }

    function getInsurance() returns (Insurance){
        return insurance;
    }
}
