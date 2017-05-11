template \reload -> main_blaze do
	div style:'padding:100px' class:\container ,
		h1 style:'font-size:50px; display:block', 'Can not get account address'
		p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 'Please, enter password in the Metamask, or reload page.'
		button class:'btn btn-danger btn-lg' onclick:'location.reload()', 'Reload page'
