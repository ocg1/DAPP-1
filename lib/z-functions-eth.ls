@lr     = call:(method)~>(address)~>(...args)-> web3?eth.contract(config.LR-ABI).at(address)[method](...args)
@ledger = call:(method)~>(...args)~> web3?eth.contract(config.LEDGER-ABI).at(config.ETH_MAIN_ADDRESS)[method](...args)
@init   = (obj)~> (method)~> obj[method] = obj[\call](method)

map init(ledger), [ 
	\Ledger 						#1. (address whereToSendFee_)
	\createNewLendingRequest 		#2. payable byAnyone returns(address out)
	\getFeeSum 						#3. constant returns(uint out)
	\getLrCount 					#4. constant returns(uint out)
	\getLr 							#5. constant returns (address out)
	\getLrCountForUser 				#6. (address a)constant returns(uint out)
	\getLrForUser 					#7. (address a,uint index) constant returns (address out)
	\payable                        #8. when recieve money -> NewLendingRequest()
	\getLrFundedCount				#9. same
	\getLrFunded 				    #10.same
	\getRepTokenAddress             #11.
	\createNewLendingRequestEns     #12.
]

map init(lr), [ 
	\getBorrower                  # 1.
	\getWantedWei                 # 2.
	\getPremiumWei                # 3.
	\getTokenAmount               # 4.
	\getTokenName                 # 5.
	\getTokenInfoLink             # 6.
	\getTokenSmartcontractAddress # 7.
	\getDaysToLen                 # 8.
	\getState                     # 9.
	\getLender                    # 10.
	\isEns                        # 11.
	\getEnsDomainHash             # 12.
	\changeLedgerAddress          # 13.
	\changeMainAddress            # 14.
	\setData                      # 15.
	\cancell                      # 16.
	\checkTokens                  # 17.
	\checkDomain                  # 18.
	\returnTokens                 # 19.
	\waitingForLender             # 20.
	\waitingForPayback            # 21.
	\getNeededSumByLender         # 22.
	\getNeededSumByBorrower       # 23.
	\requestDefault               # 24.
	\releaseToLender              # 25.
	\releaseToBorrower            # 26.
	\isRep			              # 27.
]

@get-all-lr-data =(address)->(cb)->
	out = {}
	lr.getWantedWei(address) ->  				out.WantedWei = &1    
	lr.getPremiumWei(address) -> 				out.PremiumWei = &1
	lr.getTokenName(address) ->                 out.TokenName = &1
	lr.getTokenInfoLink(address) -> 			out.TokenInfoLink = &1
	lr.getTokenSmartcontractAddress(address) -> out.TokenSmartcontractAddress = &1
	lr.getBorrower(address) -> 					out.Borrower = &1
	lr.getDaysToLen(address) -> 				out.DaysToLen = +lilNum-toStr &1
	lr.getState(address) -> 					out.State = +lilNum-toStr &1
	lr.getLender(address) -> 					out.Lender = &1
	lr.getTokenAmount(address) -> 				out.TokenAmount = +lilNum-toStr &1
	lr.isEns(address) ->						out.isEns = &1
	lr.isRep(address) ->						out.isRep = &1
	lr.getEnsDomainHash(address) ->				out.EnsDomainHash = &1

	cycle =-> 
		if typeof out.WantedWei ==\undefined  || typeof out.PremiumWei ==\undefined || typeof out.TokenName ==\undefined || typeof out.TokenInfoLink ==\undefined || typeof out.TokenSmartcontractAddress ==\undefined || typeof out.Borrower ==\undefined || typeof out.DaysToLen ==\undefined || typeof out.State ==\undefined || typeof out.Lender ==\undefined || typeof out.TokenAmount ==\undefined || typeof out.isEns == \undefined || typeof out.EnsDomainHash == \undefined
			Meteor.setTimeout (->cycle!), 10
		else cb null, out

	cycle!

@get-rep-balance =(address,cb)-> ledger.getRepTokenAddress (err,repAddress)->
	contr = web3?eth.contract(config.REP-ABI).at(repAddress)
	contr.balanceOf address, cb
