Router.route \loan_request, path:\/loan-request/:id template:\loan_request

template \loan_request -> main_blaze do
    error-component!
    loading-component!

    D "loan-wrapper #{state.get \loan-wrapper-class }",
        D \input-wrapper,
            a target:\__blank class:\loan-title href:"https://etherscan.io/address/#{state.get \address }", "Loan Request  #{state.get \address }"
            input-box!
        block-scheme!

grn-pin =-> img class:"hidden input-img-pin gpin" src:\/img/green_pin.svg alt:''
red-pin =-> img class:"hidden input-img-pin rpin" src:\/img/red_pin.svg   alt:''
red-dot =-> img class:"#{state.get(it+\-rdot )} input-img-dot" src:\/img/red_dot.svg   alt:''     

input-box =~> div class:\input-box, 
    
    input-fields-column!

    div class:\text-aligned,
        if state.get(\lr-State)==0 && state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "Please, enter the data" 
            button class:'card-button bgc-primary loan-button set-data', 'Set data'
        if state.get(\lr-State)==0 && !state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "Borrower should set the data" 
            button class:'card-button bgc-primary loan-button set-data' disabled:true, 'Set data'

        if state.get(\lr-State)==1 && state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "Please, transfer #{ ensQ((state.get('lr').TokenAmount + ' tokens'), \domain) }  to this Loan Request address - #{state.get \address } and click on the button"
            button class:'card-button bgc-primary loan-button transfer-tokens', "Check that #{ ensQ('tokens are', 'domain is') } transferred"
        if state.get(\lr-State)==1 && !state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "Borrower should transfer #{ ensQ((state.get('lr').TokenAmount + ' tokens'), \domain) } to this Loan Request address - #{state.get \address }"
            button class:'card-button bgc-primary loan-button transfer-tokens' disabled:true, "Check that #{ensQ(\tokens \domain)} are transferred"

        if state.get(\lr-State)==3 && !state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text",      
                'Fund this Loan Request and get Premium'
            button class:'card-button bgc-primary loan-button lender-pay' style:'width:200px; margin-left:-15px', "Fund this Loan Request"

        if state.get(\lr-State)==3 && state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", 
                "Please wait while someone lend your Loan Request. You can cancel this loan request."

            button class:'card-button bgc-primary loan-button borrower-cancel' style:'width:200px; margin-left:-15px', "Cancel"

        if state.get(\lr-State)==4 && state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", 
                "To return #{ensQ(\tokens \domain 'the loan')} please send #{bigNum-toStr(state.get(\NeededSumByBorrower))} Eth to #{state.get \address }. This includes #{bigNum-toStr state.get(\lr).PremiumWei} Eth premium amount"
                br!
                "Borrower is rewarded with #{+bigNum-toStr-div10(state.get(\lr)?WantedWei)} Credit Tokens (CRE) after the repayment."
            button class:'card-button bgc-primary loan-button return-tokens', "Return #{ensQ(\tokens \domain \loan)}"
        if state.get(\lr-State)==4 && !state.get(\IamBorrower) && !state.get(\IamLender) => D \text-s,
            D "loan-prebutton-text", "Borrower should now return #{bigNum-toStr state.get(\NeededSumByBorrower)} Eth in order to get #{ensQ(\tokens \domain 'the loan')} back"
            button class:'card-button bgc-primary loan-button return-tokens' disabled:true, 'Return tokens'
        if state.get(\lr-State)==4 && state.get(\IamLender) => D \text-s,
            D "loan-prebutton-text", "If time has passed but borrower hasn't returned the loan - you can #{ensQ('get his tokens' 'get his domain' 'burn his credit' )}"
            button class:'card-button bgc-primary loan-button get-tokens', ensQ('Get tokens' 'Get domain' 'Burn borrowers CRE')

