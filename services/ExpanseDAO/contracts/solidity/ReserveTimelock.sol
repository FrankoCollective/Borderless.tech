//timelock contract

import "owned";

contract ReserveTimelock{

	address public owner;
	uint public unlockBlock;
	
	function ReserveTimelock(){
		owner = 0xbb94f0ceb32257275b2a7a9c094c13e469b4563e;
		unlockBlock = block.number+129600;
	}
	
	function kill(){
		if(msg.sender == owner  && block.number > unlockBlock){
			suicide(owner);
		}
	}

}