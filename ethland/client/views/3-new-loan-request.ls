Router.route \new_loan_request, path:\new-loan-request template:\newLoanRequest

template \newLoanRequest -> main_blaze D \message,

    button class:'new-loan-request', 'New loan request'

    p style:\font-size:20px,
        "This includes " b '0.2 ETH'; " platform fees and can take 3-5 minutes"

    p style:\font-size:20px,
        'New ' b 'Loan Request'; ' will be then available in ’All Loan Requests’ window'



Template.newLoanRequest.events do
    'click .new-loan-request':->

        transact = {
            from:  web3.eth.defaultAccount
            to:    config.ETH_MAIN_ADDRESS
            value: 200000000000000000
            gas:   2900000
        }
        web3.eth.sendTransaction transact, (err,res)-> 
            if err => console.log \err:   err
            if res => console.log \thash: res
        




# Template.newLoanRequest.events do
#     'click .new-loan-request':->
#         transact = {
#             from:   web3.eth.defaultAccount
#             to:     config.ETH_MAIN_ADDRESS
#             value:  500000
#         }
#         console.log transact
#         web3.eth.sendTransaction transact, (err,res)-> 
#             if err => alert err
#             if res => Router.go \/loan-request/ + res
        
