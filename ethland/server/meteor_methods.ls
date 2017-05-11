
fs   = Npm.require \fs 
solc = Npm.require \solc

Web3 = Npm.require \web3
web3 = new Web3(new Web3.providers.HttpProvider(config.ETH_NODE));


Meteor.methods do

	'getLrCount':-> call_API_method getLrCount,(err,res)->
		console.log err
		if err => cb(err)
		else cb(null,res)
	


	'someSafeMath2': -> console.log EthLend.sol




@call_API_method = (func, cb)->
	getContractAbi \:LendingRequest, \./ethland/server/contracts/EthLend.sol, (err,ledgerAbi,ledgerBytecode)->
		contract = web3?eth?contract(ledgerAbi)?at(config.ETH_MAIN_ADDRESS)
		if err => return
		func(contract, cb)


@getLrCount =(contract, cb)-> contract?getLrCount cb


# IsTicketSold = (contract,ticket_address,cb)=> {
#      contract.isticketsold(ticket_address, (err,res)=>{
#           if(err) { return cb(err)}
#           return cb(null, res)
#      });
# };

# SellTicket = (contract,ticket_address,cb)=> {
#      var params   = { from: creator, gas: 2000000 };
#      contract.sellticket(ticket_address, params, (err,res)=>{
#           if(err) { return cb(err)}
#           return cb(null, res)
#      });
# };



@getContractAbi = (cName,filename,cb)-> fs.readFile filename, (err, res)->
	# assert.equal(err,null)
	if err => return cb(err)
	source = res.toString()
	# assert.notEqual(source.length,0)
	output   = solc.compile(source, 1)
	abi      = JSON.parse(output.contracts[cName].interface)
	bytecode = output.contracts[cName].bytecode
	cb(null,abi,bytecode)





