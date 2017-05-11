Router.route \mainTemplate, path: \main

template \mainTemplate -> main_blaze do
    D \card-wrapper D \card-wrapper-aligned,
        for it in state.get \requests
            card-template it
        # Blaze.Each (-> state.get \requests), ->
        #     invest-item {address:SL(@,\address), id:SL(@,\id), num:SL(@,\num)}


        a href:'', img class:'arrow arrow-left'  src:\/img/left.svg  alt:''
        a href:'', img class:'arrow arrow-right' src:\/img/right.svg alt:''

@card-template =-> D \card,
    div class:\card-header,
        h3 class:\card-header-amount, "#{it.amount} Eth"
        h3 class:\card-header-inscription, "#{it.inscription} Aeternity Tokens"
    div class:\card-body,
        img class:\img-dot src:\/img/red_dot.svg alt:''
        h4 class:\card-key, "Borrower"
        p class:\card-value, it.borrower
        h4 class:'card-key font-weight-normal', "Lender"
        p class:\card-value, it.lender
        div class:'card-state float-left',
            h4 class:'card-key font-weight-normal', "State"
            p class:\card-value, it.state
        div class:\float-left,
            h4 class:'card-key font-weight-normal', "Created"
            p class:\card-value, it.created


# # @get-mock-data =->
# #     id:             Math.random!
# #     amount:         100*Math.random!
# #     inscription:    \898323223
# #     borrower:       \0x + get-id!
# #     lender:         \0x + get-id!
# #     state:          \funded
# #     created:        \2017/04/24

# @get-mock-data-arr =-> [get-mock-data! for n from 1 to 20]

Template.mainTemplate.created =->
    state.set \requests get-mock-data-arr!



Template.mainTemplate.events do
    'click .escrow':-> 
