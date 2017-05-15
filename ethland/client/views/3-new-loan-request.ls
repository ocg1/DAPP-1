Router.route \new_loan_request, path:\new-loan-request template:\newLoanRequest

template \newLoanRequest -> main_blaze do
    loading-component!
    div class:"message #{state.get \message-class }",
        p style:\font-size:20px,
            "This includes " b "#{state.get(\fee-sum)/10^18} ETH"; " platform fees and can take 3-5 minutes"

        p style:\font-size:20px,
            'New ' b 'Loan Request'; ' will be then available in ’All Loan Requests’ window.'
        button class:'new-loan-request', 'New loan request'

Template.newLoanRequest.events do
    'click .new-loan-request':->

        transact = {
            from:  web3.eth.defaultAccount
            to:    config.ETH_MAIN_ADDRESS
            value: state.get(\fee-sum)
            gas:   2900000
        }
        web3.eth.sendTransaction transact, (err,res)-> 
            if err => console.log \err:   err
            if res => console.log \thash: res


Template.newLoanRequest.created =->
    state.set \message-class \hidden
    state.set \loading-class ''
        
Template.newLoanRequest.rendered =~>
    ledger.getFeeSum (err, res)~>
        if err => return err 
        fee-sum = convert-big-number res
        state.set \fee-sum fee-sum
        state.set \message-class ''
        state.set \loading-class \hidden
