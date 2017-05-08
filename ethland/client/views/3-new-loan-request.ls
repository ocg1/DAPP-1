Router.route \new_loan_request, path:\new-loan-request template:\newLoanRequest

template \newLoanRequest -> main_blaze D \message,

    p style:\font-size:20px,
        "This includes "
        b {}, \100000050000000
        " platform fees."

    p style:\font-size:20px,
        "New "
        b {}, "Loan Request"
        " will be then available in ’All Loan Requests’."
        br! 
    "  (can take 3-5 minutes)"
    br! 
    br! 
    button class:'new-loan-request', "  New loan request",



Template.newLoanRequest.events do
    'click .new-loan-request':->
        transact = {
            from:'0x30B3BCCAA8F8fDbc5e9591fe8e7385A3B6b8e03a'
            to:'0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7'
            value:5000000
        }
        web3.eth.sendTransaction transact, (err,res)-> 
            if err => alert err
            if res => Router.go \/loan-request/ + res
        

# <div class="message">
#     <p class="message-text">
        # <!-- react-text: 19 -->
        #     This includes <b>223473000000000000<!-- /react-text --><!-- react-text: 22 --> Wei<!-- /react-text --></b><!-- react-text: 23 --> platform fees.<!-- /react-text --><br><!-- react-text: 25 -->New <!-- /react-text --><b>Loan Request</b><!-- react-text: 27 --> will be then available in ’All Loan Requests’<!-- /react-text --></p><p class="message-text-small">(can take 3-5 minutes)</p><button>New Loan Request</button></div>