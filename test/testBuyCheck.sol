pragma solidity ^0.4.0;
import "../contracts/Fabric.sol";
import "../contracts/Participant.sol";

contract testBuyCheck {
    function testBuy(){
        Fabric fabric = new Fabric();

        Participant buyer = new Participant();

        Participant seller = new Participant();

        SmartCoin coin = new SmartCoin();

        coin.increaseApproval(buyer.getAddress(), 5000);

        assert(pa)
    }
}