block-scheme =-> D \block-scheme,
    D "block-scheme-element #{highlightQ(0)}", 'No data'
    D \block-scheme-line,
        P \block-scheme-line-inscription, "Borrower ", br!, 'sets data'
        D \block-scheme-line-arrow
    unless state.get(\lr)?isRep => D "block-scheme-element #{highlightQ(1)}", ensQ('Waiting for tokens', 'Waiting For domain')
    unless state.get(\lr)?isRep => D \block-scheme-line,
        P \block-scheme-line-inscription, "Borrower transfers", br!,  ensQ(\tokens \domain)
        D \block-scheme-line-arrow
    D "block-scheme-element #{highlightQ(3)}", 'Waiting For Lender'
    D \block-scheme-line,
        P \block-scheme-line-inscription, "Lender sends ", br!, \ETH
        D \block-scheme-line-arrow
    D "block-scheme-element #{highlightQ(4)}", \Funded
    D 'block-scheme-line block-scheme-line-long',
        p class:\block-scheme-line-inscription, 'Borrower gets ',  ensQ('his tokens back +' 'his domain back +', ''), br!, 'Credit Tokens (CRE)'
        p class:'block-scheme-line-inscription block-scheme-line-inscription-second' , "Lender gets Eth amount"
        D 'block-scheme-line-arrow block-scheme-line-arrow-long'
    D "#{highlightQ(6)} block-scheme-element #{if state.get(\lr-State)!=6 => \block-scheme-element-success }", \Finished
  
    div class:'block-scheme-line block-scheme-line-long block-scheme-line-long-branch' style:"#{if state.get(\lr)?isRep=> \top:240px }",
        P 'block-scheme-line-inscription block-scheme-line-inscription-branch', ensQ('Lender gets tokens' 'Lender gets domain' 'Lender burns borrowers CRE (reputation)')
        div class:'block-scheme-line-arrow block-scheme-line-arrow-branch'
    div class:"#{highlightQ(5)} block-scheme-element block-scheme-element-branch #{if state.get(\lr-State)!=5 => \block-scheme-element-failure else \failure-highlighted }" style:"#{if state.get(\lr)?isRep=> \top:379px }", \Default


Template.loan_request.created=->
    state.set \selected-class \loan
    map state-null, [
        *\lr-WantedWei
        *\lr-DaysToLen
        *\lr-TokenAmount
        *\lr-PremiumWei
        *\lr-TokenName
        *\lr-Borrower
        *\lr-Lender
        *\lr-TokenSmartcontractAddress
        *\lr-TokenInfoLink
        *\lr-isE
    ]    

    state.set \address     (Router.current!originalUrl |> split \/ |> last )
    state.set \loan-wrapper-class, \hidden
    state.set \loading-class,      ''
    state.set \error-class, (if EthQ(state.get(\address))=>\hidden else '' )

    lr.getNeededSumByLender(state.get \address ) (err,res)->   
        state.set \NeededSumByLender res
      
        lr.getNeededSumByBorrower(state.get \address ) (err,res)-> 
            state.set \NeededSumByBorrower res

            ledger.getFeeSum (err, res)->
                if err => return err 
                # fee-sum = lilNum-toStr res
                state.set \fee-sum res

                get-all-lr-data( state.get \address ) ->
                      
                    state.set \loan-wrapper-class, ''
                    state.set \loading-class, \hidden
                    &1.isToken = (!&1?isEns)&&(!&1?isRep)
                    state.set \lr, &1
                    state.set \lr-Lender   &1?Lender
                    state.set \lr-Borrower &1?Borrower
                    state.set \lr-State    &1?State
                    state.set \IamLender   (web3.eth.defaultAccount.toUpperCase()==state.get(\lr-Lender).toUpperCase())       


                    state.set \IamBorrower (web3.eth.defaultAccount.toUpperCase()==state.get(\lr-Borrower).toUpperCase())   

                    get-rep-balance (state.get \lr)?Borrower, (err,res)->
                        $('.bor-balance').attr \value, +bigNum-toStr(res)
                        state.set \bor-balance bigNum-toStr(res)

Template.loan_request.rendered =->
    # $(\.set-data).attr \disabled, \disabled
    if bigNum-toStr(state.get(\lr)?WantedWei)   !=\0 =>        $('.lr-WantedWei').attr \value,                  bigNum-toStr state.get(\lr)?WantedWei
    if state.get(\lr)?DaysToLen                 != 0 =>        $('.lr-DaysToLen').attr \value,                  state.get(\lr)?DaysToLen
    if state.get(\lr)?TokenAmount               != 0 =>        $('.lr-TokenAmount').attr \value,                state.get(\lr)?TokenAmount
    if bigNum-toStr(state.get(\lr)?PremiumWei)  !=\0 =>       $('.lr-PremiumWei').attr \value,                  bigNum-toStr state.get(\lr)?PremiumWei
    if state.get(\lr)?Borrower                  != big-zero => $('.lr-Borrower').attr \value,                   state.get(\lr)?Borrower
    if state.get(\lr)?Lender                    != big-zero => $('.lr-Lender').attr \value,                     state.get(\lr)?Lender
    if state.get(\lr)?TokenSmartcontractAddress != big-zero => $('.lr-TokenSmartcontractAddress').attr \value,  state.get(\lr)?TokenSmartcontractAddress
    
    if state.get(\lr)?EnsDomainHash             != sha-zero => $('.lr-ensDomain').attr \value,                  state.get(\lr)?EnsDomainHash

    $('.lr-TokenName').attr \value,     state.get(\lr)?TokenName
    $('.lr-TokenInfoLink').attr \value, state.get(\lr)?TokenInfoLink       

            
