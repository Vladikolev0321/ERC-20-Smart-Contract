// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract BntLikeToken {
    string public name;
    string public symbol;
    //uint8 public decimals;

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    uint256 private _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    
    using SafeMath for uint256;
    
    constructor() public {
        name = "Bancor";
        symbol = "BNT";
        //decimals = 18;
        _totalSupply = 232000000;

       balances[msg.sender] = _totalSupply;
    }
    
    
    /*This function returns the total amount of tokens that exist in the Ethereum network at the moment.*/
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    /*This function returns the account balance of the token owner's account. It takes the address of the owner as a function parameter.*/
    function balanceOf(address tokenOwner) public view returns (uint balance){
        return balances[tokenOwner];
    }

    /*
    This function returns amount with the token owner which a user/spender is allowed to spend/withdraw.
    It takes the address of the token owner and address of the user/spender as function parameters.
    Actually the amount returned is the amount set in approve function.
    */
    function allowance(address tokenOwner, address spender) public /*constant*/view returns (uint remaining){
        return allowed[tokenOwner][spender];
    }
    
    /*This function sends specified amount of tokens to a address from the token contract.
    It takes the recepient address and the amount of tokens as function parameters.
    The function returns a boolean value which indicates the success or failure of the transaction.
    */
    function transfer(address receiver, uint tokens) public returns (bool success) {
        require(tokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].subtract(tokens);
        balances[receiver] = balances[receiver].add(tokens);
        emit Transfer(msg.sender, receiver, tokens);
        return true;
        
    }
    
    /*This function approves that the specified account address is eligible to spend the tokens specified.
    It takes address of the user which needs approval and the token amount to be approved for transfer/spend.
    The function returns a boolean value which indicates the success or failure of the approval.
    */
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    
    /*This function transfers the amount of tokens from the 'from' address to the 'to' address.
    It takes from address, to address and the amount of tokens to be transferred as function parameters.
    The function returns boolean value which indicates the success or failure of the transaction.
    */
    function transferFrom(address owner, address receiver, uint tokens) public returns (bool success) {
        require(tokens <= balances[owner]);    
        require(tokens <= allowed[owner][msg.sender]);
    
        balances[owner] = balances[owner].subtract(tokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].subtract(tokens);
        balances[receiver] = balances[receiver].add(tokens);
        emit Transfer(owner, receiver, tokens);
        return true;
    }
    
    
}

library SafeMath{
    function subtract(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
    
}
