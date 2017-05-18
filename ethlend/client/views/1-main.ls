Router.route \mainTemplate, path: \/main/:page

template \mainTemplate -> main_blaze do
    not-found-component!
    D \card-wrapper,
        progress-bar!

        D "card-wrapper-aligned #{state.get \quartet-class }",
            D \div, map card-template, state.get(\quartet)||[]
            button class:"#{if state.get(\page)~=\1 => \disabled } arrow arrow-left glyphicon glyphicon-chevron-left" disabled:(state.get(\page)~=\1)
            button class:"arrow arrow-right glyphicon glyphicon-chevron-right"

card-template =-> a class:\card href:"/loan-request/#{it?id}",
    div class:\card-header,
        if it.State > 0 => div class:\card-header,
            h3 class:\card-header-amount, "#{bigNum-toStr it.WantedWei } Eth"
            h3 class:\card-header-inscription, "#{it?TokenName} (#{it?TokenAmount})"
        else if it.Borrower == web3?eth?defaultAccount => div class:\card-header, 
            h3 class:\card-header-amount, "Please, set the data"

        else div class:\card-header, 
            h3 class:\card-header-amount, "Data must be set by the Borrower"

    div class:\card-body,
        if web3.eth.defaultAccount == it.Borrower
            img class:\img-dot src:\/img/red_dot.svg alt:''
        h4 class:\card-key, "Borrower"
        p class:\card-value, it.Borrower
        if it?State != 3  => D \div-lender,
            if web3.eth.defaultAccount == it.Lender
                img class:\img-dot src:\/img/red_dot.svg alt:''
            h4 class:'card-key font-weight-normal', "Lender" 
            p class:\card-value, if it.Lender != big-zero => it.Lender else \–––
        if it?State == 3
            h4 class:"card-key-inscription" style:'color:black', "Get +#{if (+bigNum-toStr(it?PremiumWei))<1 => 0 else (bigNum-toStr it?PremiumWei)} Eth Premium!"
        # if it?State == 3
        #     button class:'card-button bgc-primary fund-button' style:"width:100px;margin-left:70px" id:it?id, 'Fund'

        div class:'card-state float-left',
            h4 class:'card-key font-weight-normal', "State"
            p class:\card-value, state-int-to-str it?State

empty-list =-> div style:'padding:100px' class:\container ,
    h1 style:'font-size:50px; display:block', 'No loan requests'
    p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 'That is no loan requests here.'

get-card-data =(number, cb)->
    ledger.getLr number, ->
        get-all-lr-data(&1)(cb)

progress-bar =(percent)-> div style:'padding:100px; padding-right:120px' class:"#{state.get \progress-class } container" ,
    h1 style:'font-size:50px; display:block', 'Receiving data...'
    p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 'Please wait for the data to be downloaded from the Ethereum network'
    div class:\progress style:'width:70%',
        div class:"progress-bar progress-bar-striped active" role:"progressbar" aria-valuenow:"#percent" aria-valuemin:"0" aria-valuemax:"100" style:"width:#{state.get \percent }%"
        span class:"sr-only", "#{state.get \percent } Complete"

create-quartet=(start,cb)-> # TODO: свернуть рукурентно
    out = []
    if state.get(\percent)==0 => ledger.getLr start, ->
        if &1 == big-zero => return cb(null,out)
        id = &1
        get-all-lr-data(&1) ->
            if state.get(\percent)==0 => state.set \percent 25
            console.log state.get(\percent)
            &1.id = id
            out.push &1
           
            ledger.getLr start+1, ->
                if &1 == big-zero => return cb(null,out)
                id = &1
                get-all-lr-data(&1) ->
                    if state.get(\percent)==25 => state.set \percent 50
                    console.log state.get(\percent)
                    &1.id = id
                    out.push &1
             
                    ledger.getLr start+2, ->
                        if &1 == big-zero => return cb(null,out)
                        id = &1
                        get-all-lr-data(&1) ->
                            if state.get(\percent)==50 =>state.set \percent 75
                            console.log state.get(\percent)
                            &1.id = id
                            out.push &1
                  
                            ledger.getLr start+3, ->
                                if &1 == big-zero => return cb(null,out)
                                id = &1
                                get-all-lr-data(&1) ->
                                    if state.get(\percent)==75 =>state.set \percent 100
                                    &1.id = id
                                    out.push &1
                                    return cb(null,out)

create-quartet-page=(start)->
    state.set \percent 0

    create-quartet start, (err,res)->
        state.set \quartet-class ''
        state.set \progress-class \hidden
        console.log \res: res
        if res.length == 0
            state.set \not-found-class ''
            state.set \quartet-class \hidden 
        else state.set \quartet res

Template.mainTemplate.rendered =->
    
Template.mainTemplate.created =->
    state.set \not-found-class \hidden
    state.set \selected-class \main
    state.set \quartet-class \hidden 
    state.set \progress-class ''         
    state.set \page (Router.current!originalUrl |> split \/ |> last )    

    if state.get(\percent)==0 or !state.get(\percent)
        state.set \percent 0

    rerender!  

rerender =~> ledger.getLrCount ->
    return &0 if &0
    total-reqs = &1.c.0
    state.set \totalReqs total-reqs
    create-quartet-page((state.get(\page)-1)*4)   

Template.mainTemplate.events do
    'click .arrow-right':-> 
        state.set \quartet-class \hidden 
        state.set \progress-class ''
        state.set \percent 0

        state.set \page (+state.get(\page)+1)
        Router.go "/main/#{state.get(\page)}" 
        rerender!
    'click .arrow-left' :->    
        if +state.get(\page)<2 => event.prevent-default; return
        state.set \percent 0
        state.set \quartet-class \hidden 
        state.set \progress-class ''

        state.set \page (+state.get(\page)-1)
        Router.go "/main/#{state.get(\page)}" 
        rerender!
        
    # 'click .funded-button':->
    #     lr.getNeededSumByLender( $(event.target).attr(\id) ) (err,res)->   
    #         transact = {
    #             from:  web3.eth.defaultAccount
    #             to:    $(event.target).attr(\id)
    #             value: res
    #             gas:   2900000
    #         }

    #         web3.eth.sendTransaction transact, (err,res)-> 
    #             if err => console.log \err:   err
    #             if res => console.log \res:   res
