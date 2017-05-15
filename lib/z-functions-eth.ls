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
]

# createNewLendingRequest =-> ledger.createNewLendingRequest({
#             from:  web3.eth.defaultAccount
#             to:    config.ETH_MAIN_ADDRESS
#             value: 200000000000000000
#             gas:   2900000
#         },conscb)

@get-all-lr-data =(address)->(cb)-> #TODO: надо будет параллельно обрабатывать эти запросы.
	out = {}
	lr.getWantedWei(address) ->  
		out.WantedWei = &1.c.0       
		lr.getPremiumWei(address) ->
			out.PremiumWei = &1.c.0
			lr.getTokenName(address) ->
				out.TokenName = &1
				lr.getTokenInfoLink(address) ->
					out.TokenInfoLink = &1
					lr.getTokenSmartcontractAddress(address) ->
						out.TokenSmartcontractAddress = &1
						lr.getBorrower(address) ->
							out.Borrower = &1
							lr.getDaysToLen(address) ->
								out.DaysToLen = &1.c.0
								lr.getState(address) ->
									out.State = &1.c.0
									lr.getLender(address) ->
										out.Lender = &1
										lr.getTokenAmount(address) ->
											out.TokenAmount = &1.c.0;
											cb(null,out)



# TODO: Как получать funded-loan-request`ы? Нужен метод, который возвращает массив вида [1, 12, 14, 57, ...]
# 		то есть те номера lr, которые funded. Нужно передеплоить контракт, видимо.