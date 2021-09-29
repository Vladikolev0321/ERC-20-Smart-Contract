pragma solidity ^0.8.5;


 contract ADXLike {
    string public name;
    string public symbol;
    //uint8 public decimals;

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    uint256 private _totalSupply;
    string public startDate = "30th June";
    string public endDate = "30th July";
    uint256 public hardcapEth = 400000;
    string firstWeekEnd = "37th June";
    uint256 public constant endDays = 30;
    //uint256 totalEth
    
     // Token Distribution
    uint256 public tokenSalePercentage = 80;
    uint256 public foundersPercentage = 10;
    uint256 public wingsDaoPercentage = 2;
    uint256 public bountyPercentage = 2;
    
    
    uint256 public creationTime;
    
    

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    
    using SafeMath for uint256;
    
    constructor()  {
        name = "ADXLike";
        symbol = "ADX";
        //decimals = 18;
        _totalSupply = 139000000;
        creationTime = block.timestamp;
        

       balances[msg.sender] = _totalSupply;
    }
    
    
    function buyADX(uint256 amount) public{
        uint256 modifiedAmount = getBonusesByDay(amount);
        transfer(msg.sender, modifiedAmount);
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
    
    function compareDates() private view returns (uint256){
        // uint startDate = 1514764800; // 2018-01-01 00:00:00
        // uint endDate = 1518220800; // 2018-02-10 00:00:00
        
        uint256 currentTime = block.timestamp;
        uint256 diff = (currentTime - creationTime) / 60 / 60 / 24; 
        return diff;
    }
    
    function getBonusesByDay(uint256 amount) private view returns (uint256){
        uint256 dayDiff = compareDates();
        if(dayDiff == 1){
            return amount + amount * 30 / 100;
        }else if(dayDiff > 1 && dayDiff < 7){
            return amount + amount * 15 / 100;
        }else{
            return amount;
        }
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


