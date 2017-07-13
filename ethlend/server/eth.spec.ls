# @solc      = Npm.require \solc
# @Web3      = Npm.require \web3
# @fs        = Npm.require \fs
# @assert    = Npm.require \assert
# @BigNumber = Npm.require \bignumber.js
# @path      = Npm.require \path
# @say       = console.log 
# @web3      = new Web3 new Web3.providers.HttpProvider \http://localhost:8545
# @config    = {}

# @getContractAbi = (cName,filename,cb)-> fs.readFile filename, (err, res)->
#     if (err) => return cb err
#     source   = res.toString()
#     output   = solc.compile(source, 1)
#     abi      = JSON.parse(output.contracts[cName].interface)
#     bytecode = output.contracts[cName].bytecode
#     return cb(null,abi,bytecode)

# @recompileAbi = ->
#     getContractAbi \:Ledger "#{base}ethlend/server/EthLend.sol"  (err, ledgerAbi, ledgerBytecode, abiJsonLedger) ->
#         if err => return say \err: err
#         getContractAbi \:LendingRequest "#{base}ethlend/server/EthLend.sol"  (err, lrAbi, bytecode, abiJsonLr) ->
#             if err => return say \err: err
#             getContractAbi \:ReputationToken "#{base}ethlend/server/ReputationToken.sol" (err, repAbi, bytecode, abiJsonRep) ->
#                 if err => return say \err: err

#                 getContractAbi \:TestENS,  "#{base}ethlend/server/TestENS.sol", (err, ensAbi, bytecode, abiJsonTestENS) ->
#                     if err => return say \err: err
#                     config.LEDGER-ABI = JSON.stringify ledgerAbi
#                     config.LR-ABI     = JSON.stringify lrAbi
#                     config.ENS-ABI    = JSON.stringify ensAbi
#                     config.REP-ABI    = JSON.stringify repAbi
#                     say 'Config has written'

# init BigNumber
# unit = new BigNumber(10 ** 18)
# WANTED_WEI = web3.toWei(0.1, 'ether')
# PREMIUM_WEI = web3.toWei(0.1, 'ether')

# config.LEDGER-ABI = [{"constant":true,"inputs":[],"name":"mainAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"repTokenAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"getLr","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"getLrFunded","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"a","type":"address"},{"name":"index","type":"uint256"}],"name":"getLrForUser","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ensRegistryAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"createNewLendingRequestEns","outputs":[{"name":"out","type":"address"}],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"address"},{"name":"weiSum","type":"uint256"}],"name":"unlockRepTokens","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalLrCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"address"},{"name":"weiSum","type":"uint256"}],"name":"lockRepTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"address"},{"name":"weiSum","type":"uint256"}],"name":"addRepTokens","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getLrCount","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"whereToSendFee","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"collateralType","type":"int256"}],"name":"newLr","outputs":[{"name":"out","type":"address"}],"payable":true,"type":"function"},{"constant":false,"inputs":[],"name":"createNewLendingRequest","outputs":[{"name":"out","type":"address"}],"payable":true,"type":"function"},{"constant":true,"inputs":[{"name":"a","type":"address"}],"name":"getLrCountForUser","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"borrowerFeeAmount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"createNewLendingRequestRep","outputs":[{"name":"out","type":"address"}],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"getLrFundedCount","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getRepTokenAddress","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"address"}],"name":"burnRepTokens","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getFeeSum","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"whereToSendFee_","type":"address"},{"name":"repTokenAddress_","type":"address"},{"name":"ensRegistryAddress_","type":"address"}],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"}]
# config.LR-ABI     = [{"constant":true,"inputs":[],"name":"currentType","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"new_","type":"address"}],"name":"changeMainAddress","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"isEns","outputs":[{"name":"out","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"currentState","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"mainAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lenderFeeAmount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"new_","type":"address"}],"name":"changeLedgerAddress","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getState","outputs":[{"name":"out","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token_smartcontract_address","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getBorrower","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenSmartcontractAddress","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token_infolink","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"wanted_wei_","type":"uint256"},{"name":"token_amount_","type":"uint256"},{"name":"premium_wei_","type":"uint256"},{"name":"token_name_","type":"string"},{"name":"token_infolink_","type":"string"},{"name":"token_smartcontract_address_","type":"address"},{"name":"days_to_lend_","type":"uint256"},{"name":"ens_domain_hash_","type":"bytes32"}],"name":"setData","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"waitingForPayback","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"premium_wei","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getNeededSumByBorrower","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"checkDomain","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"releaseToBorrower","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token_amount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ledger","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"waitingForLender","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"getDaysToLen","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"releaseToLender","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenAmount","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"checkTokens","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"isRep","outputs":[{"name":"out","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"wanted_wei","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"borrower","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenInfoLink","outputs":[{"name":"out","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getTokenName","outputs":[{"name":"out","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token_name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getLender","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ens_domain_hash","outputs":[{"name":"","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"cancell","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"whereToSendFee","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getWantedWei","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getNeededSumByLender","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lender","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"days_to_lend","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getEnsDomainHash","outputs":[{"name":"out","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"requestDefault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getPremiumWei","outputs":[{"name":"out","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"returnTokens","outputs":[],"payable":false,"type":"function"},{"inputs":[{"name":"mainAddress_","type":"address"},{"name":"borrower_","type":"address"},{"name":"whereToSendFee_","type":"address"},{"name":"contractType","type":"int256"},{"name":"ensRegistryAddress_","type":"address"}],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"}]
# config.ENS-ABI    = [{"constant":true,"inputs":[{"name":"node","type":"bytes32"}],"name":"resolver","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"node","type":"bytes32"}],"name":"owner","outputs":[{"name":"out","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"node","type":"bytes32"},{"name":"label","type":"bytes32"},{"name":"owner","type":"address"}],"name":"setSubnodeOwner","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"node","type":"bytes32"},{"name":"ttl","type":"uint64"}],"name":"setTTL","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"node","type":"bytes32"}],"name":"ttl","outputs":[{"name":"","type":"uint64"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"node","type":"bytes32"},{"name":"resolver","type":"address"}],"name":"setResolver","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"node","type":"bytes32"},{"name":"o","type":"address"}],"name":"setOwner","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner_","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"node","type":"bytes32"},{"indexed":true,"name":"label","type":"bytes32"},{"indexed":false,"name":"owner","type":"address"}],"name":"NewOwner","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"node","type":"bytes32"},{"indexed":false,"name":"owner","type":"address"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"node","type":"bytes32"},{"indexed":false,"name":"resolver","type":"address"}],"name":"NewResolver","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"node","type":"bytes32"},{"indexed":false,"name":"ttl","type":"uint64"}],"name":"NewTTL","type":"event"}]
# config.REP-ABI    = [{"constant":true,"inputs":[],"name":"creator","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"supplyOut","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"allSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"forAddress","type":"address"},{"name":"tokenCount","type":"uint256"}],"name":"issueTokens","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newCreator","type":"address"}],"name":"changeCreator","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"forAddress","type":"address"},{"name":"tokenCount","type":"uint256"}],"name":"unlockTokens","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"forAddress","type":"address"},{"name":"tokenCount","type":"uint256"}],"name":"lockTokens","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"forAddress","type":"address"}],"name":"burnTokens","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]




