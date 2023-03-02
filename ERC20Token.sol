// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable {
    uint256 maxSupply = 50000000000 * 10**2;
    address presaleAddress;

    constructor() ERC20("HydromotionCoin", "HYM") {}

    function mint(address to) public onlyOwner {
        // require(totalSupply() <= maxSupply, "Max Supply Reached");

        _mint(to, maxSupply);
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        require(
            msg.sender == presaleAddress,
            "Only Called with Presale Smart Contract"
        );
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        require(
            msg.sender == presaleAddress,
            "Only Called with Presale Smart Contract"
        );
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function setPresaleAddress(address add) public onlyOwner {
        presaleAddress = add;
    }
}
