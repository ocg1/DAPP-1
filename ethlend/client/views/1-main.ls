Router.route \mainTemplate, path: \/main/:page

template \mainTemplate -> main_blaze do
    not-found-component('Not found', 'No Loan Requests found')
    D \card-wrapper,
        progress-bar!
        D "card-und-nav #{state.get \quartet-class }",
            D "card-wrapper-aligned",
                D \div, map card-template, state.get(\quartet)||[]

            link-panel \main


@card-class=->
    if it?isEns => return \ens
    if it?isRep => return \rep
    if !it.isEns && !it.isRep => return \tokens

@card-template =-> a class:"card #{card-class it }" href:"/loan-request/#{it?id}",
    div class:"card-header #{card-class it}",
        if it.State > 0 => div class:\div,
            h3 class:\card-header-amount, "#{bigNum-toStr it.WantedWei } Eth"
            if !it.isEns && !it.isRep
                if bigNum-toStr(it.WantedWei).length < 10    
                    if (bigNum-toStr(it?TokenAmount)?length + it?TokenName?length)< 20    
                        h3 class:'card-header-inscription token-am', "#{it?TokenName} (#{it?TokenAmount})"
                    else h3 class:'card-header-inscription token-am', "#{it?TokenName}"
            if it.isEns
                h3 class:'card-header-inscription token-am', 'ENS domain'

        else if it.Borrower?toUpperCase() == web3?eth?defaultAccount?toUpperCase()
            h3 class:\card-header-amount, "Please, set the data"

        else h3 class:\card-header-amount, "Data must be set by the Borrower"

    div class:\card-body,
        if web3.eth.defaultAccount?toUpperCase() == it.Borrower?toUpperCase()
            img class:\img-dot src:\/img/red_dot.svg alt:''
        h4 class:\card-key, "Borrower"
        p class:"card-value #{card-class it}", it.Borrower
        if it?State != 3  => D \div-lender,
            if web3.eth.defaultAccount?toUpperCase() == it.Lender?toUpperCase()
                img class:\img-dot src:\/img/red_dot.svg alt:''
            h4 class:'card-key font-weight-normal', "Lender" 
            p class:"card-value #{card-class it}", if it.Lender != big-zero => it.Lender else \–––
        if it?State == 3 && it.Borrower?toUpperCase() != web3.eth.defaultAccount?toUpperCase()
            h4 class:"card-key-inscription" style:'color:black', "Get #{get-premium(it.PremiumWei)}Premium!"
        # if it?State == 3
        #     button class:'card-button bgc-primary fund-button' style:"width:100px;margin-left:70px" id:it?id, 'Fund'

        div class:'card-state float-left',
            h4 class:'card-key font-weight-normal', "State"
            p class:"card-value #{card-class it}", state-int-to-str it?State, if it?isEns => \domain else \tokens





@empty-list =-> div style:'padding:100px' class:\container ,
    h1 style:'font-size:50px; display:block', 'No loan requests'
    p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 'That is no loan requests here.'

@get-card-data =(number, cb)->
    ledger.getLr number, ->
        get-all-lr-data(&1)(cb)

@progress-bar =(percent)-> div style:'padding:100px; padding-right:120px' class:"#{state.get \progress-class } container" ,
    h1 style:'font-size:50px; display:block', 'Receiving data...'
    p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 'Please wait for the data to be downloaded from Ethereum network...'
    # div class:\progress style:'width:70%',
        # div class:"progress-bar progress-bar-striped active" role:"progressbar" aria-valuenow:"#percent" aria-valuemin:"0" aria-valuemax:"100" style:"width:#{state.get \percent }%"
        # span class:"sr-only", "#{state.get \percent } Complete"

