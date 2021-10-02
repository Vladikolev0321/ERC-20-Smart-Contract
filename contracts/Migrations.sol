pragma solidity ^0.8.5;


 contract ADXLike {
     
    address payable owner = payable(address(this));
     
    string public name;
    string public symbol;
    //uint8 public decimals;

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    uint256 private _totalSupply;
    string public startDate = "30th June";
    string public endDate = "30th July";
    uint256 public hardcapEth = 400000;
    uint256 public currentEth = 0;
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
    
    function getCurrentTime() public view returns (uint256){ return block.timestamp; }
    
    function buyADX() public payable returns(bool){
        //uint256 modifiedAmount = getBonusesByDay(convertEthToAdx(amount));
        //owner.transfer(msg.value);
        currentEth = currentEth.add(msg.value);
        
        uint tokens = getBonusesByDay(convertEthToAdx(msg.value));
        ////
        transferFromContract(msg.sender, tokens);
        return true;
    }
    
    function transferFromContract(address _to, uint amountTokens) private returns (bool){
        _totalSupply = _totalSupply.subtract(amountTokens);
        balances[_to] = balances[_to].add(amountTokens);
        emit Transfer(address(this), _to, amountTokens);
        return true;
    }
    
    
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

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
    function transfer(address receiver, uint amountTokens) public  returns (bool success) {
        require(amountTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].subtract(amountTokens);
        balances[receiver] = balances[receiver].add(amountTokens);
        emit Transfer(msg.sender, receiver, amountTokens);
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
    
    
    function transferFrom(address owner, address receiver, uint tokens) public returns (bool) {
        require(tokens <= balances[owner]);    
        require(tokens <= allowed[owner][receiver]);
    
        balances[owner] = balances[owner].subtract(tokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].subtract(tokens);
        balances[receiver] = balances[receiver].add(tokens);
        emit Transfer(owner, receiver, tokens);
        return true;
    }
    
    function compareDates() private view returns (uint256){
    
        uint256 currentTime = block.timestamp;
        uint256 diff = (currentTime - creationTime).div(60).div(60).div(24); 
        return diff;
    }
    
    function getBonusesByDay(uint256 amount) private view returns (uint256){
        uint256 dayDiff = compareDates();
        if(dayDiff <= 1){
            return amount + amount.mul(30).div(100);
        }else if(dayDiff > 1 && dayDiff < 7){
            return amount + amount.mul(15).div(100);
        }else{
            return amount;
        }
    }
    
    function convertEthToAdx(uint256 amount)private pure returns(uint256){
        return amount.mul(900);
    }
    function convertAdxToEth(uint256 amount)private pure returns(uint256){
        return amount * 900;
    }
    
    
}

library SafeMath{
    function subtract(uint a, uint b) internal pure returns (uint) {
      assert(b <= a);
      return a - b;
    }
    
    function add(uint a, uint b) internal pure returns (uint) {
      uint c = a + b;
      assert(c >= a);
      return c;
    }
    
    function mul(uint a, uint b) public pure returns (uint) {
        uint c = a * b; 
        assert(a == 0 || c / a == b);
        return c;
    } 
    function div(uint a, uint b) public pure returns (uint) {
        assert(b > 0);
        uint c = a / b;
        return c;

    }
    
    
}