# diffWithGas = (mustBe, diff) ->
#     gasFee = 5000000
#     diff >= mustBe and diff <= mustBe + gasFee

# getContractAbi = (contractName, cb) ->
#     file = base+'ethlend/server/EthLend.sol'
#     fs.readFile file, (err, result) ->
#         assert.equal err, null
#         source = result.toString()
#         # assert.notEqual source.length, 0
#         output = solc.compile(source, 1)
#         # 1 activates the optimiser
#         abi = JSON.parse(output.contracts[contractName].interface)
#         cb null, abi
#     return

# deployLedgerContract = (data, cb) ->
#     file = base+'ethlend/server/EthLend.sol'
#     contractName = ':Ledger'
#     fs.readFile file, (err, result) ->
#         assert.equal err, null
#         console.log 'Checkpoint...5'
#         source = result.toString()
#         assert.notEqual source.length, 0
#         assert.equal err, null
#         output = solc.compile(source, 0)
#         # 1 activates the optimiser
#         #console.log('OUTPUT: ');
#         #console.log(output.contracts);
#         abi = JSON.parse(output.contracts[contractName].interface)
#         bytecode = output.contracts[contractName].bytecode
#         tempContract = web3.eth.contract(abi)
#         alreadyCalled = false
#         console.log 'Creator: ' + creator
#         whereToSendMoneyTo = feeCollector
#         console.log 'whereToSendMoneyTo:', whereToSendMoneyTo
#         console.log 'repAddress:', repAddress
#         console.log 'ensContractAddress:', ensContractAddress
#         console.log 'Checkpoint...6'
#         tempContract.new whereToSendMoneyTo, repAddress, ensContractAddress, {
#             from: creator
#             gas: 5995000
#             data: '0x' + bytecode
#         }, (err, c) ->
#             assert.equal err, null
#             console.log 'TX HASH: '
#             console.log c.transactionHash
#             # TX can be processed in 1 minute or in 30 minutes...
#             # So we can not be sure on this -> result can be null.
#             web3.eth.getTransactionReceipt c.transactionHash, (err, result) ->
#                 #console.log('RESULT: ');
#                 #console.log(result);
#                 assert.equal err, null
#                 assert.notEqual result, null
#                 ledgerContractAddress = result.contractAddress
#                 ledgerContract = web3.eth.contract(abi).at(ledgerContractAddress)
#                 console.log 'Ledger contract address: '
#                 console.log ledgerContractAddress
#                 if !alreadyCalled
#                     alreadyCalled = true
#                     return cb(null)
#                 return
#             return
#         return
#     return

# deployContract = (data, cb) ->
#         alreadyCalled      = false
#         whereToSendFee     = creator
#         collateralType     = 1
#         ensRegistryAddress = 0
#         params = {from: creator,gas: 5995000,data: '0x' + bytecode},
#         tempContract.new creator, borrower, whereToSendFee, collateralType, ensRegistryAddress, params, (err, c) ->
#             assert.equal err, null
#             say 'TX HASH:' c.transactionHash

#             web3.eth.getTransactionReceipt c.transactionHash, (err, result)->
#                 assert.equal err, null
#                 assert.notEqual result, null
#                 contract = web3.eth.contract(abi).at result.contractAddress
#                 say 'Contract address:' result.contractAddress
#                 if !alreadyCalled
#                     alreadyCalled = true
#                     return cb(null)

