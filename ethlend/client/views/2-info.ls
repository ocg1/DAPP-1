Router.route \info, path: \info

template \info -> main_blaze {}, 
    D \info,
        h4 class:\info-key, "Eth is enabled"
        p class:\info-value, yesno config.SMART_CONTRACTS_ENABLED

        h4 class:\info-key, "Your address"
        p class:'info-value defaultAccount', 
            a target:\_blank class:\account-link href:'', ''

        h4 class:\info-key, "Your balance"
        p class:'info-value balance', ''

        h4 class:\info-key, "Ledger contract address"
        p class:\info-value,
            a target:\_blank href:config.ETH_MAIN_ADDRESS_LINK, config.ETH_MAIN_ADDRESS

        h4 class:\info-key, "ENS registry address"
        p class:\info-value,
            a target:\_blank href:"https://etherscan.io/address/#{config.ENS_REG_ADDRESS}", config.ENS_REG_ADDRESS

        h4 class:\info-key, "Your reputation"
        p class:'info-value reputation', ''

        h4 class:\info-key, "Credit Token (CRE)"
        p class:\info-value,
            a target:\_blank href:"https://etherscan.io/address/#{config.REP_ADDRESS}", config.REP_ADDRESS
  
        h4 class:\info-key, "First EthLend ver."
        p class:'info-value', a target:\_blank href:'http://oldest.ethlend.io', 'oldest.ethlend.io'
        
        h4 class:\info-key, "Second EthLend ver."
        p class:'info-value', a target:\_blank href:'http://old.ethlend.io', 'old.ethlend.io'


                

Template.info.created=~>
    state.set \selected-class \info 
    if !web3 => console.log \oops
    getB =-> web3.eth.getBalance(it, (err,res)~> 
        if res => $(\.balance).html("#{ bigNum-toStr(res)} ETH"); console.log res
        else getB(it))    

    lookup web3.eth.defaultAccount, (res)~> 
        getB(res)
        $(\.account-link).html res
        $(\.account-link).attr \href "https://etherscan.io/address/#{res}"

        get-rep-balance web3.eth.defaultAccount, (err,res)->
            $(\.reputation).html(+bigNum-toStr(res) + ' Credit Token (CRE)')
            state.set \reputation bigNum-toStr(res)


          
