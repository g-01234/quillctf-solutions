// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/CollatzPuzzle.sol";

contract CollatzPuzzleTest is Test {
    address atk;
    CollatzPuzzle cz;

    function setUp() public {
        cz = new CollatzPuzzle();
        // could definitely be smaller but passes 32b runtime bytecode check
        bytes
            memory bytecode = hex"6020600c60003960206000f360043560028106156014576003026001016019565b600290045b3452602034f3";

        assembly {
            sstore(atk.slot, create(0, add(bytecode, 0x20), mload(bytecode)))
        }
    }

    function testHack() public view {
        cz.callMe(address(atk));
    }
}