# deployTokenContract = (data, cb) ->
#     file = base+'ethlend/server/SampleToken.sol'
#     contractName = ':SampleToken'
#     fs.readFile file, (err, result) ->
#         assert.equal err, null
#         source = result.toString()
#         assert.notEqual source.length, 0
#         assert.equal err, null
#         output = solc.compile(source, 0)
#         # 1 activates the optimiser
#         #console.log('OUTPUT: ');
#         #console.log(output.contracts);
#         abi = JSON.parse(output.contracts[contractName].interface)
#         bytecode = output.contracts[contractName].bytecode
#         tempContract = web3.eth.contract(abi)
#         alreadyCalled = false
#         tempContract.new creator, borrower, {
#             from: creator
#             gas: 5995000
#             data: '0x' + bytecode
#         }, (err, c) ->
#             assert.equal err, null
#             console.log 'TX HASH: '
#             console.log c.transactionHash
#             # TX can be processed in 1 minute or in 30 minutes...
#             # So we can not be sure on this -> result can be null.
#             web3.eth.getTransactionReceipt c.transactionHash, (err, result) ->
#                 #console.log('RESULT: ');
#                 #console.log(result);
#                 assert.equal err, null
#                 assert.notEqual result, null
#                 tokenAddress = result.contractAddress
#                 token = web3.eth.contract(abi).at(tokenAddress)
#                 console.log 'Token address: '
#                 console.log tokenAddress
#                 if !alreadyCalled
#                     alreadyCalled = true
#                     return cb(null)
#                 return
#             return
#         return
#     return

# deployEnsContract = (data, cb) ->
#     file = base+'ethlend/server/TestENS.sol'
#     contractName = ':TestENS'
#     fs.readFile file, (err, result) ->
#         assert.equal err, null
#         source = result.toString()
#         assert.notEqual source.length, 0
#         assert.equal err, null
#         output = solc.compile(source, 0)
#         # 1 activates the optimiser
#         abi = JSON.parse(output.contracts[contractName].interface)
#         bytecode = output.contracts[contractName].bytecode
#         tempContract = web3.eth.contract(abi)
#         alreadyCalled = false
#         console.log 'Creator: ' + creator
#         whereToSendMoneyTo = feeCollector
#         ensRegistryAddress = 0
#         tempContract.new {
#             from: creator
#             gas: 5995000
#             data: '0x' + bytecode
#         }, (err, c) ->
#             if alreadyCalled
#                 return
#             alreadyCalled = true
#             assert.equal err, null
#             console.log 'TX HASH: '
#             console.log c.transactionHash
#             alreadyCalled2 = false
#             # TX can be processed in 1 minute or in 30 minutes...
#             # So we can not be sure on this -> result can be null.
#             web3.eth.getTransactionReceipt c.transactionHash, (err, result) ->
#                 #console.log('RESULT: ');
#                 #console.log(result);
#                 assert.equal err, null
#                 assert.notEqual result, null
#                 ensContractAddress = result.contractAddress
#                 ensContract = web3.eth.contract(abi).at(ensContractAddress)
#                 console.log 'ENS contract address: '
#                 console.log ensContractAddress
#                 if !alreadyCalled2
#                     alreadyCalled2 = true
#                     return cb(null)
#                 return
#             return
#         return
#     return

# deployRepContract = (data, cb) ->
#     file = base+'ethlend/server/ReputationToken.sol'
#     contractName = ':ReputationToken'
#     fs.readFile file, (err, result) ->
#         assert.equal err, null
#         source = result.toString()
#         assert.notEqual source.length, 0
#         assert.equal err, null
#         output = solc.compile(source, 0)
#         # 1 activates the optimiser
#         #console.log('OUTPUT: ');
#         #console.log(output.contracts);
#         abi = JSON.parse(output.contracts[contractName].interface)
#         bytecode = output.contracts[contractName].bytecode
#         tempContract = web3.eth.contract(abi)
#         alreadyCalled = false
#         tempContract.new creator, borrower, {
#             from: creator
#             gas: 5995000
#             data: '0x' + bytecode
#         }, (err, c) ->
#             assert.equal err, null
#             console.log 'TX HASH: '
#             console.log c.transactionHash
#             # TX can be processed in 1 minute or in 30 minutes...
#             # So we can not be sure on this -> result can be null.
#             web3.eth.getTransactionReceipt c.transactionHash, (err, result) ->
#                 #console.log('RESULT: ');
#                 #console.log(result);
#                 assert.equal err, null
#                 assert.notEqual result, null
#                 repAddress = result.contractAddress
#                 rep = web3.eth.contract(abi).at(repAddress)
#                 console.log 'Token address: '
#                 console.log repAddress
#                 if !alreadyCalled
#                     alreadyCalled = true
#                     return cb(null)
#                 return
#             return
#         return
#     return

# updateRepContractCreator = (cb) ->
#     rep.changeCreator ledgerContractAddress, {
#         from: creator
#         gas: 2900000
#     }, (err, result) ->
#         assert.equal err, null
#         web3.eth.getTransactionReceipt result, (err, r2) ->
#             assert.equal err, null
#             cb()
#             return
#         return
#     return


