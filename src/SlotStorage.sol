pragma solidity ^0.8.17;

import "forge-std/Test.sol";

contract SlotStorage {
    bytes32 public immutable ghost =
        0x68747470733a2f2f6769746875622e636f6d2f61726176696e64686b6d000000;
    struct ghostStore {
        bytes32[] hash;
        mapping(uint256 => mapping(address => ghostStore)) map;
        uint256 i;
    }
    uint256 pad;
    mapping(address => mapping(uint256 => ghostStore)) private ghostInfo;

    mapping(address => mapping(uint256 => ghostStore)) gi;

    constructor() {
        ghostInfo[tx.origin][block.number]
        .map[block.timestamp][msg.sender]
        .map[block.prevrandao][block.coinbase]
            .map[block.chainid][
                address(
                    uint160(uint256(blockhash(block.number - block.basefee)))
                )
            ]
            .hash
            .push(ghost);

        ghostInfo[tx.origin][block.number].i = 1;

        ghostInfo[tx.origin][block.number]
        .map[block.timestamp][msg.sender].i = 2;

        ghostInfo[tx.origin][block.number]
        .map[block.timestamp][msg.sender]
        .map[block.prevrandao][block.coinbase].i = 3;

        ghostInfo[tx.origin][block.number]
        .map[block.timestamp][msg.sender]
        .map[block.prevrandao][block.coinbase]
        .map[block.chainid][
            address(uint160(uint256(blockhash(block.number - block.basefee))))
        ].i = 4;
    }

    function getSlot() public view returns (bytes32) {
        bytes32 slot1 = keccak256(
            abi.encode(
                uint256(block.number),
                keccak256(abi.encode(tx.origin, uint256(1)))
            )
        );
        ghostStore storage gs1;
        assembly {
            gs1.slot := slot1
        }
        console.log(gs1.i);

        bytes32 slot2 = keccak256(
            abi.encode(
                address(msg.sender),
                keccak256(
                    abi.encode(uint256(block.timestamp), uint256(slot1) + 1)
                )
            )
        );
        ghostStore storage gs2;
        assembly {
            gs2.slot := slot2
        }
        console.log(gs2.i);

        bytes32 slot3 = keccak256(
            abi.encode(
                address(block.coinbase),
                keccak256(
                    abi.encode(uint256(block.prevrandao), uint256(slot2) + 1)
                )
            )
        );
        ghostStore storage gs3;
        assembly {
            gs3.slot := slot3
        }
        console.log(gs3.i);

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

        ghostStore storage gs4;
        assembly {
            gs4.slot := slot4
        }
        console.log(gs4.i);

        bytes32 slot5 = keccak256(abi.encode(slot4));
        bytes32 slotval;
        assembly {
            slotval := sload(slot5)
        }
        console.logBytes32(slotval);
        console.logBytes32(slot5);
        return slot5;
    }
}
