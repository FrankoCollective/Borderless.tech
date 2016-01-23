import "owned";

contract Citizenship {
    
    address owner;
	uint user_id = 0;

    struct Citizen{
        bytes32 fname;
        bytes32 lname;
        string picture;
        bytes32 eye_color;
        uint height;
        bytes32 sex;
		uint birthday;
		address acct;
		bool exist;
    }
	
	struct cIndex{
		bool exist;
		uint index;
	}
	
	mapping(address => cIndex) ids;
    mapping(uint => Citizen) citizens;

    function Citizenship(){
        //set owner
        owner = msg.sender;
    }
	
    function setUser(bytes32 fname, bytes32 lname, string picture, bytes32 eye_color, uint height, bytes32 sex, uint birthday){       
            if(ids[msg.sender].exist == false){
				user_id++;
				
				ids[msg.sender].index = user_id;
				ids[msg.sender].exist = true;
				citizens[user_id].exist = true;
				citizens[user_id].acct = msg.sender;
			}

			setFname(fname);
            setLname(lname);
            setPicture(picture);
            setEyeColor(eye_color);
            setHeight(height);
            setSex(sex);
			setBirthday(birthday);			
    }
    
    
    function setFname(bytes32 fname){
        citizens[ids[msg.sender].index].fname = fname;
    }
    
    function setLname(bytes32 lname){
        citizens[ids[msg.sender].index].lname = lname;
    }
    
    function setPicture(string picture){
        citizens[ids[msg.sender].index].picture = picture;
    }
    
    function setEyeColor(bytes32 eye_color){
        citizens[ids[msg.sender].index].eye_color = eye_color;
    }
    
    function setHeight(uint height){
        citizens[ids[msg.sender].index].height = height;
    }
    
    function setSex(bytes32 sex){
        citizens[ids[msg.sender].index].sex = sex;
    }
	
	function setBirthday(uint birthday){
        citizens[ids[msg.sender].index].birthday = birthday;   
    }
    
	function empty(){
     uint256 balance = this.balance;
     owner.send(balance);
    }
     
    function fname(address _account) constant returns(bytes32){ return citizens[ids[_account].index].fname;}
    function lname(address _account) constant returns(bytes32){ return citizens[ids[_account].index].lname;}
    function picture(address _account) constant returns(string){ return citizens[ids[_account].index].picture;}
    function eye_color(address _account) constant returns(bytes32){ return citizens[ids[_account].index].eye_color;}
    function height(address _account) constant returns(uint){ return citizens[ids[_account].index].height;}
    function sex(address _account) constant returns(bytes32){ return citizens[ids[_account].index].sex;}
	function birthday(address _account) constant returns(uint){ return citizens[ids[_account].index].birthday;}
	
	function getUserById(uint index) constant returns(bytes32 fname, bytes32 lname, string picture, bytes32 eye_color, uint height, bytes32 sex, uint birthday, address acct){
			if(citizens[index].exist == true){
			fname = citizens[index].fname;
			lname = citizens[index].lname;
			picture = citizens[index].picture
			eye_color = citizens[index].eye_color;
			height = citizens[index].height;
			sex = citizens[index].sex;
			birthday = citizens[index].birthday;
			acct = citizens[index].acct;
			}else{
			return;
			}
	}
	
	function getUserByAcct(address _acct) constant returns(bytes32 fname, bytes32 lname, string picture, bytes32 eye_color, uint height, bytes32 sex, uint birthday, address acct){
			if(citizens[ids[_acct].index].exist == true){
			fname = citizens[ids[_acct].index].fname;
			lname = citizens[ids[_acct].index].lname;
			picture = citizens[ids[_acct].index].picture
			eye_color = citizens[ids[_acct].index].eye_color;
			height = citizens[ids[_acct].index].height;
			sex = citizens[ids[_acct].index].sex;
			birthday = citizens[ids[_acct].index].birthday;
			acct = citizens[ids[_acct].index].acct;
			}else{
			return;
			}
	}
}        