Router.route \loan_request, path:\/loan-request/:id template:\loan_request

template \loan_request -> main_blaze D \loan-wrapper,
    div class:\input-wrapper,
        h2 class:\loan-title, "Loan Request  0x31231239080984234"
        div class:\input-box,
            form action:'',
                h3 class:\input-key, "Eth amount"
                input class:\input placeholder:'00.00 Eth'
                img class:\input-img-pin src:\/img/green_pin.svg alt:''
                img class:\input-img-pin src:\/img/red_pin.svg alt:''
                h3 class:\input-key, "Days to lend"
                input class:\input
                h3 class:\input-key, "Token amount"
                input class:\input
                img class:\input-img-pin src:\/img/green_pin.svg alt:''
                img class:\input-img-pin src:\/img/red_pin.svg alt:''
                h3 class:\input-key, "Premium amount"
                input class:\input placeholder:'00.00 Eth'
                img class:\input-img-pin src:\/img/green_pin.svg alt:''
                img class:\input-img-pin src:\/img/red_pin.svg alt:''
                h3 class:\input-key, "Token name"
                input class:\input
                img class:\input-img-pin src:\/img/green_pin.svg alt:''
                img class:\input-img-pin src:\/img/red_pin.svg alt:''
                img class:\input-img-dot src:\/img/red_dot.svg alt:''
                h3 class:\input-key, "Borrower"
                input class:'input input-primary-short' value:\0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7 disabled:''
                h3 class:\input-key, "Lender"
                input class:'input input-primary-short' value:\0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7 disabled:''
                h3 class:\input-key, "Token smart contract address"
                input class:'input input-primary-short' value:\0xb9af8aa42c97f5a1f73c6e1a683c4bf6353b83e7 disabled:''
                img class:\input-img-pin src:\/img/green_pin.svg alt:''
                img class:\input-img-pin src:\/img/red_pin.svg alt:''
                h3 class:\input-key, "Token info link (optional)"
                input class:\input
                div class:\text-aligned,
                    input class:'input-submit card-button bgc-primary' type:\submit value:'Set data'
    div class:\block-scheme,
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

