//le token

import "owned";


contract Token {

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

		return true;

		}

	}
	
	function kill(){
	    if(owner == msg.sender){suicide(owner);}
	}

}

  