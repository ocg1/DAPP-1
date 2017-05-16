Router.route \info, path: \info

template \info -> main_blaze {}, 
    D \info,
        h4 class:\info-key, "Eth is enabled"
        p class:\info-value, config.SMART_CONTRACTS_ENABLED

        h4 class:\info-key, "Eth node"
        p class:\info-value, config.ETH_NODE

        h4 class:\info-key, "Eth main account"
        p class:'info-value defaultAccount', ''

        h4 class:\info-key, "Eth main account link"
        p class:'info-value font-color-primary',
            a class:\account-link href:'', ''

        h4 class:\info-key, "Main balance"
        p class:'info-value balance', ''

        h4 class:\info-key, "Ledger contract address"
        p class:\info-value, config.ETH_MAIN_ADDRESS

        h4 class:\info-key, "Ledger contract link"
        p class:'info-value font-color-primary',
            a href:config.ETH_MAIN_ADDRESS_LINK, config.ETH_MAIN_ADDRESS_LINK


Template.info.created=~>
    state.set \selected-class \info 
    if !web3 => console.log \oops
    getB =-> web3.eth.getBalance(it, (err,res)~> 
        if res => $(\.balance).html("#{res.c.1} (Wei)"); console.log res
        else getB(it))    

    lookup web3.eth.defaultAccount, (res)~> 
        getB(res)
        $(\.defaultAccount).html(res);
        $(\.account-link).html "https://kovan.etherscan.io/address/#{res}"
  
          
