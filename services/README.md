var cAddress = "0x12345";

var cAbi = "";

var eth = web3.eth;
var contract = eth.contract(cAbi).at(cAddress);
