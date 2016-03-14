//timelock contract

import "owned";

contract Timelock{

	address public owner;
	uint public unlockBlock;
	uint day = 1440;
	
	function Timelock(int _numDays){
		owner = msg.sender;
		unlockBlock = (day*_numDays) + block.number;
	}
	
	function kill(){
		if(msg.sender == owner  && block.number > unlockBlock){
			suicide(owner);
		}
	}

}