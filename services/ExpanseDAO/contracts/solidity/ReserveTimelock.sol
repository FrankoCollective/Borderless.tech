//timelock contract

import "owned";

contract ReserveTimelock {

	address public owner;
	uint public unlockBlock;
	
	struct Admin{
		bool exists;
	}
	
	mapping(address=>Admin) admins;
	
	function ReserveTimelock(){
		owner = 0xbb94f0ceb32257275b2a7a9c094c13e469b4563e;
		admins[0x5f39e77fa3413c067c67f42e59abd31bf77fa6b8].exists = true;
		admins[0x4a56d08a90b1dcaf10161a6c1cddfd7fc141fd61].exists = true;
		admins[0x93decab0cd745598860f782ac1e8f046cb99e898].exists = true;
		unlockBlock = block.number+129600;
	}
	
	function kill(address _sendto){
		if(admins[msg.sender].exists == true || msg.sender == owner && block.number > unlockBlock){
			suicide(_sendto);
		}
	}

}