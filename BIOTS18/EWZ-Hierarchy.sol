contract Prosumer{
    
    address Owner = msg.sender;
    uint256 totalProduced;
    uint256 totalConsumed;
    int256 Total;
    mapping(address => int256) public balanceOf;  
    
    // function Prosumer(){
    //     balanceOf[this] = 100000;
    // }
    
    struct inEN{
        address owner;
        bytes32 sr;
        uint256 prod;
        uint timestamp;
    }
    
    struct outEN{
        address owner;
        bytes32 source;
        uint256 cons;
        uint timestamp;
    }
    
    inEN[] public produced;
    outEN[] public consumed;
    
    function producedEnergy (bytes32 appl, uint256 pr) public {
        inEN memory newInEvent = inEN(Owner,appl,pr,block.timestamp);
        totalProduced += pr;
        Total += int256(totalProduced);
        produced.push(newInEvent);
    }
    
    function consumedEnergy (bytes32 appl, uint256 cs) public {
        outEN memory newOutEvent = outEN(Owner,appl,cs,block.timestamp);
        totalConsumed += cs;
        Total -= int256(totalConsumed);
        consumed.push(newOutEvent);
    }
    
    function getTotalProduced() public view returns (uint256 TS){
        TS = totalProduced;
    }
    
    function getTotalConsumed() public view returns (uint256 TS){
        TS = totalConsumed;
    }
    
    function getTokens(address tokenMaster) public{
        Token token = Token(tokenMaster);
        token.createTokens(this,totalProduced);
        balanceOf[this] += int256(totalProduced);
    }
    
    function useTokens(address tokenMaster) public{
        Token token = Token(tokenMaster);
        token.burnTokens(this,totalConsumed);
        balanceOf[this] -= int256(totalConsumed);
    }
    
    function informKreisGM(address Kreisaddr){
        KreisGM KGM = KreisGM(Kreisaddr);
        KGM.addBalance(this,balanceOf[this]);
    }
    
}

contract KreisGM{
    mapping(address => int256) public balanceOf;  
    int256 totalKreisBalance public;
    
    function addBalance(address prosumer, int256 balance) public{
        balanceOf[prosumer] += balance;
        totalKreisBalance += balance;
    }
    
    function informEWZ(address ewzaddr) public{
        EWZ ewz = EWZ(ewzaddr);
        ewz.addBalance(this,totalKreisBalance);
    }
}

contract EWZ{
    mapping(address => int256) public balanceOf; 
    int256 totalEWZBalance public;
    
    function addBalance(address KGM, int256 balance) public{
        balanceOf[KGM] = balance;
        totalEWZBalance += balance;
    }
}

contract Token{
    mapping(address => int256) public balanceOf;                               // Most important feature of token address-balance pair
    
    address public owner;
    uint public ethOfContract;
    uint public tokenOfContract;
    address public addressofContract = this;

    function Token(address _owner) payable public{
        owner = _owner;
     }
    
    function createTokens (address prosumer, uint256 kwh) public{
        balanceOf[prosumer] += int256(kwh);
    }
    
    function burnTokens (address prosumer, uint256 kwh) public{
        balanceOf[prosumer] -= int256(kwh);
    }
    
    function transfer(address to, uint256 amount) public {                      
        balanceOf[msg.sender] -= int256(amount);
        balanceOf[to] += int256(amount);
        //ToDo
    }
    
    function transferfrom(address _from, address _to, uint256 amount) public{
    
        balanceOf[_from] -= int256(amount);
        balanceOf[_to] += int256(amount);
        //ToDo
    }
    
}