# describe 'Contracts 0 - Deploy Ledger', (api)->
#     before -> 
#         web3.eth.getAccounts (err, as) ->
#             say \as: as.0
#             if err => return done err
#             creator = as.0

#         # recompileAbi!


#     it 'should deploy Ledger contract' (done)->
#         # say recompileAbi!
#         say \path: path.resolve()

#         done!
    #     data = {}
    #     deployLedgerContract data, (err) ->
    #         console.log 'Ledger deployed...'
    #         assert.equal err, null
    #         done()
    #         return
    #     return
    # return

# describe 'Contracts 1', (api)->
#     before 'Initialize everything', (done) ->
#         web3.eth.getAccounts (err, as) ->
#             if err
#                 done err
#                 return
#             accounts = as
#             creator = accounts[0]
#             borrower = accounts[1]
#             feeCollector = accounts[2]
#             lender = accounts[3]
#             contractName = ':Ledger'
#             getContractAbi contractName, (err, abi) ->
#                 ledgerAbi = abi
#                 contractName = ':LendingRequest'
#                 getContractAbi contractName, (err, abi) ->
#                     requestAbi = abi
#                     done()
#                     return
#                 return
#             return
#         return
#     after 'Deinitialize everything', (done) ->
#         done()
#         return

#     it 'should deploy ENS contract', (done) ->
#         data = {}
#         deployEnsContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy Rep token contract', (done) ->
#         data = {}
#         deployRepContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy Ledger contract', (done) ->
#         data = {}
#         deployLedgerContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should update creator', (done) ->
#         data = {}
#         updateRepContractCreator (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy Sample token contract', (done) ->
#         data = {}
#         deployTokenContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should get initial creator balance', (done) ->
#         initialBalanceCreator = web3.eth.getBalance(creator)
#         console.log 'Creator initial balance is: '
#         console.log initialBalanceCreator.toString(10)
#         done()
#         return

#     it 'should get initial borrower balance', (done) ->
#         initialBalanceBorrower = web3.eth.getBalance(borrower)
#         console.log 'Borrower initial balance is: '
#         console.log initialBalanceCreator.toString(10)
#         done()
#         return

#     it 'should get initial feeCollector balance', (done) ->
#         initialBalanceFeeCollector = web3.eth.getBalance(feeCollector)
#         console.log 'FeeCollector initial balance is: '
#         console.log initialBalanceFeeCollector.toString(10)
#         done()
#         return

#     it 'should get initial lender balance', (done) ->
#         initialBalanceLender = web3.eth.getBalance(lender)
#         console.log 'Lender initial balance is: '
#         console.log initialBalanceLender.toString(10)
#         done()
#         return

#     it 'should get current count of LR', (done) ->
#         count = ledgerContract.getLrCount()
#         assert.equal count, 0
#         done()
#         return

#     it 'should get intial count of LR for borrower', (done) ->
#         count = ledgerContract.getLrCountForUser(borrower)
#         assert.equal count, 0
#         done()
#         return

#     it 'should issue some tokens for me', (done) ->
#         token.issueTokens borrower, 1000, {
#             from: creator
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should return 1000 as a balance', (done) ->
#         balance = token.balanceOf(borrower)
#         assert.equal balance, 1000
#         done()
#         return

#     it 'should issue new LR', (done) ->
#         # 0.2 ETH
#         amount = 200000000000000000
#         web3.eth.sendTransaction {
#             from: borrower
#             to: ledgerContractAddress
#             value: amount
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should get updated count of LR', (done) ->
#         count = ledgerContract.getLrCount()
#         assert.equal count, 1
#         done()
#         return

#     it 'should get updated count of LR for borrower', (done) ->
#         count = ledgerContract.getLrCountForUser(borrower)
#         assert.equal count, 1
#         done()
#         return

#     it 'should get updated feeCollector balance', (done) ->
#         current = web3.eth.getBalance(feeCollector)
#         feeAmount = 10000000000000000
#         diff = current - initialBalanceFeeCollector
#         assert.equal diff.toString(10), feeAmount
#         done()
#         return

#     it 'should get updated borrower balance', (done) ->
#         current = web3.eth.getBalance(borrower)
#         mustBe = 200000000000000000
#         diff = initialBalanceBorrower - current
#         assert.equal diffWithGas(mustBe, diff), true
#         done()
#         return

#     it 'should get LR contract', (done) ->
#         assert.equal ledgerContract.getLrCount(), 1
#         a = ledgerContract.getLr(0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for data" state
#         assert.equal state.toString(), 0
#         done()
#         return

#     it 'should get LR contract for user', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for data" state
#         assert.equal state.toString(), 0
#         done()
#         return

#     it 'should set data', (done) ->
#         data = 
#             wanted_wei: WANTED_WEI
#             token_amount: 10
#             premium_wei: PREMIUM_WEI
#             token_name: 'SampleContract'
#             token_infolink: 'https://some-sample-ico.network'
#             token_smartcontract_address: tokenAddress
#             days_to_lend: 10
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         # this is set by creator (from within platform)
#         lr.setData data.wanted_wei, data.token_amount, data.premium_wei, data.token_name, data.token_infolink, data.token_smartcontract_address, data.days_to_lend, 0, {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should move to Waiting for tokens state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for tokens" state
#         assert.equal state.toString(), 1
#         done()
#         return

