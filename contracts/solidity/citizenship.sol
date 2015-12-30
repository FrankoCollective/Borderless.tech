import "owned";

contract Citizenship{
    
    address owner;
    event Loggit(address indexed userAddress, bytes32 indexed complaint);
    
    struct Citizen{
        
        address account;
        bytes32 fname;
        bytes32 lname;
        string picture;
        bytes32 eye_color;
        uint height;
        bool sex;
        
    }
    
    mapping(address => Citizen) citizens;

    //Constructor
    function Citizenship(){
        //set owner
        owner = msg.sender;
    }
    
    function register(bytes32 fname, bytes32 lname, string picture, bytes32 eye_color, uint height, bool sex){
        if(citizens[msg.sender].account == 0){
            //if the user doesnt exist save them
			citizens[msg.sender].account	= msg.sender;
            citizens[msg.sender].fname      = fname;
            citizens[msg.sender].lname      = lname;
            citizens[msg.sender].picture    = picture;
            citizens[msg.sender].eye_color  = eye_color;
            citizens[msg.sender].height     = height;
            citizens[msg.sender].sex        = sex;
            loggit("registered");
        }else{
            //else update them
            loggit("already registered");
        }
    }
    
    
    function setFname(bytes32 fname){
        citizens[msg.sender].fname = fname;
        loggit("updated first name");
    }
    
    function setLname(bytes32 lname){
        citizens[msg.sender].lname = lname;
        loggit("updated last name");
    }
    
    function setPicture(string picture){
        citizens[msg.sender].picture = picture;
        loggit("updated picture");
    }
    
    function setEyeColor(bytes32 eye_color){
        citizens[msg.sender].eye_color = eye_color;
        loggit("updated eye color");
    }
    
    function setHeight(uint height){
        citizens[msg.sender].height = height;
        loggit("updated height");
    }
    
    function setSex(bool sex){
        citizens[msg.sender].sex = sex;
        loggit("updated sex");
    }
    
    function loggit(bytes32 complaint){
		Loggit(msg.sender, complaint);
	}
    
    
    function fname(address _account) constant returns(bytes32){ return citizens[_account].fname;}
    function lname(address _account) constant returns(bytes32){ return citizens[_account].lname;}
    function picture(address _account) constant returns(string){ return citizens[_account].picture;}
    function eye_color(address _account) constant returns(bytes32){ return citizens[_account].eye_color;}
    function height(address _account) constant returns(uint){ return citizens[_account].height;}
    //returns 0 for female, 1 for male. appropriately.
    function sex(address _account) constant returns(bool){ return citizens[_account].sex;}
 
}