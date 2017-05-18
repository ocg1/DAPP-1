Router.route \loan_request, path:\/loan-request/:id template:\loan_request

template \loan_request -> main_blaze do
    error-component!
    loading-component!

    D "loan-wrapper #{state.get \loan-wrapper-class }",
        D \input-wrapper,
            a target:\__blank class:\loan-title href:"https://kovan.etherscan.io/address/#{state.get \address }", "Loan Request  #{state.get \address }"
            input-box!
        block-scheme!

grn-pin   =-> img class:"hidden input-img-pin gpin" src:\/img/green_pin.svg alt:''
red-pin   =-> img class:"hidden input-img-pin rpin" src:\/img/red_pin.svg   alt:''
red-dot   =-> img class:"#{state.get(it+\-rdot )} input-img-dot" src:\/img/red_dot.svg   alt:''

input-unit =-> section style:'height:40px',
    h3 class:\input-key, 
        if it.red-dot   => red-dot!
        it.n
    input id:it.ident, ident:it.ident, style:'max-height:40px' class:"input #{it?c||''}" placeholder:it?placeholder, value:it?v, disabled:it.d
    grn-pin!       
    red-pin!          

input-box =~> div class:\input-box, 
    map input-unit, [
        *c:'lr-WantedWei'                                     n:'Eth amount'                 d:disableQ!, placeholder:'0.00 Eth',       
        *c:'lr-DaysToLen'                                     n:'Days to lend'               d:disableQ!,                                
        *c:'lr-TokenAmount'                                   n:'Token amount'               d:disableQ!, placeholder:'0',       
        *c:'lr-PremiumWei'                                    n:'Premium amount'             d:disableQ!, placeholder:'0.00 Eth',       
        *c:'lr-TokenName'                                     n:'Token name'                 d:disableQ!,                                
        *c:'lr-Borrower input-primary-short'                  n:'Borrower'                   d:true       red-dot:state.get(\IamBorrower),
        *c:'lr-Lender input-primary-short'                    n:'Lender'                     d:true       red-dot:state.get(\IamLender),  
        *c:'input-primary-short lr-TokenSmartcontractAddress' n:'Token smart contract'       d:disableQ!                                      
        *c:'lr-TokenInfoLink'                                 n:'Token info link (optional)' d:disableQ!,                                
    ]
    div class:\text-aligned,
        if state.get(\lr-State)==0 && state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "Please, enter the data" 
            button class:'card-button bgc-primary loan-button set-data', 'Set data'
        if state.get(\lr-State)==0 && !state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "Borrower should set the data" 
            button class:'card-button bgc-primary loan-button set-data' disabled:true, 'Set data'

        if state.get(\lr-State)==1 && state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "Please, transfer #{state.get('lr').TokenAmount } tokens to this Loan Request address - #{state.get \address } and click on Tokens Transferred button"
            button class:'card-button bgc-primary loan-button transfer-tokens', 'Check that tokens are transferred'
        if state.get(\lr-State)==1 && !state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "Borrower should transfer #{state.get('lr').TokenAmount } tokens to this Loan Request address - #{state.get \address }"
            button class:'card-button bgc-primary loan-button transfer-tokens' disabled:true, 'Check that tokens are transferred'

        if state.get(\lr-State)==3 && !state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", 
                "Please send #{bigNum-add(state.get('lr').WantedWei, state.get(\NeededSumByLender))} Eth to #{state.get \address }"
                br!
                "to fund this Loan Request. This includes #{bigNum-toStr state.get(\NeededSumByLender)||'xxx' } Eth platform fee."

            button class:'card-button bgc-primary loan-button lender-pay' style:'width:200px; margin-left:-15px', "Fund this Loan Request"

        if state.get(\lr-State)==4 && state.get(\IamBorrower) => D \text-s,
            D "loan-prebutton-text", "To return tokens please send #{bigNum-add(state.get('lr').WantedWei, state.get(\NeededSumByLender))} Eth to #{state.get \address }. This includes #{bigNum-toStr state.get(\NeededSumByLender)} Eth premium"
            button class:'card-button bgc-primary loan-button return-tokens', 'Return tokens'
        if state.get(\lr-State)==4 && !state.get(\IamBorrower) && !state.get(\IamLender) => D \text-s,
            D "loan-prebutton-text", "Borrower should now return #{bigNum-add(state.get('lr').WantedWei, state.get(\NeededSumByLender))} Eth in order to return tokens back"
            button class:'card-button bgc-primary loan-button return-tokens' disabled:true, 'Return tokens'
        if state.get(\lr-State)==4 && state.get(\IamLender) => D \text-s,
            D "loan-prebutton-text", "If time has passed but borrower hasn't returned the loan - you can get his tokens"
            button class:'card-button bgc-primary loan-button get-tokens', 'Get tokens'

