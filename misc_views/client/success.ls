Router.route \success path:\/success

template \success -> main_blaze do
	div style:'padding:100px' class:\container ,
		h1 style:'font-size:50px; display:block', 'Done!'
		p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 'Please wait. Action will be completed in the next few minutes'
		# a class:'btn btn-primary btn-lg' href:'https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn', 'Download Metamask'

