Router.route \loan_request, path:\/loan-request/:id template:\loan_request

template \loan_request -> main_blaze do
    # else state.get \main-frame 
    h1 class:"#{state.get \error-class }", 'Wrong address'

    div class:"loading #{state.get \loading-class } container" style:'padding:100px',  
        h1 style:'font-size:50px; display:block', 'Loading'
        p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 'Please, wait...'

    D "loan-wrapper #{state.get \loan-wrapper-class }",
        D \input-wrapper,
            h2 class:\loan-title, "Loan Request  0x31231239080984234"
            input-box!
        block-scheme!

grn-pin   =-> img class:\input-img-pin src:\/img/green_pin.svg alt:''
red-pin   =-> img class:\input-img-pin src:\/img/red_pin.svg   alt:''
red-dot   =-> img class:\input-img-dot src:\/img/red_dot.svg   alt:''

input-unit =-> section style:'height:40px',
     
    h3 class:\input-key, 
        if it.red-dot   => red-dot!
        it.name
    input style:'max-height:40px' class:"input #{it.class}" placeholder:it?placeholder, value:it?value, disabled:it.disabled
    if it.green-pin => grn-pin!        
    if it.red-pin   => red-pin!           

input-box =~> div class:\input-box, 
    map input-unit, [
        *name:'Eth amount' placeholder:'00.00 Eth'               value:state.get(\lr-WantedWei),                 disabled:(!state.get(\IamBorrower) || state.get(\lr-State))
        *name:'Days to lend'                                     value:state.get(\lr-DaysToLen),                 disabled:(!state.get(\IamBorrower) || state.get(\lr-State))
        *name:'Token amount' placeholder:'00.00 Eth'             value:state.get(\lr-TokenAmount),               disabled:(!state.get(\IamBorrower) || state.get(\lr-State))
        *name:'Premium amount' placeholder:'00.00 Eth'           value:state.get(\lr-PremiumWei),                disabled:(!state.get(\IamBorrower) || state.get(\lr-State))
        *name:'Token name'                                       value:state.get(\lr-TokenName),                 disabled:(!state.get(\IamBorrower) || state.get(\lr-State))
        *class:'input-primary-short' name:'Borrower'             value:state.get(\lr-Borrower),                  disabled:true red-dot:state.get(\IamBorrower)
        *class:'input-primary-short' name:'Lender'               value:state.get(\lr-Lender),                    disabled:true red-dot:state.get(\IamLender) 
        *class:'input-primary-short' name:'Token smart contract' value:state.get(\lr-TokenSmartcontractAddress), disabled:true 
        *name:'Token info link (optional)'                       value:state.get(\lr-TokenInfoLink),             disabled:!state.get(\IamBorrower) 
    ]
    div class:\text-aligned,
        button class:'card-button bgc-primary' disabled:(!state.get(\IamBorrower) || state.get(\lr-State)), 'Set data'

block-scheme =-> D \block-scheme,
    div class:'block-scheme-element block-scheme-element-highlighted', "No data"
    div class:\block-scheme-line,
        p class:\block-scheme-line-inscription, "Borrower ",
            br {}, "sets data"
        div class:\block-scheme-line-arrow
    div class:\block-scheme-element, "Waiting For Tokens"
    div class:\block-scheme-line,
        p class:\block-scheme-line-inscription, "Borrower transfers ",
            br {}, "tokens"
        div class:\block-scheme-line-arrow
    div class:\block-scheme-element, "Waiting For Lender"
    div class:\block-scheme-line,
        p class:\block-scheme-line-inscription, "Lender sends ",
            br {}, "money"
        div class:\block-scheme-line-arrow
    div class:\block-scheme-element, "Funded"
    div class:'block-scheme-line block-scheme-line-long',
        p class:\block-scheme-line-inscription, "Borrower gets his",
            br {}, "tokens back"
        p class:'block-scheme-line-inscription block-scheme-line-inscription-second', "Lender gets money + ",
            br {}, "premium"
        div class:'block-scheme-line-arrow block-scheme-line-arrow-long'
    div class:'block-scheme-element block-scheme-element-success', "Finished"
    div class:'block-scheme-line block-scheme-line-long block-scheme-line-long-branch',
        p class:'block-scheme-line-inscription block-scheme-line-inscription-branch', "Lender gets",
            br {}, "tokens"
        div class:'block-scheme-line-arrow block-scheme-line-arrow-branch'
    div class:'block-scheme-element block-scheme-element-branch block-scheme-element-failure', "Default"


Template.loan_request.created=->
    state.set \address     (Router.current!originalUrl |> split \/ |> last )
    state.set \loan-wrapper-class, \hidden
    state.set \loading-class,      ''
    state.set \error-class, (if EthQ(state.get(\address))=>\hidden else '' )
    # console.log state.get \address
    get-all-lr-data( state.get \address ) ->
        console.log \0: &0
        console.log \1: &1

        state.set \loan-wrapper-class, ''
        state.set \loading-class, \hidden
        state.set \lr, &1

        if &1.WantedWei                 != 0 =>        state.set \lr-WantedWei                 &1?WantedWei                      
        if &1.DaysToLen                 != 0 =>        state.set \lr-DaysToLen                 &1?DaysToLen                      
        if &1.TokenAmount               != 0 =>        state.set \lr-TokenAmount               &1?TokenAmount                        
        if &1.PremiumWei                != 0 =>        state.set \lr-PremiumWei                &1?PremiumWei                                               
        if &1.Borrower                  != big-zero => state.set \lr-Borrower                  &1?Borrower                       
        if &1.Lender                    != big-zero => state.set \lr-Lender                    &1?Lender                         
        if &1.TokenSmartcontractAddress != big-zero => state.set \lr-TokenSmartcontractAddress &1?TokenSmartcontractAddress                      
        state.set \lr-State         &1?State
        state.set \lr-TokenName     &1?TokenName
        state.set \lr-TokenInfoLink &1?TokenInfoLink                      
        state.set \IamLender        (state.get(\defaultAccount)==state.get(\lr-Lender))       
        state.set \IamBorrower      (state.get(\defaultAccount)==state.get(\lr-Borrower))            

Template.loan_request.rendered =->
    # state.set \IamLender   (state.get \defaultAccount == state.get \address)
    # state.set \IamBorrower (state.get \defaultAccount == state.get \address)

Template.loan_request.events do 
    'click button':->