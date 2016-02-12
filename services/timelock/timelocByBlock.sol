//timelock contract

import "owned";

contract Timelock{

	address public owner;
	uint public unlockBlock;
	
	function Timelock(int _numOfBlocks){
		owner = msg.sender;
		unlockBlock = _numOfBlocks + block.number;
	}
	
	function kill(){
		if(msg.sender == owner  && block.number > unlockBlock){
			suicide(owner);
		}
	}

}