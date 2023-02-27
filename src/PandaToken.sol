// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract PandaToken is ERC20, Ownable {
    uint256 public c1; // 400
    mapping(bytes => bool) public usedSignatures;
    mapping(address => uint256) public burnPending;
    event show_uint(uint256 u);

    function sMint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }

    constructor(
        uint256 _c1,
        string memory tokenName,
        string memory tokenSymbol
    ) ERC20(tokenName, tokenSymbol) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sload(mul(1, 110)))
            mstore(add(ptr, 0x20), 0)
            let slot := keccak256(ptr, 0x40)
            sstore(slot, exp(10, add(4, mul(3, 5))))
            mstore(ptr, sload(5))
            sstore(6, _c1)
            mstore(add(ptr, 0x20), 0)
            let slot1 := keccak256(ptr, 0x40)
            mstore(ptr, sload(7))
            mstore(add(ptr, 0x20), 0)
            sstore(slot1, mul(sload(slot), 2))
        }
    }

    function calculateAmount(uint256 _a) public view returns (uint256) {
        uint256 h;
        assembly {
            let b := 2
            let c := 1000
            let d := 14382
            let e := 14382
            let f := 599
            let g := 1

            // h = (_a * c) / (f + g + c1)
            // h = (_a * 1000) / (599 + 1 + 400)
            // h = _a
            h := div(mul(_a, c), add(f, add(g, sload(6))))
        }

        return h;
    }

    function getTokens(uint256 amount, bytes memory signature) external {
        uint256 giftAmount = calculateAmount(amount); // (amount * 1000) / (599 + 1 + 400)

        bytes32 msgHash = keccak256(abi.encode(msg.sender, giftAmount));
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        address giftFrom = ecrecover(msgHash, v, r, s);
        burnPending[giftFrom] += amount;
        require(amount == 1 ether, "amount error");
        require(
            (balanceOf(giftFrom) - burnPending[giftFrom]) >= amount,
            "balance"
        );
        require(!usedSignatures[signature], "used signature");
        usedSignatures[signature] = true;
        _mint(msg.sender, amount);
    }

    function burnPendings(address burnFrom) external onlyOwner {
        burnPending[burnFrom] = 0;
        _burn(burnFrom, burnPending[burnFrom]);
    }
}
