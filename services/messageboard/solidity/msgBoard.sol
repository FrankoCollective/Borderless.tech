//message board

import "owned";

contract MessageBoard{
	
	addresss cOwner = "owner";
	uint public pCount;
	
	struct Text{
	
	}
	
	struct Post{
		bytes32 text;
		bytes32 tag;
		address owner;
		bool exist;
	}
	
	mapping( uint => Text ) public posts;
	
	function MessageBoard(){
	 cOwner = msg.sender;
	}
	
	function newPost(bytes32 _text, bytes32 _tag){
		pCount++;
		
		posts[pCount].text = _text;
		posts[pCount].tag = _tag;
		posts[pCount].owner = msg.sender;
		posts[pCount].exist = true;
	}
	
	function deletePost(uint _pid){
		if(posts[_pid].exist == true && posts[_pid].owner == msg.sender){
			posts[_pid].text = '';
			posts[_pid].tag = '';
			posts[_pid].owner = msg.sender;
			posts[_pid].exist = false;
		}
	}
	
	function empty(){
     uint256 balance = this.balance;
     owner.send(balance);
    }
	
	function kill(){
		if(msg.sender == owner){
			suicide(owner);
		}
	}
	
}