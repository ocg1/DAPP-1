Router.route \info, path: \info

template \info -> main_blaze {}, 
    D \info,
        h4 class:\info-key, "Eth is enabled"
        p class:\info-value, yesno config.SMART_CONTRACTS_ENABLED

        h4 class:\info-key, "Eth node"
        p class:\info-value, config.ETH_NODE

        h4 class:\info-key, "Your address"
        p class:'info-value defaultAccount', 
            a target:\_blank class:\account-link href:'', ''

        h4 class:\info-key, "Your balance"
        p class:'info-value balance', ''

        h4 class:\info-key, "Ledger contract address"
        p class:\info-value,
            a target:\_blank href:config.ETH_MAIN_ADDRESS_LINK, config.ETH_MAIN_ADDRESS

        

Template.info.created=~>
    state.set \selected-class \info 
    if !web3 => console.log \oops
    getB =-> web3.eth.getBalance(it, (err,res)~> 
        if res => $(\.balance).html("#{ bigNum-toStr(res)} ETH"); console.log res
        else getB(it))    

    lookup web3.eth.defaultAccount, (res)~> 
        getB(res)
        $(\.account-link).html res
        $(\.account-link).attr \href "https://kovan.etherscan.io/address/#{res}"
  
          