create-quartet=(start,cb)->
    out = []
    load-one-card =-> ledger.getLr start - it, (err,id)->
        if id == big-zero => out[it] = null
        else get-all-lr-data(id) (err,lr)~>
            lr.id = id
            out[it] = lr

    map load-one-card, [0 1 2 3]
    Undef = false
   
    cycle =-> 
        if typeof out[0] == \undefined => return Meteor.setTimeout (-> cycle! ), 10
        if typeof out[1] == \undefined => return Meteor.setTimeout (-> cycle! ), 10
        if typeof out[2] == \undefined => return Meteor.setTimeout (-> cycle! ), 10
        if typeof out[3] == \undefined => return Meteor.setTimeout (-> cycle! ), 10            
        else return cb null, compact out
    cycle!        

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
    # ledger.getLrCount (err,res)-> 
    #     console.log \err: err, \res: res
    #     state.set \pages-count lilNum-toStr res

    state.set \quartet ''
    state.set \page (Router.current!originalUrl |> split \/ |> last )   
    if isNaN(+state.get(\page)) 
        state.set \not-found-class ''
        state.set \progress-class \hidden
        state.set \quartet-class \hidden 
    else        
        state.set \not-found-class \hidden
        state.set \selected-class \main
        state.set \quartet-class \hidden 
        state.set \progress-class ''         

        if state.get(\percent)==0 or !state.get(\percent)
            state.set \percent 0

        rerender!  

rerender =~> ledger.getLrCount ->
    return &0 if &0
    total-reqs = +lilNum-toStr &1
    state.set \totalReqs total-reqs
    console.log \quartet-page: (total-reqs - state.get(\page)*4)

    create-quartet-page total-reqs - state.get(\page)*4 + 3

Template.mainTemplate.events do
    'click .chevron-right':-> 
        state.set \quartet-class \hidden 
        state.set \progress-class ''
        state.set \percent 0

        state.set \page ceiling state.get(\totalReqs)/4
        Router.go "/main/#{state.get(\page)}" 
        rerender!

    'click .chevron-left' :->    
        if +state.get(\page)<2 => event.prevent-default; return
        state.set \percent 0
        state.set \quartet-class \hidden 
        state.set \progress-class ''
        state.set \page 1
        Router.go "/main/#{state.get(\page)}" 
        rerender!
    
get-premium =->
    if bigNum-toStr(it).length > 7 => 'the '
    else "+ #{bigNum-toStr(it)} ETH "


@gotoPagemain=->
    state.set \page &0
    if +state.get(\page)<1 => event.prevent-default; return
    state.set \percent 0
    state.set \quartet-class \hidden 
    state.set \progress-class ''

    Router.go "/#{&1}/#{state.get(\page)}" 
    rerender!


@link-panel=(type)->
    current-page  = +address-last!
    left-chevron  = a class:"chevron-left arrows #{if (state.get(\page)~=\1) => \disabled }", \‹‹
    right-chevron = a class:"chevron-right arrows #{if state.get(\page)~=(ceiling state.get(\totalReqs)/4) => \disabled }", \››
    
    count = state.get \totalReqs
    console.log \totalReqs state.get \totalReqs
    if count < 0 => return null

    pages = ceiling count/4

    link-arr = []

    if pages <= 9 # просто отрисовываем все цифры без стрелочек
        link-arr = [1 to pages]
        left-chevron  = ''
        right-chevron = '' 

    if pages > 9 && current-page <= 5 # стрелочку влево не отрисовываем
        link-arr = [1 to 9]
        # right-chevron = a class:'icon item' href:'/main/'+pages, i class:'right chevron icon'

    if pages > 9 && current-page > 5 && pages > current-page + 4 # отрисовываем обе стрелочки
        link-arr = [(current-page - 4) to (current-page + 4)]


    if pages > 9 && current-page > 5 && pages <= current-page + 4 # стрелочку вправо не отрисовываем
        link-arr = [(pages - 8) to pages]
        # left-chevron  = a class:'icon item' href:'/main/1', i class:'left chevron icon'

    get-link=(text, type)-> a class:"pagination-item #{if address-last! ~= text => \active }" onclick:"gotoPage#{type}(#{text},'#{type}')", text

    console.log \count: count
    console.log \pages: pages


    div class:'pagination menu',
        left-chevron
        map get-link(_,type), link-arr
        right-chevron