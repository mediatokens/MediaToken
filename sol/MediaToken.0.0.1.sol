pragma solidity ^0.5.0; 

contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes 
memory _extraData) public; }

contract TypedMedia { 
   enum MediaType {NONE,IMAGE,VIDEO,AUDIO,BINARY,PDF,TEXT,URL}
    
}

contract Owned {
    address public owner;
    address public newOwner;
    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) revert();
        _;
    }

    function transferOwnership(address _newOwner) onlyOwner public {
        newOwner = _newOwner;
    }
 
    function acceptOwnership() public {
        if (msg.sender == newOwner) {
           emit OwnershipTransferred(owner, newOwner);
            owner = newOwner;
        }
    }
 }

contract AccessList { 
   mapping (address => bool) public isMember; 
}

contract MediaToken is TypedMedia {
    string public standard = 'Token 0.1'; //ERC-20 standard 
    string public name;
    string public symbol;
    string public description;
    string public tags; 
    
    uint8 public decimals;
    uint256 public totalSupply;

    address public mint; 
    address public owner; 
    
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    /* NEW - mapping of attachment data and count of attachments */ 
    mapping (uint256 => string) public metadata; 
    mapping (uint256 => MediaType) public metadata_type; 
    uint256 public attachmentCount; 
    
    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(
        uint256 _initialAmount, 
        address recv,
        string memory tokenName,
        string memory tokenSymbol,
        string memory tokenDescription,
        string memory tokenTags,
        uint256 mType,
        string memory ipfsHash
        ) public {
        balanceOf[recv] = _initialAmount;              // Give the creator all initial tokens
        totalSupply = _initialAmount;                        // Lock issuance to one token
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;   // Set the symbol for display purposes (first three as name or three char combo)
        description = tokenDescription; //Description in gallery
        tags = tokenTags; 
        //ipfs_hash = ipfsHash;
        decimals = 0;                            // Amount of decimals for display purposes
        //mediaType = MediaType(mType);
        mint = msg.sender; 
        owner = recv; 
       
        
        metadata[0] = ipfsHash; 
        metadata_type[0] = MediaType(mType); 
        attachmentCount++; 
        emit Transfer(mint, recv, _initialAmount);
        
    }
    
    /* Send coins */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        
        require(_to != address(0));
        require(_value != 0 && _value <= balanceOf[msg.sender]);
        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
        
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        
        emit Transfer(msg.sender, _to, _value);
	    return true;
    }
    
    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    /* Approve and then comunicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }        

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
       
        balanceOf[_from] -= _value;                          // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function setDescription(string memory desc) public { 
         require(owner == msg.sender); 
         description = desc;
    }
    
    /* functions for modifying the attachments */ 
    function addAttachment(string memory hash, MediaType aType) public  {
        require(owner == msg.sender);
        metadata[attachmentCount] = hash;
        metadata_type[attachmentCount] = aType; 
        attachmentCount++; 
        
    }
    
    /* This unnamed function is called whenever someone tries to send ether to it */
    function () external {
        revert();     // Prevents accidental sending of ether
    }
}

contract TokenFactory is TypedMedia, Owned { 
    address[] public Tokens;
    uint256 public TokenCount;
    
    event TokenCreated(address token, string name,string tags);
   
   function createToken(uint256 _qty, string memory _name, string memory _symbol, string memory _desc,string memory _tags,string memory _ipfshash, 
                        uint256 _type,address _recv ) public returns (address) {
                            
        require(uint(MediaType.URL) >= _type);
         
        
        MediaToken newToken = (new MediaToken(_qty,_recv ,_name,_symbol,_desc,_tags,_type,_ipfshash));
        Tokens.push(address(newToken));
        TokenCount++;
        
        emit TokenCreated(address(newToken),_name,_tags); //Raise Event to signify new token creation
        
        return address(newToken);
    }
    
    
    function() external payable {
        revert();     // Prevents accidental sending of ether
    }
}
