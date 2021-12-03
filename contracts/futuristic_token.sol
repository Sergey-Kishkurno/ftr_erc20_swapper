// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./safe_math.sol";
import "./ierc20.sol";

contract FuturisticToken is IERC20 {
    using SafeMath for *;
    
    mapping (address => uint256) private _balances;

    string private _name;
    string private _symbol;
    uint8 private _decimals = 18;

    uint256 private _totalSupply = 5_000 * (uint256(10) ** _decimals);

    address private owner = msg.sender;
    
    constructor () {
        _mint (msg.sender, _totalSupply); 
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
}

