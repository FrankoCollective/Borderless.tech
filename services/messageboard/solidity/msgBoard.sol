//message board

import "owned";

contract MessageBoard{
	
	//events
	event eNewPost(
		address indexed _owner,
		bytes32 indexed _text,
		bytes32 indexed _tag
	);
	
	event eDeletePost(
		address indexed _owner,
		uint indexed _pid
	);
	
	event eEmpty(address _to, uint _amount);
	
	addresss cOwner = "owner";
	uint public pCount;
		
	struct Post{
		bytes32 text;
		bytes32 tag;
		address owner;
		bool exist;
	}
	
	mapping( uint => Post ) public posts;
	
	function MessageBoard(){
	 cOwner = msg.sender;
	}
	
	modifier onlyOwner(uint _pid) { if (posts[_pid].owner == msg.sender) _ }
	
	function newPost(bytes32 _text, bytes32 _tag){
		pCount++;
		
		posts[pCount].text = _text;
		posts[pCount].tag = _tag;
		posts[pCount].owner = msg.sender;
		posts[pCount].exist = true;
		
		eNewPost(msg.sender, _text, _tag);
	}
	
	function deletePost(uint _pid) onlyOwner {
		if(posts[_pid].exist == true){
			posts[_pid].text = '';
			posts[_pid].tag = '';
			posts[_pid].owner = msg.sender;
			posts[_pid].exist = false;
			
			eDeletePost(msg.sender, _pid);
		}
	}
	
	function empty(){
     uint256 balance = this.balance;
     owner.send(balance);
	 eEmpty(owner, balance);
    }
	
	function kill(){
		if(msg.sender == owner){
			suicide(owner);
		}
	}
	
}