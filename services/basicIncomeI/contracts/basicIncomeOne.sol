// Basic Income I
// Description: Every interval an identity can mint and withdraw 1000 lucrii.

import "owned";

contract BasicIncomeLucrii {

	address public owner;
	uint public index = 0;
	uint public totalSupply = 0;
	uint public subsidy = 1000000000000000000000; // 1000 lucrii
	uint interval = 43800;
	
	event Loggit(address indexed userAddress, bytes32 indexed complaint);
	event Sent(address from, address to, uint amount);

	struct Recpient{
		address acct;
		uint balance;
		bool validated;
		mapping(bytes32 => Role) roles;
		uint totalMinted;
		uint totalSent;
		uint totalRecieved;
		uint lastMint;
	}
	
	struct rIndex{
		bool exist;
		uint index;
	}
	
	struct Role{
		bool exist;
		// Admin - admins can create new officers and validate repients
		// Officer - can validate recpients
	}
	
	mapping(address => rIndex) public byI;
	mapping(uint => Recpient) public byR;
	

	function BasicIncomeLucrii(){
		owner = msg.sender;
		index++;
		byI[msg.sender].exist = true;
		byI[msg.sender].index = index;
		
		byR[index].acct = msg.sender;
		byR[index].validated = true;
		byR[index].roles["admin"].exist = true;
		
	}
	
	modifier onlyadmin() { if (byR[byI[msg.sender].index].roles["admin"].exist == true) _ }
	modifier onlyofficer() { if (byR[byI[msg.sender].index].roles["admin"].exist == true || byR[byI[msg.sender].index].roles["officer"].exist == true) _ }
	modifier validated() { if (byR[byI[msg.sender].index].validated == true) _ }
	
	function register(){
		if(byI[msg.sender].exist == false){
			index++;
			byI[msg.sender].exist = true;
			byI[msg.sender].index = index;
			loggit("registered");
		}
	}
	
	function validate(address acct, bool onoff) onlyofficer() {
		if(byI[acct].exist == true){
			byR[byI[acct].index].validated = onoff;
			loggit("validated");
		}
	}
	
	function updateRole(address acct, bytes32 role, bool onoff) onlyadmin(){
		if(byI[acct].exist == true){
			byR[byI[acct].index].roles[role].exist = onoff;
			loggit("role updated");
		}
	}
	
	function mint() validated() {
		if((block.number - byR[byI[msg.sender].index].lastMint ) >= interval){
			//mint new coins
			
			byR[byI[msg.sender].index].balance += subsidy;
			byR[byI[msg.sender].index].totalMinted += subsidy;
			
			//update lastMint to this block
			
			byR[byI[msg.sender].index].lastMint = block.number;
			totalSupply += subsidy;
			
			//logs
			loggit("mint success");
		}
	}
	
	function send(address receiver, uint amount) {
        if (byR[byI[msg.sender].index].balance < amount) return;
        byR[byI[msg.sender].index].balance -= amount;
        byR[byI[receiver].index].balance += amount;
		//update totals
		byR[byI[msg.sender].index].totalSent += amount;
        byR[byI[receiver].index].totalRecieved += amount;
		
        Sent(msg.sender, receiver, amount);
    }
	
	function loggit(bytes32 complaint){
		Loggit(msg.sender, complaint);
	}

	function empty(){
     uint256 balance = this.balance;
     owner.send(balance);
    }
}              