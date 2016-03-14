import "owned";

contract Founders {
	
	address owner;
	uint interval = 43800; //payment interval a months worth of blocks
	uint divisor = 1000; //pays out 10%
	uint lastPayed;
	uint pay;
	
	struct Founder{
		address owner;
		vote voteKill;
	}
	
	mapping(bytes32 => Founder) founders;
		
	function Founders(){
		//set the addresses for the founders
		owner = msg.sender;
		founders["chris"].owner = 0x5f39e77fa3413c067c67f42e59abd31bf77fa6b8;
		founders["dan"].owner = 0x39598031bffa85956617b8581daeed2c1750f49c;	
		founders["james"].owner = 0x2d5e5eb2e8903de7acd530ffce71e6677c96ec6e;
		
		//prime the lastPayed variable
		
		lastPayed = block.number;
	}
	
	modifier onlyrecordowner(bytes32 _name) { if (founders[_name].owner == msg.sender) _ }
	
	function payFounders(){
		if((block.number - lastPayed ) >= interval && this.balance > 0){
			//calculate pay per person and any missed pay
			//multiplier = (block.number - lastPayed)/interval;
			//pay = ((this.balance/divisor) * multiplier)/3;
			
			//calculate pay for 1 period and dont include missed pays
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
	
	function voteKill(bytes32 _name, bool vote) onlyrecordowner(_name){
		founders[_name].voteKill = vote;
	}
	
	function kill(bytes32 _name) onlyrecordowner(_name){
		if(founders["chris"].vote == true && founders["dan"].vote == true && founders["james"].vote == true){
			suicide(owner);
		}
	}
	
	function acct(bytes32 _name) constant returns(address){ return founders[_name].owner;}
	function lastPayAmount() constant returns (uint){ return pay; }
	function nextPayAmount() constant returns (uint){ return (this.balance/divisor)/3; }
	function lastPayedBlock() constant returns (uint){return lastPayed;}
	function nextPayedBlock() constant returns (uint){return lastPayed+interval;}
	
}