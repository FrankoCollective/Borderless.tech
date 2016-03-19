//le token

import "owned";


contract Token {


	event sent(address indexed _from, address indexed _to, address _amount);
	address public owner;

	

	mapping(address=>uint) accounts;

	

	function Token(){

		owner = msg.sender;

		accounts[msg.sender] = 100000000000000000000000000000;

	}

	

	function send(address _to, uint _amount) returns ( bool r){

		if(accounts[msg.sender] >= _amount){

			accounts[msg.sender]-=_amount;
			accounts[msg.sender]+=_amount;
			sent(msg.sender, _to, _amount);
			
		return true;

		}

	}
	
	function kill(){
	    if(owner == msg.sender){suicide(owner);}
	}

}

  