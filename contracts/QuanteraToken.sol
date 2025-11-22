// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract QuanteraToken {
    string public name = "Quantera";
    string public symbol = "QNR";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        uint256 initialSupply = 1_000_000_000 * 10**uint256(decimals);
        totalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "to zero");
        uint256 fromBalance = balanceOf[msg.sender];
        require(fromBalance >= value, "balance");
        unchecked {
            balanceOf[msg.sender] = fromBalance - value;
            balanceOf[to] += value;
        }
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(to != address(0), "to zero");
        uint256 fromBalance = balanceOf[from];
        require(fromBalance >= value, "balance");
        uint256 currentAllowance = allowance[from][msg.sender];
        require(currentAllowance >= value, "allowance");
        unchecked {
            balanceOf[from] = fromBalance - value;
            allowance[from][msg.sender] = currentAllowance - value;
            balanceOf[to] += value;
        }
        emit Transfer(from, to, value);
        return true;
    }
}
