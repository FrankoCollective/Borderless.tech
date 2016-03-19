// The Borderless Reserve
// This contract stores the balances for multiple assets from other cryptocurrencies to gold, silver, stocks, bonds.
// TODO: Separate data storage from logic
// TODO: make sure every amount is converted into wie
import "owned";

contract BorderlessReserve {

	//events
		event eSend(address indexed _to, address indexed _from, bytes32 indexed _asset, uint _amt);
		event eRedeem(uint indexed _amount, bytes32 indexed _asset, bytes32 indexed _redeemer);
		event eMint(uint _amount, bytes32 indexed _asset, bytes32 indexed _txid, address indexed _minter);
		event eAdmin(address indexed _admin, bytes32 indexed _action);
	

	address public owner;
	
	struct Asset{
	    bytes32 name;
		bool exists;
		uint totalShares;
		uint fee;
		uint mIndex;
		uint rIndex;
		mapping(uint=>MintHistoryRecord) MintHistory;
		mapping(uint=>RedeemHistoryRecord) RedeemHistory;
	}
	
	//map name of asset to asset struct
	mapping(bytes32=>Asset) public assets;
	
	struct MintHistoryRecord{
	    uint timestamp;
	    uint amount;
	    bytes32 txid;
	    address minter;
	}
	
	struct RedeemHistoryRecord{
	    uint timestamp;
	    uint amount;
	    bytes32 txid;
	    bytes32 redeemer;
	}

	struct Account{
		bool isAdmin;
		bool isOwner;
		mapping(bytes32=>uint) balances;
	}
	
	//map address to account details
	mapping(address=>Account) public accounts;

	function BorderlessReserve(){
		owner = msg.sender;
		accounts[owner].isAdmin = true;
		accounts[owner].isOwner = true;
		
		addNewAsset('frk', 'franko', 100);
		addNewAsset('btc', 'bitcoin', 100);
		addNewAsset('eth', 'ethereum', 100);
		addNewAsset('ltc', 'litecoin', 100);
		addNewAsset('doge', 'dogecoin', 100);
	}

	modifier isAdmin() { if (accounts[msg.sender].isAdmin == true) _ }
	modifier isOwner() { if (accounts[msg.sender].isOwner == true) _ }
    
    function getBalances(address _acct, bytes32 _asset) returns (uint _bal){
        return accounts[_acct].balances[_asset];
    }
    
	function send(address _to, uint _amount, bytes32 _asset){
	    
	    if(accounts[msg.sender].balances[_asset] >= _amount){
	        accounts[msg.sender].balances[_asset]-= _amount;
	        accounts[_to].balances[_asset]+= _amount;
			eSend(_to, msg.sender, _asset, _amount);
	    }
	    
	}
	
	function redeem(uint _amount, bytes32 _asset, bytes32 _redeemer){
	    if(assets[_asset].exists == true && accounts[msg.sender].balances[_asset] >= _amount){
	        //increase the total mint
			uint amount = _amount-(_amount/100);
			assets[_asset].totalShares-=amount;
			
			//give assets - fee to minter
			accounts[msg.sender].balances[_asset]-=amount;
			
			//add history
			uint rIndex = assets[_asset].rIndex+1;
			assets[_asset].RedeemHistory[rIndex].timestamp = block.timestamp;
			assets[_asset].RedeemHistory[rIndex].amount = amount;
			assets[_asset].RedeemHistory[rIndex].redeemer = _redeemer;
			eRedeem(_amount, _asset, _redeemer);
	    }
	}
	
	//admin stuff
	function mint(uint _amount, bytes32 _asset, bytes32 _txid, address _minter) isAdmin() {
		//check if asset is real
		if(assets[_asset].exists == true){
			//increase the total mint
			uint amount = _amount-(_amount/100);
			assets[_asset].totalShares+=amount;
			
			//give assets - fee to minter
			accounts[_minter].balances[_asset]+=amount;
			
			//add history
			uint mIndex = assets[_asset].mIndex+1;
			assets[_asset].MintHistory[mIndex].timestamp = block.timestamp;
			assets[_asset].MintHistory[mIndex].amount = amount;
			assets[_asset].MintHistory[mIndex].txid = _txid;
			assets[_asset].MintHistory[mIndex].minter = _minter;
			
			eMint(_amount, _asset, _txid, _minter);
		}
	}
	
	function addNewAsset(bytes32 _asset, bytes32 _name, uint _fee) isAdmin() {
	       assets[_asset].exists = true;
	       assets[_asset].totalShares = 0;
	       assets[_asset].name = _name;
	       assets[_asset].fee = _fee;
	       assets[_asset].rIndex = 0;
		   
		   eAdmin(msg.sender, 'NewAsset');
	}
	
	function setAssetFee(bytes32 _asset, uint _fee) isAdmin() {
	       assets[_asset].fee = _fee;
		   eAdmin(msg.sender, 'SetAssetFee');
	}
	
    function setAssetName(bytes32 _asset, bytes32 _name) isAdmin() {
	       assets[_asset].name = _name;
		   eAdmin(msg.sender, 'SetAssetName');
	}
	
	function setAdmin(address _account, bool _action) isOwner() {
		accounts[_account].isAdmin = _action;
		eAdmin(msg.sender, 'SetAdmin');
	}
	
	function setOwner(address _account, bool _action) isOwner() {
		if(_account != owner){
		accounts[_account].isOwner = _action;
		eAdmin(msg.sender, 'SetOwner');
		}		
	}

	function empty() isAdmin() {
         uint256 balance = this.balance;
         owner.send(balance);
		 eAdmin(msg.sender, 'Emptied');
    }
	
}                          