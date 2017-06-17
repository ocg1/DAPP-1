Router.route \funded, path: \/funded/:page

template \funded -> main_blaze do
    not-found-component('Not found', 'No funded Loan Requests found')
    D \card-wrapper,
        progress-bar!

        D "card-wrapper-aligned #{state.get \quartet-funded-class }",
            D \div, map card-template, state.get(\quartet-funded)||[]
            button class:"#{if state.get(\page)~=\1 => \disabled } arrow arrow-left glyphicon glyphicon-chevron-left" disabled:(state.get(\page)~=\1)
            button class:"arrow arrow-right glyphicon glyphicon-chevron-right"

create-quartet=(start,cb)->
    out = []
    load-one-card =-> ledger.getLrFunded start + it, (err,id)->
        if id == big-zero => out.push null
        else get-all-lr-data(id) (err,lr)~>
            lr.id = id
            out.push lr

    map load-one-card, [0 1 2 3]
   
    cycle =-> 
        if out.length < 4 => Meteor.setTimeout (-> cycle! ), 10
        else cb null, compact out
    cycle! 

create-quartet-page=(start)->
    state.set \percent 0

    create-quartet start, (err,res)->
        state.set \quartet-funded-class ''
        state.set \progress-class \hidden
        console.log \res: res
        if res.length == 0 || isNaN(+state.get(\page))
            state.set \not-found-class ''
            state.set \quartet-funded-class \hidden 
        else state.set \quartet-funded res

Template.funded.rendered =->
    
Template.funded.created =->
    state.set \quartet-funded ''
    state.set \page (Router.current!originalUrl |> split \/ |> last )   
    if isNaN(+state.get(\page)) 
        state.set \not-found-class ''
        state.set \progress-class \hidden
        state.set \quartet-funded-class \hidden 
    else        
        state.set \not-found-class \hidden
        state.set \selected-class \funded
        state.set \quartet-funded-class \hidden 
        state.set \progress-class ''         

        if state.get(\percent)==0 or !state.get(\percent)
            state.set \percent 0
  
        rerender!  

rerender =~> ledger.getLrFundedCount ->
    return &0 if &0
    total-reqs = &1.c.0
    state.set \totalReqs total-reqs
    create-quartet-page((state.get(\page)-1)*4)   

Template.funded.events do
    'click .arrow-right':-> 
        state.set \quartet-funded-class \hidden 
        state.set \progress-class ''
        state.set \percent 0

        state.set \page (+state.get(\page)+1)
        Router.go "/main/#{state.get(\page)}" 
        rerender!
    'click .arrow-left' :->    
        if +state.get(\page)<2 => event.prevent-default; return
        state.set \percent 0
        state.set \quartet-funded-class \hidden 
        state.set \progress-class ''

        state.set \page (+state.get(\page)-1)
        Router.go "/main/#{state.get(\page)}" 
        rerender!