// Directory: This contract is a directory for other contracts
// Chrstopher Franko 1-23-2016

import "owned";

contract Directory {
	
	address owner;
	
	struct C{
		address acct;
		address owner;
		string abi;
		bool exist;
	}
	
	mapping(bytes32 => C) public byN;
		
	function Directory(){
		owner = msg.sender;
	}
	
	modifier onlyowner(bytes32 _name) { if (byN[_name].owner == msg.sender) _ }
	
	function add(bytes32 name, string abi, address acct){
		if(byN[name].exist == false){
			byN[name].abi = abi;
			byN[name].acct = acct;
			byN[name].owner = msg.sender;
		}	
	}
	
	function editAbi(bytes32 _name, string _abi ) onlyowner(_name) {
		if(byN[_name].exist == true){
			byN[_name].abi = _abi;
		}
	}
	
	function editAcct(bytes32 _name, address _acct ) onlyowner(_name) {
		if(byN[_name].exist == true){
			byN[_name].acct = _acct;
		}
	}
	
	function transfer(bytes32 _name, address _owner ) onlyowner(_name) {
		if(byN[_name].exist == true){
			byN[_name].owner = _owner;
		}
	}
	
	function empty(){
		uint256 balance = this.balance;
		owner.send(balance);
    }

	function kill(){
		if(owner == msg.sender){
			suicide(msg.sender);
		}
	}
}      