//Cross chain TX's from Expanse to Ethereum and back.

import "owned";

contract CCTX {

	address owner;
	uint fee;
	
	struct User{
		uint expBal;
		uint expEthBal;
	}
	
	mapping(address => User) public users;
	
	function CCTX(){
		owner = msg.sender;
	}
	
	function deposit(){
	}
	
	function withdraw(uint _amount){
	}
	
	function public getBalances(address _acct){
	}

}