block-scheme =-> D \block-scheme,
    D "block-scheme-element #{highlightQ(0)}", 'No data'
    D \block-scheme-line,
        P \block-scheme-line-inscription, "Borrower ", br!, 'sets data'
        D \block-scheme-line-arrow
    D "block-scheme-element #{highlightQ(1)}", 'Waiting For Tokens'
    D \block-scheme-line,
        P \block-scheme-line-inscription, "Borrower transfers ", br!, \tokens
        D \block-scheme-line-arrow
    D "block-scheme-element #{highlightQ(3)}", 'Waiting For Lender'
    D \block-scheme-line,
        P \block-scheme-line-inscription, "Lender sends ", br!, \money
        D \block-scheme-line-arrow
    D "block-scheme-element #{highlightQ(4)}", \Funded
    D 'block-scheme-line block-scheme-line-long',
        P \block-scheme-line-inscription, 'Borrower gets his', br!, 'tokens back'
        P 'block-scheme-line-inscription block-scheme-line-inscription-second', "Lender gets money + ", br!, \premium
        D 'block-scheme-line-arrow block-scheme-line-arrow-long'
    D "#{highlightQ(5)} block-scheme-element #{if state.get(\lr-State)!=5 => \block-scheme-element-success}", \Finished
    D 'block-scheme-line block-scheme-line-long block-scheme-line-long-branch',
        P 'block-scheme-line-inscription block-scheme-line-inscription-branch', 'Lender gets', br!, \tokens
        div class:'block-scheme-line-arrow block-scheme-line-arrow-branch'
    D "#{highlightQ(2)} block-scheme-element block-scheme-element-branch #{if state.get(\lr-State)!=2 => \block-scheme-element-failure else \failure-highlighted }", \Default


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
    ]    

    state.set \address     (Router.current!originalUrl |> split \/ |> last )
    state.set \loan-wrapper-class, \hidden
    state.set \loading-class,      ''
    state.set \error-class, (if EthQ(state.get(\address))=>\hidden else '' )

    lr.getNeededSumByLender(state.get \address )((err,res)->   
        state.set \NeededSumByLender res
        get-all-lr-data( state.get \address ) ->
       
            state.set \loan-wrapper-class, ''
            state.set \loading-class, \hidden
            state.set \lr, &1
            state.set \lr-Lender   &1?Lender
            state.set \lr-Borrower &1?Borrower
            state.set \lr-State    &1?State
            state.set \IamLender   (state.get(\defaultAccount)==state.get(\lr-Lender))       
            state.set \IamBorrower (state.get(\defaultAccount)==state.get(\lr-Borrower))            
        )

