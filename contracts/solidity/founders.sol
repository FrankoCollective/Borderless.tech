import "owned"

contract Founders{
	
	address owner;
	int interval = 43800; //payment interval a months worth of blocks
	uint lastPayed; //block number of last payed
	uint divisor = 100; //gives us 1%
	uint pay;
	uint multiplier;
	
	struct Founder{
		address owner;
	}
	
	mapping(bytes32 => Founder) founders;
		
	function Founders(){
		//set the addresses for the founders
		owner = msg.sender;
		founders["chris"].owner = "0x5f39e77fa3413c067c67f42e59abd31bf77fa6b8";
		founders["dan"].owner = "0x123";	
		founders["james"].owner = "0x456";
		
		//prime the lastPayed variable
		
		lastPayed = block.number;
	}
	
	modifier onlyrecordowner(bytes32 _name) { if (founders[_name].owner == msg.sender) _ }
	
	function pay(){
		if((block.number - lastPayed ) >= interval && this.balance > 0){
			//calculate pay per person and any missed pay
			//multiplier = (block.number - lastPayed)/interval;
			//pay = ((this.balance/divisor) * multiplier)/3;
			
			//calculate pay for 1 period and dont include missed pays
			multiplier = (block.number - lastPayed)/interval;
			pay = (this.balance/divisor)/3;
			
			//send the coin
			founders["chris"].owner.send(pay);
			founders["dan"].owner.send(pay);
			founders["james"].owner.send(pay);
			
			//update lastPayed
			lastPayed = block.number;
		}
	}
	
	function transfer(bytes32 _name, address _newOwner) onlyrecordowner(_name) {
		founders[_name].owner = _newOwner;
	}
	
	//TODO: make the kill switch take a vote from all 3 founders
	function kill(){
		if(owner == msg.sender){
			selfdestruct(msg.sender);
		}
	}
	
	function acct(address _name) constant returns(bytes32){ return founders[_name].owner;}
	function lastPayAmount() constant returns (uint){ return pay; }
	function nextPayAmount() constant returns (uint){ return (this.balance/divisor)/3; }
	function lastPayed() constant returns (uint){return lastPayed;}
	function nextPayed() constant returns (uint){return lastPayed+interval;}
	
}