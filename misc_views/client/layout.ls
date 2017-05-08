template \layout -> 
    html lang:\en,
        head do
            meta charset:\UTF-8
            title {}, "EthLend"
        body do
            header_blaze do
                a class:\logo href:\/main,
                    img class:\logo-image src:\/img/logo.svg alt:'EthLend logo'
                h1 class:\site-name,
                    a class:\home-link href:\/main, "EthLend"
                nav class:\navigation,
                    div class:'nav-link-wrapper selected',
                        a class:\nav-link href:\/loan-request/1, "All Loan Requests"
                    div class:\nav-link-wrapper,
                        a class:\nav-link href:\/loan-request/1, "Funded Loan Requests"
                    div class:\nav-link-wrapper,
                        a class:'nav-link with-icon' href:\/new-loan-request, "New Loan Request"
                    div class:\nav-link-wrapper,
                        a class:\nav-link href:\/info, "Info"

            SI @lookupTemplate \yield
        footer do
            div class:\footer-nav,
                a class:\footer-link href:\/main, "Home"
                a class:\footer-link href:'', "About EthLеnd"
                a class:\footer-link href:'', "FAQs"
            p class:\footer-inscription, "EthLend ©2017 Created by ",
                a href:'', "Chain.Cloud"

