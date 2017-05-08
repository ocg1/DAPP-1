Router.route \mainTemplate, path: \main

template \mainTemplate -> main_blaze do
    D \card-wrapper D \card-wrapper-aligned,
        replicate 4 card-template!

        a href:'', img class:'arrow arrow-left'  src:\/img/left.svg  alt:''
        a href:'', img class:'arrow arrow-right' src:\/img/right.svg alt:''

@card-template =-> D \card,
    div class:\card-header,
        h3 class:\card-header-amount, "10.43 Eth"
        h3 class:\card-header-inscription, "898323223 Aeternity Tokens"
    div class:\card-body,
        img class:\img-dot src:\/img/red_dot.svg alt:''
        h4 class:\card-key, "Borrower"
        p class:\card-value, "0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7"
        h4 class:'card-key font-weight-normal', "Lender"
        p class:\card-value, "0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7"
        div class:'card-state float-left',
            h4 class:'card-key font-weight-normal', "State"
            p class:\card-value, "funded"
        div class:\float-left,
            h4 class:'card-key font-weight-normal', "Created"
            p class:\card-value, "2017/04/24"


Template.mainTemplate.events do
    'click .escrow':-> 