Template.loan_request.events do 
    'click .set-data':-> 
        out = {}
        out.ethamount = eth-to-wei $(\.lr-WantedWei).val!
        out.days      = $(\.lr-DaysToLen).val!
        out.premium   = eth-to-wei $(\.lr-PremiumWei).val!
        out.bor       = $(\.lr-Borrower).val!
        out.len       = $(\.lr-Lender).val!

        out.tokamount = $(\.lr-TokenAmount).val!   || 0
        out.tokname   = $(\.lr-TokenName).val!    || ''
        out.smart     = $(\.lr-TokenSmartcontractAddress).val! || 0
        out.link      = $(\.lr-TokenInfoLink).val! || ''

        out.ensDomainHash = $(\.lr-ensDomain).val! || 0


        console.log \out: out
        lr.setData(state.get \address )(
            out.ethamount,
            out.tokamount,                    
            out.premium,             
            out.tokname,            
            out.link,
            out.smart,
            out.days, 
            out.ensDomainHash,
            goto-success-cb
        )  


    'click .lender-pay':-> 
        console.log \NeededSumByLender: lilNum-toStr state.get(\NeededSumByLender)  
        transact = {
            gasPrice: 200000000000
            from:  web3.eth.defaultAccount
            to:    state.get(\address)
            value: lilNum-toStr state.get(\NeededSumByLender)
        }
        console.log \transact: transact
        web3.eth.sendTransaction transact, goto-success-cb

    'click .borrower-cancel':-> 
        lr.returnTokens(state.get(\address)) goto-success-cb

    'click .transfer-tokens':->
        if state.get(\lr)?isEns == false
            lr.checkTokens(state.get(\address)) goto-success-cb
        if state.get(\lr)?isEns
            # lr.checkDomain(state.get(\address)) goto-success-cb
            web3.eth.contract(config.LRABI).at(state.get(\address)).checkDomain({from:web3.eth.defaultAccount,  gasPrice:20000000000}, goto-success-cb)





    'click .return-tokens':->
        transact = {
            from:  web3.eth.defaultAccount
            to:    state.get(\address)
            value: +lilNum-toStr state.get(\NeededSumByBorrower)
            #             gasPrice:150000000000
        }
        console.log \transact: transact
        
        state.set \transact-to-address state.get(\address)
        state.set \transact-value bigNum-toStr state.get(\NeededSumByBorrower)
        state.set \show-finished-text true
        web3.eth.sendTransaction transact, goto-success-cb




    'click .get-tokens':->
        lr.requestDefault(state.get(\address)) goto-success-cb


    'input .input':~> 
        $T = $(event.target)
        name = $T.attr \ident
        test =~> 
            if it is true
                $T.parents(\section).find(\.gpin).remove-class(\hidden)
                $T.parents(\section).find(\.rpin).add-class(\hidden)
                state.set("#{name}-rpin" true); state.set("#{name}-gpin" false)
            else 
                $T.parents(\section).find(\.gpin).add-class(\hidden)
                $T.parents(\section).find(\.rpin).remove-class(\hidden)
            return 

        cls = $T.attr(\class) |> split ' ' |> last

        
        if cls==\lr-TokenAmount && state.get(\lr)?isToken => test IntQ $T.val!
        if cls==\lr-TokenName   && state.get(\lr)?isToken => test $T.val!length > 0
        if cls==\lr-ensDomain   && state.get(\lr)?isEns   => test ShaQ $T.val!
        if cls==\lr-TokenSmartcontractAddress && state.get(\lr)?isToken => test EthQ $T.val!
       
        if cls==\lr-WantedWei   => test IntQ $T.val!
        if cls==\lr-DaysToLen   => test IntQ $T.val!
        if cls==\lr-PremiumWei  => test IntQ $T.val!
        

        if Everything_is_ok! => $(\.set-data).remove-attr \disabled
        else $(\.set-data).attr \disabled, \disabled

    'keydown .block-input':-> event.prevent-default!


