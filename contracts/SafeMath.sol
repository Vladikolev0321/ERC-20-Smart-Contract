pragma solidity ^0.8.5;

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