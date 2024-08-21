// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IERC20{
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external  view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns(bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address spender, uint256 value);
}

contract DIOCoin is IERC20 {
    string public constant name = 'DIO COIN';
    string public constant symbol = 'DIO';
    uint8 public  constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor(){
        balances[msg.sender] = totalSupply_;
    }
    function totalSupply() public override view returns (uint256 total){
        return  totalSupply_;
    }
    function balanceOf(address addressOwner) public override view returns (uint256 balance){
        return balances[addressOwner];
    }
    function transfer(address receiver, uint256 amount) public override returns (bool success){
        require(amount <= balances[receiver]);
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[receiver] = balances[receiver] + amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }
    function approve(address delegate, uint256 amount) public override returns(bool success){
        allowed[msg.sender][delegate] = amount;
        emit Approval(msg.sender, delegate, amount);
        return true;
    }
    function allowance(address addressOwner, address addressDelegate) public override view returns(uint256 amount){
        return allowed[addressOwner][addressDelegate];
    }
    function transferFrom(address addressOwner, address addressBuyer, uint256 amount) public override returns(bool success){
        require(amount <= balanceOf(addressOwner));
        require(amount <= allowed[addressOwner][msg.sender]);
        balances[addressOwner]=balances[addressOwner]-amount;
        allowed[addressOwner][msg.sender] = allowed[addressOwner][msg.sender] - amount;
        balances[addressBuyer]=balances[addressBuyer]+amount;
        emit Transfer(addressOwner, addressBuyer, amount);
        return true;
    }
}
