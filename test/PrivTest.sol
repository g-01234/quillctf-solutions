// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/WETH10.sol";
import "forge-std/console.sol";

contract Priv {
    uint256 private x = 1;
}

contract PrivTest is Test {
    using stdStorage for StdStorage;

    Priv public p;

    function setUp() public {
        p = new Priv();
    }

    function testP() public view {
        console.log(uint256(vm.load(address(p), 0)));
    }
}
