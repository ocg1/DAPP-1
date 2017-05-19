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
var contract_address      = '0x735f9b02c76602a837f1bc614f8ff8d91668e919';
var node                  = 'http://ethnode.chain.cloud:8545';
var contract = '';

var Web3 = Npm.require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider(node));

deployMain=(creator,ledgerAbi,ledgerBytecode,cb)=> {
     var tempContract     = web3.eth.contract(ledgerAbi);
     var whereToSendMoney = creator;
     var params = { from: creator, gas: 4995000, data: `0x${ledgerBytecode}`}
     tempContract.new(whereToSendMoney, params, (err, c)=> {
          if(err){ Ω('ERROR: ' + err); return cb(err) }
          return cb(null, c.transactionHash)
     });
}

getContractAbi=(cName)=> (filename)=> (cb)=> fs.readFile(filename, (err, res)=>{ 
     // assert.equal(err,null);
     if (err) return cb(err)
     var source = res.toString();
     // assert.notEqual(source.length,0);
     var output   = solc.compile(source, 1);
     var abi      = JSON.parse(output.contracts[cName].interface);
     var bytecode = output.contracts[cName].bytecode;
     return cb(null,abi,bytecode);
});

Create =(cb)=>{
     console.log('base:',base)
     web3.eth.getAccounts((err, as)=> {
          console.log('as: '+as)
          if(err) { return cb(err)}
          getContractAbi(':SampleToken')(base+'/ethland/server/SimpleToken.sol')((err,ledgerAbi,ledgerBytecode)=> {
               if(err) { return cb(err)}
               console.log('got contract abi')
               deployMain(creator,ledgerAbi,ledgerBytecode, (err,res)=>{
                    console.log('deployed: '+res )
                    if(err) { return cb(err)}
                    return cb(null,res)
               })
          });
     });
}

call_API_method = (func)=>(A)=>{
     getContractAbi(':SampleToken')(base+'/ethland/server/SimpleToken.sol')((err,ledgerAbi,ledgerBytecode)=> {
          contract = web3.eth.contract(ledgerAbi).at(contract_address);
          func(contract, A)
     });
};

issueTokens = (contract,A)=> {
     var params   = { from: creator, gas: 2000000 };

     contract.issueTokens(A.address, A.token_count, params, (err,res)=>{
          if(err) { return A.cb(err)}
          var out = {
               tx: res,
               txLink: 'https://kovan.etherscan.io/tx/'+res
          }
          return A.cb(null, out)
     });
}

transfer = (contract,A)=> {
     var params   = { from: creator, gas: 2000000 };

     contract.transfer(A.address, A.token_count, params, (err,res)=>{
          if(err) { return A.cb(err)}
          var out = {
               tx: res,
               txLink: 'https://kovan.etherscan.io/tx/'+res
          }
          return A.cb(null, out)
     });
}

 Meteor.methods({
      'create': ()=> Create((err,res)=>{
           console.log('err:',err,'res:',res)
      }),

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
