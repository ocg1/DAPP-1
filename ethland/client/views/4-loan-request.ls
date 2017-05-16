Router.route \loan_request, path:\/loan-request/:id template:\loan_request

template \loan_request -> main_blaze do
    error-component!
    loading-component!

    D "loan-wrapper #{state.get \loan-wrapper-class }",
        D \input-wrapper,
            h2 class:\loan-title, "Loan Request  #{state.get \address }"
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
        *c:'lr-WantedWei'                                     n:'Eth amount'                 d:disableQ!, placeholder:'00.00 Eth',       
        *c:'lr-DaysToLen'                                     n:'Days to lend'               d:disableQ!,                                
        *c:'lr-TokenAmount'                                   n:'Token amount'               d:disableQ!, placeholder:'0',       
        *c:'lr-PremiumWei'                                    n:'Premium amount'             d:disableQ!, placeholder:'00.00 Eth',       
        *c:'lr-TokenName'                                     n:'Token name'                 d:disableQ!,                                
        *c:'lr-Borrower input-primary-short'                  n:'Borrower'                   d:true       red-dot:state.get(\IamBorrower),
        *c:'lr-Lender input-primary-short'                    n:'Lender'                     d:true       red-dot:state.get(\IamLender),  
        *c:'lr-TokenSmartcontractAddress' n:'Token smart contract'       d:disableQ!                                      
        *c:'lr-TokenInfoLink'                                 n:'Token info link (optional)' d:disableQ!,                                
    ]
    div class:\text-aligned,
        D "set-data-text #{if !state.get(\IamBorrower) => \hidden }", "Please, enter the data" 
        button class:'card-button bgc-primary set-data' disabled:(!state.get(\IamBorrower) || !!state.get(\lr-State)), 'Set data'

block-scheme =-> D \block-scheme,
    D "block-scheme-element #{highlightQ(0)}", 'No data'
    D \block-scheme-line,
        P \block-scheme-line-inscription, "Borrower ", br!, 'sets data'
        D \block-scheme-line-arrow
    D "block-scheme-element #{highlightQ(1)}", 'Waiting For Tokens'
    D \block-scheme-line,
        P \block-scheme-line-inscription, "Borrower transfers ", br!, \tokens
        D \block-scheme-line-arrow
    D "block-scheme-element #{highlightQ(2)}", 'Waiting For Lender'
    D \block-scheme-line,
        P \block-scheme-line-inscription, "Lender sends ", br!, \money
        D \block-scheme-line-arrow
    D "block-scheme-element #{highlightQ(3)}", \Funded
    D 'block-scheme-line block-scheme-line-long',
        P \block-scheme-line-inscription, 'Borrower gets his', br!, 'tokens back'
        P 'block-scheme-line-inscription block-scheme-line-inscription-second', "Lender gets money + ", br!, \premium
        D 'block-scheme-line-arrow block-scheme-line-arrow-long'
    D "#{highlightQ(4)} block-scheme-element block-scheme-element-success", \Finished
    D 'block-scheme-line block-scheme-line-long block-scheme-line-long-branch',
        P 'block-scheme-line-inscription block-scheme-line-inscription-branch', 'Lender gets', br!, \tokens
        D 'block-scheme-line-arrow block-scheme-line-arrow-branch'
    D "#{highlightQ(5)} block-scheme-element block-scheme-element-branch block-scheme-element-failure", \Default


Template.loan_request.created=->
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

    get-all-lr-data( state.get \address ) ->
        state.set \loan-wrapper-class, ''
        state.set \loading-class, \hidden
        state.set \lr, &1
        state.set \lr-Lender   &1?Lender
        state.set \lr-Borrower &1?Borrower
        state.set \lr-State    &1?State
        state.set \IamLender        (state.get(\defaultAccount)==state.get(\lr-Lender))       
        state.set \IamBorrower      (state.get(\defaultAccount)==state.get(\lr-Borrower))            


Template.loan_request.rendered =->
    $(\.set-data).attr \disabled, \disabled
    if state.get(\lr)?WantedWei                 != 0 =>        $('.lr-WantedWei').attr \value,                  state.get(\lr)?WantedWei
    if state.get(\lr)?DaysToLen                 != 0 =>        $('.lr-DaysToLen').attr \value,                  state.get(\lr)?DaysToLen
    if state.get(\lr)?TokenAmount               != 0 =>        $('.lr-TokenAmount').attr \value,                state.get(\lr)?TokenAmount
    if state.get(\lr)?PremiumWei                != 0 =>        $('.lr-PremiumWei').attr \value,                 state.get(\lr)?PremiumWei
    if state.get(\lr)?Borrower                  != big-zero => $('.lr-Borrower').attr \value,                   state.get(\lr)?Borrower
    if state.get(\lr)?Lender                    != big-zero => $('.lr-Lender').attr \value,                     state.get(\lr)?Lender
    if state.get(\lr)?TokenSmartcontractAddress != big-zero => $('.lr-TokenSmartcontractAddress').attr \value,  state.get(\lr)?TokenSmartcontractAddress
    $('.lr-TokenName').attr \value,     state.get(\lr)?TokenName
    $('.lr-TokenInfoLink').attr \value, state.get(\lr)?TokenInfoLink       

            
Template.loan_request.events do 
    'click .set-data':-> 
        out = {}
        out.ethamount = $(\.lr-WantedWei).val!
        out.days      = $(\.lr-DaysToLen).val!
        out.tokamount = $(\.lr-TokenAmount).val!
        out.premium   = $(\.lr-PremiumWei).val!
        out.tokname   = $(\.lr-TokenName).val!
        out.bor       = $(\.lr-Borrower).val!
        out.len       = $(\.lr-Lender).val!
        out.smart     = $(\.lr-TokenSmartcontractAddress).val!
        out.link      = $(\.lr-TokenInfoLink).val!

        check-set-data-out out, (err,res)->
            if err => return err
            lr.setData(state.get \address )(#uint wanted_wei_, uint token_amount_, uint premium_wei_,
                res.ethamount,
                res.tokamount,                    
                res.premium,             
                res.tokname,            
                res.link,
                config.ETH_MAIN_ADDRESS,
                res.days, 
                set-data-cb                      
            )  

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
            # elem.parents(\section).find(\.gpin).remove-class(\hidden)
            # elem.parents(\section).find(\.rpin).add-class(\hidden)
            # state.set("#{name}-rpin" true); state.set("#{name}-gpin" false)
            
        # else 
            # elem.parents(\section).find(\.gpin).add-class(\hidden)
            # elem.parents(\section).find(\.rpin).remove-class(\hidden)

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


check-set-data-out =(out,cb)->  # TODO: чекать данные, соответствующе подсвечивать, если что неправильно
    cb(null, out)

set-data-cb =(err,res)-> # TODO: коллбэк для сет дата. Надо будет перезагружать страницу, наверное, 
    location.reload!
    res                  #       или показывать loading до тех пор, пока изменения не вступят в силу.


@disableQ =-> (!state.get(\IamBorrower) || !!state.get(\lr-State))

@highlightQ =-> if it is state.get \lr-State then \block-scheme-element-highlighted else ''