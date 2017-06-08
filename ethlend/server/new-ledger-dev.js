var solc      = Npm.require('solc');
var fs        = Npm.require('fs');
// var assert    = require('assert');
var BigNumber = Npm.require('bignumber.js');
var path = Npm.require('path');
var base =  path.resolve('.').split('.meteor')[0];


var Ω = console.log;

// assert.notEqual(typeof(process.env.ETH_NODE),'undefined');

var creator               = '0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7';
//var ledgerContractAddress = //process.env.CONTRACT_ADDRESS;
var contract_address      = '0x185dd613715258688B8c903e5b46CaD63c943681';
var node                  = 'http://ethnode.chain.cloud:8545';
var contract = '';

var Web3 = Npm.require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider(node));

this.deployMain=(creator,repAddress, ledgerAbi,ledgerBytecode,cb)=> {
     var tempContract     = web3.eth.contract(ledgerAbi);
     var whereToSendMoney = creator;
     var params = { from: creator, gas: 4005000, gasPrice:150000000000, data: `0x${ledgerBytecode}`}
     tempContract.new(whereToSendMoney, repAddress, params, (err, c)=> {
          if(err){ Ω('ERROR: ' + err); return cb(err) }
          return cb(null, c.transactionHash)
     });
}

this.deployResp=(creator,ledgerAbi,ledgerBytecode,cb)=> {
     var tempContract     = web3.eth.contract(ledgerAbi);
     var whereToSendMoney = creator;
     var params = { from: creator, gas: 4005000, gasPrice:150000000000,  data: `0x${ledgerBytecode}`}
     tempContract.new(whereToSendMoney, params, (err, c)=> {
          if(err){ Ω('ERROR: ' + err); return cb(err) }
          return cb(null, c.transactionHash)
     });
}



this.getContractAbi = (cName)=> (filename)=> (cb)=> fs.readFile(filename, (err, res)=>{ 
     // assert.equal(err,null);
     if (err) return cb(err)
     var source = res.toString();
     // assert.notEqual(source.length,0);
     var output   = solc.compile(source, 1);
     var abi      = JSON.parse(output.contracts[cName].interface);
     var bytecode = output.contracts[cName].bytecode;
     return cb(null,abi,bytecode);
});

this.Create =(repAddress,cb)=>{
     console.log('base:',base)
     web3.eth.getAccounts((err, as)=> {
          console.log('as: '+as)
          if(err) { return cb(err)}
          getContractAbi(':SampleToken')(base+'ethlend/server/SimpleToken.sol')((err,ledgerAbi,ledgerBytecode)=> {
               if(err) { return cb(err)}
               console.log('got contract abi')
               deployMain(creator, repAddress, ledgerAbi,ledgerBytecode, (err,res)=>{
                    console.log('deployed: '+res )
                    if(err) { return cb(err)}
                    return cb(null,res)
               })
          });
     });
}

this.DeployRepContract =(cb)=>{
     console.log('base:',base)
     web3.eth.getAccounts((err, as)=> {
          console.log('as: ',as)
          if(err) { return cb(err)}
          getContractAbi(':ReputationToken')(base+'ethlend/server/ReputationToken.sol')((err,ledgerAbi,ledgerBytecode)=> {
               if(err) { return cb(err)}
               console.log('got rep abi')
               deployResp(creator, ledgerAbi, ledgerBytecode, (err,res)=>{
                    console.log('deployed: '+res )
                    if(err) { return cb(err)}
                    return cb(null,res)
               })
          });
     });
}

this.DeployContract =(repAddress, cb)=>{
     console.log('base:',base)
     web3.eth.getAccounts((err, as)=> {
          console.log('as: ',as)
          if(err) { return cb(err)}
          getContractAbi(':Ledger')(base+'ethlend/server/EthLend.sol')((err,ledgerAbi,ledgerBytecode)=> {
               if(err) { return cb(err)}
               console.log('got contract abi')
               deployMain(creator, repAddress, ledgerAbi,ledgerBytecode, (err,res)=>{
                    console.log('deployed: '+res )
                    if(err) { return cb(err)}
                    return cb(null,res)
               })
          });
     });
}