#     it 'should check if tokens are transferred', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.checkTokens {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should not move into <WaitingForLender> state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for tokens" state
#         assert.equal state.toString(), 1
#         done()
#         return

#     it 'should move 1 token to LR', (done) ->
#         lr = ledgerContract.getLrForUser(borrower, 0)
#         # Borrower -> LR contract
#         token.transfer lr, 1, {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should check again if tokens are transferred', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.checkTokens {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should not move into <WaitingForLender> state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for tokens" state
#         assert.equal state.toString(), 1
#         done()
#         return

#     it 'should move 9 more token to LR', (done) ->
#         lr = ledgerContract.getLrForUser(borrower, 0)
#         # Borrower -> LR contract
#         token.transfer lr, 9, {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should check again if tokens are transferred', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         balance = token.balanceOf(borrower)
#         assert.equal balance, 990
#         balance2 = token.balanceOf(a)
#         assert.equal balance2, 10
#         lr.checkTokens {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should move into <WaitingForLender> state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for lender" state
#         assert.equal state.toString(), 3
#         done()
#         return

#     it 'should allow to ask for check again', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.checkTokens {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             # TODO: why fails?
#             done()
#             return
#         return

#     it 'should collect money from Lender now', (done) ->
#         current = web3.eth.getBalance(lender)
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         wanted_wei = lr.getNeededSumByLender()
#         amount = wanted_wei
#         # WARNING: see this
#         initialBalanceBorrower = web3.eth.getBalance(borrower)
#         # this should be called by borrower
#         web3.eth.sendTransaction {
#             from: lender
#             to: a
#             value: wanted_wei
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should get correct lender', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         assert.equal lr.getLender(), lender
#         done()
#         return

#     it 'should get updated lender balance', (done) ->
#         current = web3.eth.getBalance(lender)
#         wantedWei = WANTED_WEI
#         diff = initialBalanceLender - current
#         assert.equal diffWithGas(wantedWei, diff), true
#         done()
#         return

#     it 'should move to WaitingForPayback state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting For Payback" state
#         assert.equal state.toString(), 4
#         done()
#         return

#     it 'should move all ETH to borrower', (done) ->
#         # ETH should be moved to borrower
#         # tokens should be held on contract
#         wantedWei = WANTED_WEI
#         current = web3.eth.getBalance(borrower)
#         diff = current - initialBalanceBorrower
#         console.log 'DIFF: ', diff
#         console.log 'CURR: ', wantedWei
#         assert.equal diffWithGas(wantedWei, diff), true
#         done()
#         return
#     #////////////////////////////////////////////////////////

#     ###
#      # TODO: uncomment...

#     # it('should not move to Finished if not all money is sent',function(done){
#     #          var amount = WANTED_WEI; // no premium!
#     #          var a = ledgerContract.getLrForUser(borrower,0);

#     #          // this should be called by borrower
#     #          web3.eth.sendTransaction(
#     #                     {
#     #                              from: borrower,                             
#     #                              to: a,
#     #                              value: amount,
#     #                              gas: 2900000 
#     #                     },function(err,result){
#     #                              assert.notEqual(err,null);

#     #                              done();
#     #                     }
#     #          );
#     # });

#     # it('should not be in Finished state',function(done){
#     #          assert.equal(ledgerContract.getLrCountForUser(borrower),1);
             
#     #          var a = ledgerContract.getLrForUser(borrower,0);
#     #          var lr = web3.eth.contract(requestAbi).at(a);

#     #          var state = lr.getState();
#     #           # still in "Waiting For Payback" state
#     #          assert.equal(state.toString(),4);
#     #          done();
#     # })
#     ###

#     # it('should send money back from borrower',function(done){
#     #            var a = ledgerContract.getLrForUser(borrower,0);
#     #            var lr = web3.eth.contract(requestAbi).at(a);
#     #            var amount = lr.getNeededSumByBorrower();
#     #            // this should be called by borrower
#     #            web3.eth.sendTransaction(
#     #                     {
#     #                                from: borrower,                             
#     #                                to: a,
#     #                                value: amount,
#     #                                gas: 3900000 
#     #                     },function(err,result){
#     #                                console.log('Checkpoint...7')
#     #                                console.log('error:::', err)
#     #                                assert.equal(err,null);
#     #                                web3.eth.getTransactionReceipt(result, function(err, r2){
#     #                                         assert.equal(err, null);
#     #                                         done();
#     #                                });
#     #                     }
#     #            );
#     # });
#     #//////////////////// 
#     # it('should be in Finished state',function(done){
#     #            assert.equal(ledgerContract.getLrCountForUser(borrower),1);
#     #            var a = ledgerContract.getLrForUser(borrower,0);
#     #            var lr = web3.eth.contract(requestAbi).at(a);
#     #            var state = lr.getState();
#     #            // "Finished" state
#     #            assert.equal(state.toString(),6);
#     #            done();
#     # })
#     # it('should release tokens back to borrower',function(done){
#     #            var balance = token.balanceOf(borrower);
#     #            assert.equal(balance,1000);
#     #            var a = ledgerContract.getLrForUser(borrower,0);
#     #            var balance2 = token.balanceOf(a);
#     #            assert.equal(balance2,0);
#     #            done();
#     # });
#     return

