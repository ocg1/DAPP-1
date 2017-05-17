Router.route \faq path:\/faq

template \faq -> main_blaze do
	div style:'padding:100px' class:\container ,
		h1 style:'font-size:50px; display:block', 'FAQ'
		p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 
			replicate 10 p 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.'
