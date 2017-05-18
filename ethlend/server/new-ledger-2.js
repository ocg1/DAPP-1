var solc = Npm.require('solc');
var fs = Npm.require('fs');
var BigNumber = Npm.require('bignumber.js');
var path = Npm.require('path');
var base =  path.resolve('.').split('.meteor')[0];
var Web3 = Npm.require('web3');

// var creator               = '0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7';
// var contract_address      = '0x735f9b02c76602a837f1bc614f8ff8d91668e919';
// var node                  = 'http://ethnode.chain.cloud:8545';


// (creator, contract_address, node, fee, enabled)


// renewContract('0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7', '0x735f9b02c76602a837f1bc614f8ff8d91668e919', 'http://ethnode.chain.cloud:8545',100500,true)


this.renewContract = (creator, contract_address, node, fee, enabled)=> {
     var web3 = new Web3(new Web3.providers.HttpProvider(node));

     web3.eth.getAccounts(function(err, as) {
          if(err) { return }

          getContractAbi=(contractName,cb)=>{
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

          deployMain=(creator,ledgerAbi,ledgerBytecode)=>{
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
                              console.log('ERROR: ' + err);
                              return;
                         }           
                         console.log('TX hash: ',c.transactionHash);
                    });
          }
          
          var contractName = ':Ledger';
          getContractAbi(contractName,function(err,ledgerAbi,ledgerBytecode,abiJsonLedger){
               if (err){ console.log('err:::',err); return err }

               // fs.writeFileSync(base+'ethlend/client/ledger_abi.ls','config.LEDGER-ABI = '+abiJson);
               console.log('Wrote Ledger abi to file: ledger_abi.ls');

               var contractName2 = ':LendingRequest';
               getContractAbi(contractName2,function(err,lrAbi,bytecode,abiJsonLr){
                    if (err){ console.log('err:::',err); return err }
                    fs.writeFileSync(base+'ethlend/config.ls',
      
`this.config = {}
config.LEDGER-ABI = ${abiJsonLedger}
config.LR-ABI = ${abiJsonLr}
config.ETH_MAIN_ADDRESS = '${contract_address}'
config.ETH_MAIN_ADDRESS_LINK = 'https://kovan.etherscan.io/address/${contract_address}'
config.BALANCE_FEE_AMOUNT_IN_WEI = ${fee}
config.BALANCE_FEE_AMOUNT_IN_WEI = ${fee}
config.ETH_NODE = '${node}'
config.SMART_CONTRACTS_ENABLED = ${enabled}`

                         );
                    console.log('Wrote tonfig to ethlend/config.ls');

                    deployMain(creator,ledgerAbi,ledgerBytecode);
               });
          });
     });
}





// SMART_CONTRACTS_ENABLED    : true
// ETH_NODE                   : \http://ethnode.chain.cloud:8545
// ETH_MAIN_ADDRESS           : \0xD58803CFBbD47CB1437528D8B99e08bfe559D668
// ETH_MAIN_ADDRESS_LINK      : \https://kovan.etherscan.io/address/0xD58803CFBbD47CB1437528D8B99e08bfe559D668
// BALANCE_FEE_AMOUNT_IN_WEI  : 100500
// # LR-ABI                     : [{"constant":false,"inputs":[{"name":"new_","type":"address"}],"name":"changeMainAddress","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"currentState","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"mainAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lenderFeeAmount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"new_","type":"address"}],"name":"changeLedgerAddress","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getState","outputs":[{"name":"out","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token_smartcontract_address","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getBorrower","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenSmartcontractAddress","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token_infolink","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"waitingForPayback","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"premium_wei","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getNeededSumByBorrower","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token_amount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ledger","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"waitingForLender","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"getDaysToLen","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenAmount","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"checkTokens","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"wanted_wei","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"borrower","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenInfoLink","outputs":[{"name":"out","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenName","outputs":[{"name":"out","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token_name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getLender","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"cancell","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"whereToSendFee","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getWantedWei","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getNeededSumByLender","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lender","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"days_to_lend","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"wanted_wei_","type":"uint256"},{"name":"token_amount_","type":"uint256"},{"name":"premium_wei_","type":"uint256"},{"name":"token_name_","type":"string"},{"name":"token_infolink_","type":"string"},{"name":"token_smartcontract_address_","type":"address"},{"name":"days_to_lend_","type":"uint256"}],"name":"setData","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"requestDefault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getPremiumWei","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"mainAddress_","type":"address"},{"name":"borrower_","type":"address"},{"name":"whereToSendFee_","type":"address"}],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"}]
// # LEDGER-ABI                 : [{"constant":true,"inputs":[],"name":"mainAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"getLr","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"getLrFunded","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"a","type":"address"},{"name":"index","type":"uint256"}],"name":"getLrForUser","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalLrCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getLrCount","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"whereToSendFee","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"createNewLendingRequest","outputs":[{"name":"out","type":"address"}],"payable":true,"type":"function"},{"constant":true,"inputs":[{"name":"a","type":"address"}],"name":"getLrCountForUser","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"borrowerFeeAmount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getLrFundedCount","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getFeeSum","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"whereToSendFee_","type":"address"}],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"}]
