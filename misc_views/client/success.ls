Router.route \success path:\/success

template \success -> main_blaze do
	div style:'padding:100px' class:\container ,
		h1 style:'font-size:50px; display:block', 'Done!'
		p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 
			'Please wait. Action will be completed in the next few minutes' 
			# br!
			# if state.get(\show-finished-text) => "#{+state.get(\transact-value)} Credit Tokens (CRE) were transferred to #{state.get \transact-to-address } address. "
			# br!
			# if state.get(\show-finished-text) => "Use CRE to borrow ETH without a collateral."

		button class:'btn btn-primary btn-lg' onclick:'window.history.back()', 'Go back'