# describe 'Contracts 2 - cancel', (api)->
#     before 'Initialize everything', (done) ->
#         web3.eth.getAccounts (err, as) ->
#             if err
#                 done err
#                 return
#             accounts = as
#             creator = accounts[0]
#             borrower = accounts[1]
#             feeCollector = accounts[2]
#             lender = accounts[3]
#             contractName = ':Ledger'
#             getContractAbi contractName, (err, abi) ->
#                 ledgerAbi = abi
#                 contractName = ':LendingRequest'
#                 getContractAbi contractName, (err, abi) ->
#                     requestAbi = abi
#                     done()
#                     return
#                 return
#             return
#         return
#     after 'Deinitialize everything', (done) ->
#         done()
#         return

#     it 'should deploy Rep token contract', (done) ->
#         data = {}
#         deployRepContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy ENS contract', (done) ->
#         data = {}
#         deployEnsContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy Ledger contract', (done) ->
#         data = {}
#         deployLedgerContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should update creator', (done) ->
#         data = {}
#         updateRepContractCreator (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should issue new LR', (done) ->
#         # 0.2 ETH
#         amount = 200000000000000000
#         web3.eth.sendTransaction {
#             from: borrower
#             to: ledgerContractAddress
#             value: amount
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should get updated count of LR', (done) ->
#         count = ledgerContract.getLrCount()
#         assert.equal count, 1
#         done()
#         return

#     it 'should get correct LR state', (done) ->
#         a = ledgerContract.getLr(0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for data" state
#         assert.equal state.toString(), 0
#         done()
#         return

#     it 'should cancel LR', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         # should be called by platform
#         lr.cancell {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should get correct LR state', (done) ->
#         a = ledgerContract.getLr(0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Cancelled" state
#         assert.equal state.toString(), 2
#         done()
#         return

#     it 'should not cancel LR again', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.cancell {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.notEqual err, null
#             done()
#             return
#         return

#     it 'should get correct LR state again', (done) ->
#         a = ledgerContract.getLr(0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Cancelled" state
#         assert.equal state.toString(), 2
#         done()
#         return
#     return

# describe 'Contracts 3 - cancel with refund', (api)->
#     before 'Initialize everything', (done) ->
#         web3.eth.getAccounts (err, as) ->
#             if err
#                 done err
#                 return
#             accounts = as
#             creator = accounts[0]
#             borrower = accounts[1]
#             feeCollector = accounts[2]
#             lender = accounts[3]
#             contractName = ':Ledger'
#             getContractAbi contractName, (err, abi) ->
#                 ledgerAbi = abi
#                 contractName = ':LendingRequest'
#                 getContractAbi contractName, (err, abi) ->
#                     requestAbi = abi
#                     done()
#                     return
#                 return
#             return
#         return
#     after 'Deinitialize everything', (done) ->
#         done()
#         return

#     it 'should deploy Rep token contract', (done) ->
#         data = {}
#         deployRepContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy ENS contract', (done) ->
#         data = {}
#         deployEnsContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy Ledger contract', (done) ->
#         data = {}
#         deployLedgerContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should update creator', (done) ->
#         data = {}
#         updateRepContractCreator (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy Sample token contract', (done) ->
#         data = {}
#         deployTokenContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should get initial creator balance', (done) ->
#         initialBalanceCreator = web3.eth.getBalance(creator)
#         console.log 'Creator initial balance is: '
#         console.log initialBalanceCreator.toString(10)
#         done()
#         return

#     it 'should get initial borrower balance', (done) ->
#         initialBalanceBorrower = web3.eth.getBalance(borrower)
#         console.log 'Borrower initial balance is: '
#         console.log initialBalanceCreator.toString(10)
#         done()
#         return

#     it 'should get initial feeCollector balance', (done) ->
#         initialBalanceFeeCollector = web3.eth.getBalance(feeCollector)
#         console.log 'FeeCollector initial balance is: '
#         console.log initialBalanceFeeCollector.toString(10)
#         done()
#         return

#     it 'should get initial lender balance', (done) ->
#         initialBalanceLender = web3.eth.getBalance(lender)
#         console.log 'Lender initial balance is: '
#         console.log initialBalanceLender.toString(10)
#         done()
#         return

#     it 'should get current count of LR', (done) ->
#         count = ledgerContract.getLrCount()
#         assert.equal count, 0
#         done()
#         return

#     it 'should get intial count of LR for borrower', (done) ->
#         count = ledgerContract.getLrCountForUser(borrower)
#         assert.equal count, 0
#         done()
#         return

#     it 'should issue some tokens for me', (done) ->
#         token.issueTokens borrower, 1000, {
#             from: creator
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should return 1000 as a balance', (done) ->
#         balance = token.balanceOf(borrower)
#         assert.equal balance, 1000
#         done()
#         return

#     it 'should issue new LR', (done) ->
#         # 0.2 ETH
#         amount = 200000000000000000
#         web3.eth.sendTransaction {
#             from: borrower
#             to: ledgerContractAddress
#             value: amount
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should get updated count of LR', (done) ->
#         count = ledgerContract.getLrCount()
#         assert.equal count, 1
#         done()
#         return

#     it 'should get updated count of LR for borrower', (done) ->
#         count = ledgerContract.getLrCountForUser(borrower)
#         assert.equal count, 1
#         done()
#         return

