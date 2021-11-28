pragma solidity ^0.8.10;
// SPDX-License-Identifier: MIT

interface IERC20 {
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
}