Everything_is_ok=->
    ok = true
    test =-> if it is false => ok := false

    for el in $(\.input)
        cls = $(el).attr(\class) |> split ' ' |> last
        
        if cls==\lr-WantedWei   => test IntQ $(el).val!
        if cls==\lr-DaysToLen   => test IntQ $(el).val!
        if cls==\lr-TokenAmount && state.get(\lr)?isEns == false => test IntQ $(el).val!
        if cls==\lr-TokenName   && state.get(\lr)?isEns == false => test $(el).val!length > 0
        if cls==\lr-ensDomain   && state.get(\lr)?isEns == true  => test ShaQ $(el).val!
        if cls==\lr-PremiumWei  => test IntQ $(el).val!
        if cls==\lr-TokenSmartcontractAddress && state.get(\lr)?isEns == false => test EthQ $(el).val!
        console.log cls, \ok:, ok
    ok

check-set-data-out =(out,cb)->  # TODO: check set-data 
    cb(null, out)

set-data-cb =(err,res)->
    # location.reload!
    res                  

@disableQ =-> (!state.get(\IamBorrower) || !!state.get(\lr-State))

@highlightQ =-> 
    if it is state.get \lr-State then \block-scheme-element-highlighted else ''
    if it is state.get \lr-State then \block-scheme-element-highlighted else ''

input-fields-column =->
    field-array = []
    rep = state.get(\bor-balance)

    if (not state.get(\lr)?isEns) && (not state.get(\lr)?isRep)
        field-array.push c:'lr-WantedWei'                                     n:'Eth amount'                 d:disableQ!, placeholder:'0.00 Eth'     
        field-array.push c:'lr-TokenName'   n:'Token name'       d:disableQ!                                
        field-array.push c:'lr-TokenAmount' n:'Token amount'     d:disableQ!, placeholder:'0'      
        field-array.push c:'input-primary-short lr-TokenSmartcontractAddress' n:'Token smart contract'       d:disableQ!                                      
        field-array.push c:'lr-TokenInfoLink'                                 n:'Token info link (optional)' d:disableQ!

    if (state.get(\lr)?isEns)
        field-array.push c:'lr-WantedWei'                                     n:'Eth amount'                 d:disableQ!, placeholder:'0.00 Eth'     
        field-array.push c:'lr-ensDomain'   n:'ENS Domain Hash'  d:disableQ!                                
  
    if (state.get(\lr)?isRep)
        field-array.push c:'lr-WantedWei block-input'   n:'Eth amount'       d:disableQ!, placeholder:'0.00 Eth' type:\number step:0.01, maxi:(+rep), mini:0, v:(+bigNumToStr(state.get('lr').WantedWei)||rep)
  

    
    field-array.push c:'lr-DaysToLen'                                     n:'Days to lend'               d:disableQ!                                      
    field-array.push c:'lr-PremiumWei'                                    n:'Premium amount'             d:disableQ!, placeholder:'0.00 Eth'       
    field-array.push c:'lr-Borrower input-primary-short'                  n:'Borrower'                   d:true       red-dot:state.get(\IamBorrower)
    field-array.push c:'bor-balance input-primary-short'                  n:'Borrower reputation'        d:true       red-dot:state.get(\IamBorrower)
    field-array.push c:'lr-Lender input-primary-short'                    n:'Lender'                     d:true       red-dot:state.get(\IamLender)

    map input-unit, field-array

input-unit =-> section style:'height:36px',
    h3 class:\input-key, 
        if it.red-dot   => red-dot!
        it.n
    input id:it.ident, type:it?type||\text, step:it?step, max:it?maxi, min:it?mini, ident:it.ident, style:'max-height:40px' class:"input #{it?c||''}" placeholder:it?placeholder, value:it?v, disabled:it.d
    grn-pin!       
    red-pin!      

        
        
@ensQ =-> 
    if state.get(\lr)?isToken => &0
    else if state.get(\lr)?isEns => &1
    else &2