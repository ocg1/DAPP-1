
@get-mock-data =->
	id:		 		Math.random!
	amount:		 	100*Math.random!
	inscription:	\898323223
	borrower:		\0x + get-id!
	lender:		 	\0x + get-id!
	state:		 	\funded
	created:		\2017/04/24

@get-mock-data-arr =-> [get-mock-data! for n from 1 to 20]