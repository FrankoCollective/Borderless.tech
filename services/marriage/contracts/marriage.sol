// Marriage contract v0.0.1
//TODO: Add Fee or marriage bond
import "owned";

contract Marriage {
    address owner;
    uint public index = 0;
    event Loggit(address indexed userAddress, bytes32 indexed complaint);
    
    struct Record{
        address p1;
        bool    iDoP1;
        bool    divorceP1;
        
        address p2;
        bool    iDoP2;
        bool    divorceP2;
        
        uint timestamp;
        
        int    stat;
    }
    
    struct rIndex{
        bool exist;
        uint index;
    }
    
    mapping(address => rIndex) m_mIds;
    mapping(uint => Record)  m_records; 
    
    function Marriage(){
        owner = msg.sender;
    }
	
	function empty(){
     uint256 balance = address(this).balance;
     address(owner).send(balance);
    }
    
    function register(address p2){
        
        if( m_mIds[msg.sender].exist != true &&  m_mIds[p2].exist != true){
        
        //create indexes    
        m_mIds[msg.sender].index = index;
        m_mIds[p2].index = index;
        
        m_mIds[msg.sender].exist = true;
        m_mIds[p2].exist = true;
        
        //set p1
        m_records[index].p1 = msg.sender;
        //we could assume this to be true but in the spirit of marriage tradition
        //we are going to say false so they can both say "i do"
        m_records[index].iDoP1 = false; 
        m_records[index].divorceP1 = false;
        
        //set p2
        m_records[index].p2 = p2;
        m_records[index].iDoP2 = false;
        m_records[index].divorceP2 = false;
        
        //set pending
        m_records[index].stat = 1; 
        
        m_records[index].timestamp = block.timestamp;
        
        index++;
        
        loggit("marriage registerd");
        }else{
            //log some error
            loggit("marriage registration error");
        }
    }
    
    function iDo(){
        
        //check who it is
        if(m_records[m_mIds[msg.sender].index].p1 == msg.sender){
            m_records[m_mIds[msg.sender].index].iDoP1 = true;
        }else if(m_records[m_mIds[msg.sender].index].p2 == msg.sender){
            m_records[m_mIds[msg.sender].index].iDoP2 = true;
        }else{
            //log error
            loggit("I do error");
        }
        
        //check and see what the status of the marriage is
        if(m_records[m_mIds[msg.sender].index].iDoP1 == true && m_records[m_mIds[msg.sender].index].iDoP2 == true){
            //marriage status now married
            m_records[m_mIds[msg.sender].index].stat = 2;
            m_records[m_mIds[msg.sender].index].timestamp = block.timestamp;
            loggit("marriage is complete");
        }

    }
    
    function iDont(){
        if(m_records[m_mIds[msg.sender].index].p1 == msg.sender || m_records[m_mIds[msg.sender].index].p2 == msg.sender){
            if(m_records[m_mIds[msg.sender].index].stat < 2){
                
                address idontp1 = m_records[m_mIds[msg.sender].index].p1; 
                address idontp2 = m_records[m_mIds[msg.sender].index].p2;
                uint idontindex = m_mIds[msg.sender].index;
                
                delete m_records[idontindex];
                delete m_mIds[idontp1];
                delete m_mIds[idontp2];
                
                loggit("everything has been deleted");
            }else{
                //cant i dont you have to divorce now, and divorce takes both parties
                loggit("take it to divorce court");
            }
        }
    }
    
    function divorce(){
        //check who it is
        if(m_records[m_mIds[msg.sender].index].p1 == msg.sender){
            m_records[m_mIds[msg.sender].index].divorceP1 = true;
        }else if(m_records[m_mIds[msg.sender].index].p2 == msg.sender){
            m_records[m_mIds[msg.sender].index].divorceP2 = true;
        }else{
            //log error
            loggit("divorce error");
        }
        
        if(m_records[m_mIds[msg.sender].index].divorceP1 == true && m_records[m_mIds[msg.sender].index].divorceP2 == true){
            //marriage status now married
            m_records[m_mIds[msg.sender].index].stat = 0;
            loggit("divorce final go say idont");
        }
    }
    
    function loggit(bytes32 complaint){
		Loggit(msg.sender, complaint);
	}
	
	function getSpouse(address _a) constant returns(address){
	    //check who it is
        if(m_mIds[_a].exist == true){
            
            if(m_records[m_mIds[_a].index].p1 == _a){
                return m_records[m_mIds[_a].index].p2;
            }else if(m_records[m_mIds[_a].index].p2 == _a){
                return m_records[m_mIds[_a].index].p1;
            }
        }
	}
	
	function getStatus(address _a) constant returns(int){
	    //check who it is
        if(m_mIds[_a].exist == true){
          return m_records[m_mIds[_a].index].stat;
        }
	}
	
	function getTime(address _a) constant returns(uint){
	    //check who it is
        if(m_mIds[_a].exist == true){
          return m_records[m_mIds[_a].index].timestamp;
        }
	}
	
	function kill(){
		if(owner == msg.sender){
			suicide(msg.sender);
		}
	}

}