Template.loan_request.rendered =->
    $(\.set-data).attr \disabled, \disabled
    if state.get(\lr)?WantedWei                 != 0 =>        $('.lr-WantedWei').attr \value,                  bigNum-toStr state.get(\lr)?WantedWei
    if state.get(\lr)?DaysToLen                 != 0 =>        $('.lr-DaysToLen').attr \value,                  state.get(\lr)?DaysToLen
    if state.get(\lr)?TokenAmount               != 0 =>        $('.lr-TokenAmount').attr \value,                state.get(\lr)?TokenAmount
    if state.get(\lr)?PremiumWei                != 0 =>        $('.lr-PremiumWei').attr \value,                 bigNum-toStr state.get(\lr)?PremiumWei
    if state.get(\lr)?Borrower                  != big-zero => $('.lr-Borrower').attr \value,                   state.get(\lr)?Borrower
    if state.get(\lr)?Lender                    != big-zero => $('.lr-Lender').attr \value,                     state.get(\lr)?Lender
    if state.get(\lr)?TokenSmartcontractAddress != big-zero => $('.lr-TokenSmartcontractAddress').attr \value,  state.get(\lr)?TokenSmartcontractAddress
    $('.lr-TokenName').attr \value,     state.get(\lr)?TokenName
    $('.lr-TokenInfoLink').attr \value, state.get(\lr)?TokenInfoLink       

            
Template.loan_request.events do 
    'click .set-data':-> 
        out = {}
        out.ethamount = eth-to-wei $(\.lr-WantedWei).val!
        out.days      = $(\.lr-DaysToLen).val!
        out.tokamount = $(\.lr-TokenAmount).val!
        out.premium   = eth-to-wei $(\.lr-PremiumWei).val!
        out.tokname   = $(\.lr-TokenName).val!
        out.bor       = $(\.lr-Borrower).val!
        out.len       = $(\.lr-Lender).val!
        out.smart     = $(\.lr-TokenSmartcontractAddress).val!
        out.link      = $(\.lr-TokenInfoLink).val!

        console.log \out: out
        lr.setData(state.get \address )(#uint wanted_wei_, uint token_amount_, uint premium_wei_,
            out.ethamount,
            out.tokamount,                    
            out.premium,             
            out.tokname,            
            out.link,
            out.smart,
            out.days, 
            goto-success-cb
        )  



    'click .transfer-tokens':->
        lr.checkTokens(state.get(\address)) goto-success-cb

    'click .lender-pay':->   
        transact = {
            from:  web3.eth.defaultAccount
            to:    state.get(\address)
            value: bigNum-add(state.get('lr').WantedWei, state.get(\NeededSumByLender))
            gas:   2900000
        }
        console.log \transact: transact
        web3.eth.sendTransaction transact, goto-success-cb

    'click .return-tokens':->
        transact = {
            from:  web3.eth.defaultAccount
            to:    state.get(\address)
            value: bigNum-add(state.get(\lr).PremiumWei, state.get(\lr).WantedWei)
            gas:   2900000
        }
        # console.log \transact: transact
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

        switch cls
        case \lr-WantedWei   => test IntQ $T.val!
        case \lr-DaysToLen   => test IntQ $T.val!
        case \lr-TokenAmount => test IntQ $T.val!
        case \lr-PremiumWei  => test IntQ $T.val!
        case \lr-TokenName   => test $T.val!length > 3
        case \lr-TokenSmartcontractAddress => test EthQ $T.val!

        if Everything_is_ok! => $(\.set-data).remove-attr \disabled
        else $(\.set-data).attr \disabled, \disabled


Everything_is_ok=->
    ok = true
    test =-> if it is false => ok := false

    for el in $(\.input)
        cls = $(el).attr(\class) |> split ' ' |> last
        switch cls
        case \lr-WantedWei   => test IntQ $(el).val!
        case \lr-DaysToLen   => test IntQ $(el).val!
        case \lr-TokenAmount => test IntQ $(el).val!
        case \lr-PremiumWei  => test IntQ $(el).val!
        case \lr-TokenName   => test $(el).val!length > 3
        case \lr-TokenSmartcontractAddress => test EthQ $(el).val!
    console.log \ok: ok
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