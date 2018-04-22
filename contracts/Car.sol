pragma solidity ^0.4.0;

import "./Participant.sol";
import "./Specifications.sol";

contract Car {
    Participant public owner;

    Specifications specs;

    function Car(Specifications s) public {
        specs = s;
    }

    function setOwner(Participant carOwner) public {
        owner = carOwner;
    }

    function getOwner() public returns (Participant){
        return owner;
    }


}
