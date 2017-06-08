Router.route \new_loan_request, path:\new-loan-request template:\newLoanRequest

template \newLoanRequest -> main_blaze do
    loading-component!
    div class:"message #{state.get \message-class }",
        p style:\font-size:20px,
            "This includes " b "#{state.get(\fee-sum)/10^18} ETH"; " platform fees and can take 3-5 minutes"

        p style:\font-size:20px,
            'New ' 
            b 'Loan Request'
            ' will be then available in ’All Loan Requests’ window.'
            br!
            "Credit Tokens (CRE) are credited to the borrower and the lender on successful loan"
            br!
            "repayment (Loan amount of 1 ETH = 0.1 CRE). CRE represents the borrower’s credit rating. "
            br!
            "Pledge CRE to spare other tokens."
        button class:'new-loan-request card-button bgc-primary', 'New loan request'





Template.newLoanRequest.events do
    'click .new-loan-request':->

        transact = {
            from:  web3.eth.defaultAccount
            to:    config.ETH_MAIN_ADDRESS
            value: state.get(\fee-sum)
        }
        web3.eth.sendTransaction transact, (err,res)-> 
            if err => console.log \err:   err
            if res 
                console.log \thash: res
                state.set \transact-to-address config.ETH_MAIN_ADDRESS
                state.set \transact-value      state.get(\fee-sum)
                Router.go \success

Template.newLoanRequest.created =->
    state.set \selected-class \new-loan
    state.set \message-class \hidden
    state.set \loading-class ''
        
Template.newLoanRequest.rendered =~>
    ledger.getFeeSum (err, res)~>
        if err => return err 
        fee-sum = lilNum-toStr res
        state.set \fee-sum fee-sum
        state.set \message-class ''
        state.set \loading-class \hidden