#     it 'should get updated feeCollector balance', (done) ->
#         current = web3.eth.getBalance(feeCollector)
#         feeAmount = 10000000000000000
#         diff = current - initialBalanceFeeCollector
#         assert.equal diff.toString(10), feeAmount
#         done()
#         return

#     it 'should get updated borrower balance', (done) ->
#         current = web3.eth.getBalance(borrower)
#         mustBe = 200000000000000000
#         diff = initialBalanceBorrower - current
#         assert.equal diffWithGas(mustBe, diff), true
#         done()
#         return

#     it 'should get LR contract', (done) ->
#         assert.equal ledgerContract.getLrCount(), 1
#         a = ledgerContract.getLr(0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for data" state
#         assert.equal state.toString(), 0
#         done()
#         return

#     it 'should get LR contract for user', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for data" state
#         assert.equal state.toString(), 0
#         done()
#         return

#     it 'should set data', (done) ->
#         data = 
#             wanted_wei: WANTED_WEI
#             token_amount: 10
#             premium_wei: PREMIUM_WEI
#             token_name: 'SampleContract'
#             token_infolink: 'https://some-sample-ico.network'
#             token_smartcontract_address: tokenAddress
#             days_to_lend: 10
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         # this is set by creator (from within platform)
#         lr.setData data.wanted_wei, data.token_amount, data.premium_wei, data.token_name, data.token_infolink, data.token_smartcontract_address, data.days_to_lend, 0, {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should move to Waiting for tokens state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for tokens" state
#         assert.equal state.toString(), 1
#         done()
#         return

#     it 'should check if tokens are transferred', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.checkTokens {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should not move into <WaitingForLender> state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for tokens" state
#         assert.equal state.toString(), 1
#         done()
#         return

#     it 'should move 10 more token to LR', (done) ->
#         lr = ledgerContract.getLrForUser(borrower, 0)
#         # Borrower -> LR contract
#         token.transfer lr, 10, {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should release tokens back to borrower', (done) ->
#         balance = token.balanceOf(borrower)
#         assert.equal balance, 990
#         a = ledgerContract.getLrForUser(borrower, 0)
#         balance2 = token.balanceOf(a)
#         assert.equal balance2, 10
#         done()
#         return

#     it 'should check again if tokens are transferred', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.checkTokens {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should move into <WaitingForLender> state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for lender" state
#         assert.equal state.toString(), 3
#         done()
#         return

#     it 'should return tokens to founder', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.cancell {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should release tokens back to borrower', (done) ->
#         balance = token.balanceOf(borrower)
#         assert.equal balance, 1000
#         a = ledgerContract.getLrForUser(borrower, 0)
#         balance2 = token.balanceOf(a)
#         assert.equal balance2, 0
#         done()
#         return
#     return

# describe 'Contracts 4 - default', (api)->
#     before 'Initialize everything', (done) ->
#         web3.eth.getAccounts (err, as) ->
#             if err
#                 done err
#                 return
#             accounts = as
#             creator = accounts[0]
#             borrower = accounts[1]
#             feeCollector = accounts[2]
#             lender = accounts[3]
#             contractName = ':Ledger'
#             getContractAbi contractName, (err, abi) ->
#                 ledgerAbi = abi
#                 contractName = ':LendingRequest'
#                 getContractAbi contractName, (err, abi) ->
#                     requestAbi = abi
#                     done()
#                     return
#                 return
#             return
#         return
#     after 'Deinitialize everything', (done) ->
#         done()
#         return

#     it 'should deploy Rep token contract', (done) ->
#         data = {}
#         deployRepContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy ENS contract', (done) ->
#         data = {}
#         deployEnsContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy Ledger contract', (done) ->
#         data = {}
#         deployLedgerContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should update creator', (done) ->
#         data = {}
#         updateRepContractCreator (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should deploy Sample token contract', (done) ->
#         data = {}
#         deployTokenContract data, (err) ->
#             assert.equal err, null
#             done()
#             return
#         return

#     it 'should get initial creator balance', (done) ->
#         initialBalanceCreator = web3.eth.getBalance(creator)
#         console.log 'Creator initial balance is: '
#         console.log initialBalanceCreator.toString(10)
#         done()
#         return

#     it 'should get initial borrower balance', (done) ->
#         initialBalanceBorrower = web3.eth.getBalance(borrower)
#         console.log 'Borrower initial balance is: '
#         console.log initialBalanceCreator.toString(10)
#         done()
#         return

#     it 'should get initial feeCollector balance', (done) ->
#         initialBalanceFeeCollector = web3.eth.getBalance(feeCollector)
#         console.log 'FeeCollector initial balance is: '
#         console.log initialBalanceFeeCollector.toString(10)
#         done()
#         return

#     it 'should get initial lender balance', (done) ->
#         initialBalanceLender = web3.eth.getBalance(lender)
#         console.log 'Lender initial balance is: '
#         console.log initialBalanceLender.toString(10)
#         done()
#         return

#     it 'should get current count of LR', (done) ->
#         count = ledgerContract.getLrCount()
#         assert.equal count, 0
#         done()
#         return

#     it 'should get intial count of LR for borrower', (done) ->
#         count = ledgerContract.getLrCountForUser(borrower)
#         assert.equal count, 0
#         done()
#         return

