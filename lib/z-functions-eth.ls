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
]

map init(lr), [ 
	\getWantedWei                   #1.  constant returns (_ out)         
	\getPremiumWei                  #2.  constant returns (_ out)          
	\getTokenName                   #3.  constant returns (_ out)         
	\getTokenInfoLink               #4.  constant returns (_ out)             
	\getTokenSmartcontractAddress   #5.  constant returns (_ out)                         
	\getBorrower                    #6.  constant returns (_ out)        
	\getDaysToLen                   #7.  constant returns (_ out)         
	\getState                       #8.  constant returns (_ out)     
	\getLender                      #9.  constant returns (_ out)
	\getTokenAmount					#10. constant returns (_ out)
	\LendingRequest                 #11. (address mainAddress_,address borrower_,address whereToSendFee_)!->      
	\changeLedgerAddress            #12. (address new_)onlyByLedger
	\changeMainAddress              #13. (address new_)onlyByMain
	\setData                        #14. (uint wanted_wei_, uint token_amount_, uint premium_wei_, string token_name_, string token_infolink_, address token_smartcontract_address_, uint days_to_lend_) byLedgerMainOrBorrower onlyInState(State.WaitingForData)
	\cancell                        #15. byLedgerMainOrBorrower
	\checkTokens                    #16. byLedgerMainOrBorrower onlyInState(State.WaitingForTokens)
	\waitingForLender               #17. payable onlyInState(State.WaitingForLender)
	\waitingForPayback              #18. payable onlyInState(State.WaitingForPayback)
	\getNeededSumByLender           #19. constant returns(uint out)
	\getNeededSumByBorrower         #20. constant returns(uint out)
	\requestDefault                 #21. onlyByLender onlyInState(State.WaitingForPayback)
	\returnTokens                   #22.
]

@get-all-lr-data =(address)->(cb)-> #TODO: parallel it
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
	
	cycle =-> 
		if typeof out.WantedWei ==\undefined  || typeof out.PremiumWei ==\undefined || typeof out.TokenName ==\undefined || typeof out.TokenInfoLink ==\undefined || typeof out.TokenSmartcontractAddress ==\undefined || typeof out.Borrower ==\undefined || typeof out.DaysToLen ==\undefined || typeof out.State ==\undefined || typeof out.Lender ==\undefined || typeof out.TokenAmount ==\undefined
			Meteor.setTimeout (->( console.log \loading...; cycle!)), 10
		else cb null, out

	cycle!
	# console.log \out.WantedWei:	out.WantedWei
	# console.log \out.PremiumWei:	out.PremiumWei 
	# console.log \out.TokenName:	out.TokenName 
	# console.log \out.TokenInfoLink:	out.TokenInfoLink 
	# console.log \out.TokenSmartcontractAddress:	out.TokenSmartcontractAddress 
	# console.log \out.Borrower:	out.Borrower 
	# console.log \out.DaysToLen:	out.DaysToLen 
	# console.log \out.State:	out.State 
	# console.log \out.Lender:	out.Lender 
	# console.log \out.TokenAmount:	out.TokenAmount 
	# unless 
	

@get-rep-balance =(address,cb)-> ledger.getRepTokenAddress (err,repAddress)->
	contr = web3?eth.contract(config.REP-ABI).at(repAddress)
	contr.balanceOf address, cb