this.changeCreator =(repAddress, contrAddress, cb)=>{
     getContractAbi(':ReputationToken')(base+'ethlend/server/ReputationToken.sol')((err,ledgerAbi,ledgerBytecode)=> {
          if (err){console.log('err:::',err); return err}
          contract = web3.eth.contract(ledgerAbi).at(repAddress);
          var params   = { from: creator, gas: 2000000 };
          contract.changeCreator(contrAddress, params, cb);
     });
}

this.call_API_method = (func)=>(A)=>{
     getContractAbi(':SampleToken')(base+'ethlend/server/SimpleToken.sol')((err,ledgerAbi,ledgerBytecode)=> {
          if (err){console.log('err:::',err); return err}
          contract = web3.eth.contract(ledgerAbi).at(contract_address);
          func(contract, A)
     });
};

this.issueTokens = (contract,A)=> {
     var params   = { from: creator, gas: 2000000 };

     contract.issueTokens(A.address, A.token_count, params, (err,res)=>{
          if(err) { return A.cb(err)}
          var out = {
               tx: res,
               txLink: 'https://etherscan.io/tx/'+res
          }
          return A.cb(null, out)
     });
}



this.issue = (address, token_count)=> {
     getContractAbi(':SampleToken')(base+'ethlend/server/SimpleToken.sol')((err,Abi,ledgerBytecode)=> {
          if (err){console.log('err:::',err); return err}
          contract = web3.eth.contract(Abi).at('0x735F9b02c76602a837f1Bc614f8fF8D91668E919');
          contract.issueTokens(address, token_count, { from: '0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7', gas: 4000000 }, conscb )
     });
};


this.transfer = (contract,A)=> {
     var params   = { from: creator, gas: 2000000 };

     contract.transfer(A.address, A.token_count, params, (err,res)=>{
          if(err) { return A.cb(err)}
          var out = {
               tx: res,
               txLink: 'https://etherscan.io/tx/'+res
          }
          return A.cb(null, out)
     });
}


this.setParams = (contract_address, node, fee, enabled, repAddress)=> { //creator=0x5f6B5B7D4b99bC78AA622E50115628cd247B9A15
     fs.writeFileSync(base+'ethlend/config-other-params.ls',   
          `config.ETH_MAIN_ADDRESS = '${contract_address}'\n` +
          `config.ETH_MAIN_ADDRESS_LINK = 'https://etherscan.io/address/${contract_address}'\n` +
          `config.BALANCE_FEE_AMOUNT_IN_WEI = ${fee}\n` +
          `config.ETH_NODE = '${node}'\n` +
          `config.SMART_CONTRACTS_ENABLED = ${enabled}\n` +
          `config.REPUTATION_ADDRESS = ${repAddress}`
     );
};

this.recompileAbi = ()=> { //creator=0x5f6B5B7D4b99bC78AA622E50115628cd247B9A15
     
     getContractAbi(':Ledger')(base+'ethlend/server/EthLend.sol')((err,ledgerAbi,ledgerBytecode,abiJsonLedger)=>{
          if (err){ console.log('err:::',err); return err }

          getContractAbi(':LendingRequest')(base+'ethlend/server/EthLend.sol')((err,lrAbi,bytecode,abiJsonLr)=>{
               if (err){ console.log('err:::',err); return err }

               getContractAbi(':ReputationToken')(base+'ethlend/server/ReputationToken.sol')((err,repAbi,bytecode,abiJsonRep)=>{
                    if (err){ console.log('err:::',err); return err }

                         fs.writeFileSync(base+'ethlend/config-abi.ls',   
                              `config.LEDGER-ABI = ${JSON.stringify(ledgerAbi)}\n`+
                              `config.LR-ABI     = ${JSON.stringify(lrAbi)}\n`+
                              `config.REP-ABI    = ${JSON.stringify(repAbi)}`
                         );

                    console.log('Config at ethlend/config-abi.ls has written');
               });
          });
     });
};

Meteor.methods({
     'issue': (address, token_count)=>call_API_method(issueTokens)({
          address:     address, 
          token_count: token_count, 
          cb:          conscb
     }),

     'transfer': (address, token_count)=>call_API_method(transfer)({
          address:     address, 
          token_count: token_count, 
          cb:          conscb
     })
})