#     it 'should issue some tokens for me', (done) ->
#         token.issueTokens borrower, 1000, {
#             from: creator
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should return 1000 as a balance', (done) ->
#         balance = token.balanceOf(borrower)
#         assert.equal balance, 1000
#         done()
#         return

#     it 'should issue new LR', (done) ->
#         # 0.2 ETH
#         amount = 200000000000000000
#         web3.eth.sendTransaction {
#             from: borrower
#             to: ledgerContractAddress
#             value: amount
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should get updated count of LR', (done) ->
#         count = ledgerContract.getLrCount()
#         assert.equal count, 1
#         done()
#         return

#     it 'should get updated count of LR for borrower', (done) ->
#         count = ledgerContract.getLrCountForUser(borrower)
#         assert.equal count, 1
#         done()
#         return

#     it 'should get updated feeCollector balance', (done) ->
#         current = web3.eth.getBalance(feeCollector)
#         feeAmount = 10000000000000000
#         diff = current - initialBalanceFeeCollector
#         assert.equal diff.toString(10), feeAmount
#         done()
#         return

#     it 'should get updated borrower balance', (done) ->
#         current = web3.eth.getBalance(borrower)
#         mustBe = 200000000000000000
#         diff = initialBalanceBorrower - current
#         assert.equal diffWithGas(mustBe, diff), true
#         done()
#         return

#     it 'should get LR contract', (done) ->
#         assert.equal ledgerContract.getLrCount(), 1
#         a = ledgerContract.getLr(0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for data" state
#         assert.equal state.toString(), 0
#         done()
#         return

#     it 'should get LR contract for user', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for data" state
#         assert.equal state.toString(), 0
#         done()
#         return

#     it 'should set data', (done) ->
#         data = 
#             wanted_wei: WANTED_WEI
#             token_amount: 10
#             premium_wei: PREMIUM_WEI
#             token_name: 'SampleContract'
#             token_infolink: 'https://some-sample-ico.network'
#             token_smartcontract_address: tokenAddress
#             days_to_lend: 10
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         # this is set by creator (from within platform)
#         lr.setData data.wanted_wei, data.token_amount, data.premium_wei, data.token_name, data.token_infolink, data.token_smartcontract_address, data.days_to_lend, 0, {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should move to Waiting for tokens state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for tokens" state
#         assert.equal state.toString(), 1
#         done()
#         return

#     it 'should check if tokens are transferred', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.checkTokens {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should not move into <WaitingForLender> state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for tokens" state
#         assert.equal state.toString(), 1
#         done()
#         return

#     it 'should move 10 more token to LR', (done) ->
#         lr = ledgerContract.getLrForUser(borrower, 0)
#         # Borrower -> LR contract
#         token.transfer lr, 10, {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should release tokens back to borrower', (done) ->
#         balance = token.balanceOf(borrower)
#         assert.equal balance, 990
#         a = ledgerContract.getLrForUser(borrower, 0)
#         balance2 = token.balanceOf(a)
#         assert.equal balance2, 10
#         done()
#         return

#     it 'should check again if tokens are transferred', (done) ->
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         lr.checkTokens {
#             from: borrower
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should move into <WaitingForLender> state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting for lender" state
#         assert.equal state.toString(), 3
#         done()
#         return

#     it 'should collect money from Lender now', (done) ->
#         current = web3.eth.getBalance(lender)
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         wanted_wei = lr.getNeededSumByLender()
#         amount = wanted_wei
#         # WARNING: see this
#         initialBalanceBorrower = web3.eth.getBalance(borrower)
#         # this should be called by borrower
#         web3.eth.sendTransaction {
#             from: lender
#             to: a
#             value: wanted_wei
#             gas: 2900000
#         }, (err, result) ->
#             assert.equal err, null
#             web3.eth.getTransactionReceipt result, (err, r2) ->
#                 assert.equal err, null
#                 done()
#                 return
#             return
#         return

#     it 'should move to WaitingForPayback state', (done) ->
#         assert.equal ledgerContract.getLrCountForUser(borrower), 1
#         a = ledgerContract.getLrForUser(borrower, 0)
#         lr = web3.eth.contract(requestAbi).at(a)
#         state = lr.getState()
#         # "Waiting For Payback" state
#         assert.equal state.toString(), 4
#         done()
#         return
#     # TODO: now spend some time..
#     # TODO: not working...
#     # it('should request default',function(done){
#     #            var a = ledgerContract.getLrForUser(borrower,0);
#     #            var lr = web3.eth.contract(requestAbi).at(a);
#     #            lr.requestDefault(
#     #                     {
#     #                                from: lender,                             
#     #                                gas: 2900000 
#     #                     },function(err,result){
#     #                                assert.equal(err,null);
#     #                                web3.eth.getTransactionReceipt(result, function(err, r2){
#     #                                         assert.equal(err, null);
#     #                                         done();
#     #                                });
#     #                     }
#     #            );
#     # })
#     # it('should be moved',function(done){
#     #            assert.equal(ledgerContract.getLrCountForUser(borrower),1);
#     #            var a = ledgerContract.getLrForUser(borrower,0);
#     #            var lr = web3.eth.contract(requestAbi).at(a);
#     #            var state = lr.getState();
#     #            // "Default" state
#     #            assert.equal(state.toString(),5);
#     #            done();
#     # })
#     return