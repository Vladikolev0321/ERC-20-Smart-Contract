pragma solidity ^0.8.5;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";
import "./SafeMath.sol";
 contract ADXLike {
     
    using SafeMath for uint256;

    address private contractOwner;
     
    
    string public name;
    string public symbol;
    //uint8 public decimals;
    uint256 private _totalSupply;
    string public startDate = "30th June";
    string public endDate = "30th July";
    uint256 public hardcapEth = 400000;
    uint256 public currentEth = 0;
    string firstWeekEnd = "37th June";
    uint256 public constant endDays = 30;
    //uint256 totalEth
    
     // Token Distribution
    uint public tokenSalePercentage = 80;
    uint public foundersPercentage = 10;
    uint public discoveryPercentage = 2;
    uint public bountyPercentage = 2;
    uint public advisorsPercentage = 6;
    
    uint256 public creationTime;
    
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;



    mapping(address => uint256) tokenSupplyAllowance;
    mapping(address => uint256) foundersSupplyAllowance;
    mapping(address => uint256) discoverySupplyAllowance;
    mapping(address => uint256) bountySupplyAllowance;
    mapping(address => uint256) advisorsSupplyAllowance;

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    modifier ownable() {
        require(contractOwner == msg.sender);
        _;
    }

    modifier dayLimit(){
        require(compareDates() >= endDays);
        _;
    }
    
    constructor()  {
        name = "ADXLike";
        symbol = "ADX";
        //decimals = 18;
        _totalSupply = 100000000;
        creationTime = block.timestamp;
        contractOwner = msg.sender;

       //balances[msg.sender] = _totalSupply;
    }
    
    function getCurrentTime() public view returns (uint256){ return block.timestamp; }
    
    function buyADX() public payable returns(bool){
        require(msg.value >= 10**18);
        require(compareDates() < endDays);
        require(currentEth <= hardcapEth);
        
        currentEth = currentEth.add(msg.value.div(10 ** 18));
        uint256 tokens = getBonusesByDay(convertEthToAdx(msg.value));
        
        transferFromContract(msg.sender, tokens);
        //return true;
    }
    
    function transferFromContract(address _to, uint256 amountTokens) private returns (bool){
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

    function allowance(address tokenOwner, address spender) public /*constant*/view returns (uint remaining){
        return allowed[tokenOwner][spender];
    }
    
    function transfer(address receiver, uint amountTokens) public dayLimit returns (bool success) {
        require(amountTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].subtract(amountTokens);
        balances[receiver] = balances[receiver].add(amountTokens);
        emit Transfer(msg.sender, receiver, amountTokens);
        return true;
        
    }
    
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    
    function transferFrom(address owner, address receiver, uint tokens) public dayLimit returns (bool) {
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
    
    function convertEthToAdx(uint256 amount) private pure returns(uint256){
        return amount.div(10 ** 18).mul(900);
    }

    function convertAdxToEth(uint256 amount) private pure returns(uint256){
        return amount.mul(900);
    }
    
    function addTokenSupplyAllowance(address _newAddress, uint256 _amount) public returns(bool) {
        tokenSupplyAllowance[_newAddress] = _amount;
        return true;
    }
    
    function addFoundersSupplyAllowance(address _newAddress, uint256 _amount) public ownable returns(bool) {
        foundersSupplyAllowance[_newAddress] = _amount;
        return true;
    }
    
    function addBountySupplyAllowance(address _newAddress, uint256 _amount) public ownable returns(bool) {
        bountySupplyAllowance[_newAddress] = _amount;
        return true;
    }
    function addDiscoverySupplyAllowance(address _newAddress, uint256 _amount) public ownable returns(bool) {
        discoverySupplyAllowance[_newAddress] = _amount;
        return true;
    }
    
    function addAdvisorsSupplyAllowance(address _newAddress, uint256 _amount) public ownable returns(bool) {
        advisorsSupplyAllowance[_newAddress] = _amount;
        return true;
    }

    
}

// library SafeMath{
//     function subtract(uint a, uint b) internal pure returns (uint) {
//       assert(b <= a);
//       return a - b;
//     }
    
//     function add(uint a, uint b) internal pure returns (uint) {
//       uint c = a + b;
//       assert(c >= a);
//       return c;
//     }
    
//     function mul(uint a, uint b) public pure returns (uint) {
//         uint c = a * b; 
//         assert(a == 0 || c / a == b);
//         return c;
//     } 
//     function div(uint a, uint b) public pure returns (uint) {
//         assert(b > 0);
//         uint c = a / b;
//         return c;

//     }
    
//}


