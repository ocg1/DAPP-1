var solc = Npm.require('solc');
var fs = Npm.require('fs');
var BigNumber = Npm.require('bignumber.js');
var path = Npm.require('path');
this.base =  path.resolve('.').split('.meteor')[0];
var Web3 = Npm.require('web3');

this.setParams = (contract_address, node, fee, enabled)=> { //creator=0x5f6B5B7D4b99bC78AA622E50115628cd247B9A15

     fs.writeFileSync(base+'ethlend/config-other-params.ls',   
`config.ETH_MAIN_ADDRESS = '${contract_address}'
config.ETH_MAIN_ADDRESS_LINK = 'https://kovan.etherscan.io/address/${contract_address}'
config.BALANCE_FEE_AMOUNT_IN_WEI = ${fee}
config.ETH_NODE = '${node}'
config.SMART_CONTRACTS_ENABLED = ${enabled}`
     );
};

this.recompileAbi = ()=> { //creator=0x5f6B5B7D4b99bC78AA622E50115628cd247B9A15
     var contractName = ':Ledger';
     getContractAbi(contractName,function(err,ledgerAbi,ledgerBytecode,abiJsonLedger){
          if (err){ console.log('err:::',err); return err }

          var contractName2 = ':LendingRequest';
          getContractAbi(contractName2,function(err,lrAbi,bytecode,abiJsonLr){
               if (err){ console.log('err:::',err); return err }
               fs.writeFileSync(base+'ethlend/config-abi.ls',   
`
config.LEDGER-ABI = ${abiJsonLedger}
config.LR-ABI = ${abiJsonLr}`
                    );
               console.log('Wrote сonfig to ethlend/config-abi.ls');
          });
     });
};

this.getContractAbi=(contractName,cb)=>{
     var file = base+'ethlend/server/EthLend.sol';

     fs.readFile(file, function(err, result){
          // assert.equal(err,null);
          if (err){ console.log('err:::',err); return cb(err) }

          var source = result.toString();
          // assert.notEqual(source.length,0);

          var output = solc.compile(source, 1);   // 1 activates the optimiser

          var abiJson = output.contracts[contractName].interface;

          var abi = JSON.parse(abiJson);
          var bytecode = output.contracts[contractName].bytecode;

          return cb(null,abi,bytecode,abiJson);
     });
}

this.deployMain=(node, creator,ledgerAbi,ledgerBytecode)=>{
     var web3 = new Web3(new Web3.providers.HttpProvider(node));

     web3.eth.getAccounts(function(err, as) {
          if(err) { return }
     

          var tempContract = web3.eth.contract(ledgerAbi);
          var whereToSendMoney = creator;
          tempContract.new(
               whereToSendMoney,
               {
                    from: creator, 
                    gas: 4995000,
                    data: '0x' + ledgerBytecode 
               }, 
               function(err, c){
                    if(err){
                         console.log('ERROR: ',err);
                         return;
                    }           
                    console.log('TX hash: ',c.transactionHash);
               }
          );
     });
}
