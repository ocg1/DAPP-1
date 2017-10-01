template \layout -> 
    html lang:\en,
        head do
            meta charset:\UTF-8
            title {}, "EthLend"
        body do
            header_blaze do
                a class:\logo href:\/main/1,
                    img class:\logo-image src:\/img/logo.png alt:'EthLend logo'
                nav class:\navigation,
                    D "nav-link-wrapper",
                        a class:"nav-link js-gitter-toggle-chat-button", "Chat"
                    D "nav-link-wrapper #{if state.get(\selected-class)==\main => \selected  }",
                        a class:\nav-link href:\/main/1, "All Loan Requests"
                    D "nav-link-wrapper #{if state.get(\selected-class)==\funded => \selected  }",
                        a class:\nav-link href:\/funded/1, "Funded Loan Requests"
                    D "nav-link-wrapper #{if state.get(\selected-class)==\new-loan => \selected  }",
                        span class:"glyphicon glyphicon-plus-sign" aria-hidden:"true" style:'color:white; position:relative; left:15px; top:2px;'
                        a class:'nav-link with-icon' href:\/new-loan-request, "New Loan Request"
                    D "nav-link-wrapper #{if state.get(\selected-class)==\info => \selected } #{if state.get(\selected-class)==\loan => \pseudo-selected }",
                        a class:\nav-link href:\/info, "Info"
#       CHECK FOR WEB3 do
            div class:'main-shell', 
                
                SI @lookupTemplate \yield


        footer do
            div class:\footer-nav,
                a class:\footer-link href:\/main/1, "Home"
                a class:\footer-link href:'http://about.ethlend.io', "About EthLеnd"
                a class:\footer-link href:'/faq', "FAQs"
            p class:\footer-inscription, "EthLend ©2017"


Template.layout.events do 
    'click .nav-link-wrapper':->
        $(\.selected).remove-class(\selected)
        $(event.target).add-class(\selected)

    # 'mouseover .nav-link-wrapper':->
    #     $(\.selected).remove-class(\selected)
    #     $(event.target).add-class(\selected)




Template.layout.rendered=->
    console.log web3.eth.defaultAccount

    ((i, s, o, g, r, a, m) ->
      i.'GoogleAnalyticsObject' = r
      i[r] = i[r] || ->
        (i[r].q = i[r].q || []).push arguments
        return 
      i[r].l = 1 * new Date
      a = s.createElement o
      m = (s.getElementsByTagName o).0
      a.async = 1
      a.src = g
      m.parentNode.insertBefore a, m
      return ) window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga'

    ga 'create', 'UA-102004013-2', 'auto'

    ga 'send', 'pageview'

    script = document.createElement 'script'
    script.setAttribute 'type', 'text/javascript'
    script.setAttribute 'src', 'https://sidecar.gitter.im/dist/sidecar.v1.js'
    script.setAttribute 'defer', 'defer'
    script.setAttribute 'async', 'async'
    (document.getElementsByTagName 'head').0.appendChild script
    ((window.gitter = {}).chat = {}).options = {
        room: 'ethlend/lobby',
        activationElement: false
    }

    state.set \addr (Router.current!originalUrl |> split \/)

    state.set \addr-last (state.get(\addr) |> last )
    state.set \addr-prelast (state.get(\addr) |> initial |> last )

    state.set \main-class     if (state.get(\addr-prelast)==\main)          => \selected else ''
    state.set \info-class     if (state.get(\addr-last)==\info)             => \selected else ''
    state.set \new-loan-class if (state.get(\addr-last)==\new-loan-request) => \selected else ''
    

# check-web=(eld, nom)~>

Template.layout.rendered=->
    if !web3? => Router.go \/no_metamask
    script = document.createElement 'script'
    script.setAttribute 'type', 'text/javascript'
    script.setAttribute 'src', 'https://sidecar.gitter.im/dist/sidecar.v1.js'
    script.setAttribute 'defer', 'defer'
    script.setAttribute 'async', 'async'
    (document.getElementsByTagName 'head').0.appendChild script
    ((window.gitter = {}).chat = {}).options = {
        room: 'ethlend/lobby',
        activationElement: false
    }

go-cycle=(iterator, eld)~> 
    unless web3?
        if iterator < 50
            Meteor.setTimeout (-> iterator +=1; console.log(\web3-loading:,iterator);  go-cycle!), 20
                
        else no_metamask!
    else 
        state.set \defaultAccount web3?eth?defaultAccount
        console.log \done
        eld