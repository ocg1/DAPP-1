Router.route \faq path:\/faq

template \faq -> main_blaze div style:'padding-top:50px; width:672px;' class:\container,
    h2  "How to use EthLend with MetaMask"
    br!
    p "Please follow these instructions and you will become a master. Make sure you have MetaMask connected to Main Ethereum Network. You can download MetaMask from " a href:"https://metamask.io/", em "https://metamask.io/"
    p strong "How to request for a loan?"
    p "Click New Loan Request from the menu. Next, click the New loan request button."
    get-faq-img-link(1)
    get-faq-img-link(2)
    p "The transaction is complete and the new loan request is created."
    get-faq-img-link(3)
    p "Find your loan request by pressing All Loan Requests from the menu. Ethereum might take a while to load."
    get-faq-img-link(4)
    p "New loan request has the state of “no data”. Small bullet next to the “Borrower” field indicates your loan request. Click the new loan request."
    get-faq-img-link(5)
    p "Your new loan request is loaded from the Ethereum Blockchain. Might take a while to load."
    get-faq-img-link(6)
    p "Set the amount you want to borrow and days to lend. Set the premium (interest) you are willing to pay for the loan."
    p "Submit the amount of token you are pledging (These tokens shall be transferred to the borrower if the loan is not paid back with the premium end of the loan period)."
    p "Please keep in might that the all the tokens should be valued to correspond the loan including the premium. Otherwise, the loan request is not attractive to the lenders."
    p "Insert the token name (for example FirstBlood or Digix). Insert also the token smart contract address (you can find most of the addresses here: ",
        a href:\https://etherscan.io/tokens,
            em "https://etherscan.io/tokens"
        "). For example, Digix token address is "
        a href:\https://etherscan.io/address/0xe0b7927c4af23765cb51314a0e0521a9645f0e2a,
            em "0xe0b7927c4af23765cb51314a0e0521a9645f0e2a", 
        \.
    p "After all mandatory data is inserted, press Set data button."
    get-faq-img-link(7)
    p "Below is a sample loan data."
    get-faq-img-link(8)
    p "After you submitted the data, accept the transaction with MetaMask (should pop up)."
    get-faq-img-link(9)
    p "Below message should appear on successful data."
    get-faq-img-link(10)
    p "Next you need to send tokens to the loan contract. Press back button on your browser and wait or go to All Loan Request and find your latest loan request and click it."
    p "Next, copy the loan request address (which you can find above the Check button)."
    get-faq-img-link(11)
    p "Then go to your Ethereum wallet and send the exact amount of tokens that you have pledged (in this example: 10 Vostoken tokens)."
    get-faq-img-link(12)
    p "After you have sent the tokens from your wallet, go back to the loan and press the Check that tokens are transferred button. MetaMask will appear and accept the transaction to render the check."
    get-faq-img-link(13)
    p "You should see the following window on success."
    get-faq-img-link(14)
    p "Now you can press the back button on your browser or search your loan from the All Loan Request section. You loan is now visible for lenders to fund. Now let us hope that your loan is attractive for the lender If not, you can always create a new loan request with more tokens pledged or with a smaller loan amount."
    get-faq-img-link(15)
    p strong "How to fund a loan?"
    p "Go to All Loan Requests. Click a loan that is waiting for lender and you want to fund. You can also see the amount the borrower wants to borrow, the token, and the amount of tokens that are used as a collateral for the loan."
    get-faq-img-link(16)
    p "When you click the loan, it might take a while that the loan is rendered from the Ethereum Blockchain."
    get-faq-img-link(17)
    p "Next, you will see the terms of the loan. If you are happy to fund the loan, press Fund this loan request. At this point, the tokens are in the loan agreement as a collateral. If the borrower defaults, the tokens are transferred to your Ethereum address."
    get-faq-img-link(18)
    p "MetaMask will popup. Accept the funding. The loan amount is transferred to the borrower and a fee is deducted by the platform."
    get-faq-img-link(19)
    p "When you see something that corresponds below, you have successfully borrowed Ethers"
    get-faq-img-link(20)
    p "When you go to the Funded Loan Request, you should see your loan in a funded state. If there are many loans, you might need to shuffle a bit. Click the loan."
    get-faq-img-link(21)
    p "You should see from the map on right side that the loan is in the Funded state. Now, either the borrower pays the loan on time or the loan defaults and the tokens are transferred to you."
    p "Please keep in mind that different tokens have different value. Use ",
        a href:\https://etherscan.io/tokens,
            em "https://etherscan.io/tokens"
        " or "
        a href:\https://coinmarketcap.com/,
            em "https://coinmarketcap.com/"
        " to value whether the tokens that are used as a collateral cover the loan amount in case of default."
    get-faq-img-link(22)
    p strong "How to pay the loan back?"
    p "Find you the loan you want to pay back from the Funded Loan Requests. Click on Return tokens to get the tokens returned."
    get-faq-img-link(23)
    p "MetaMask pops up. Make sure you have the whole loan amount with premium at your MetaMask account balance. Accept the transaction."
    get-faq-img-link(24)
    p "The loan is paid back and the tokens are transferred to your account. Whoa!"
    get-faq-img-link(25)
    p "Now if you press back button on your browser or search your loan from the All Loan Requests section, you should see the loan at the Finished stage on the map."
    get-faq-img-link(26)
    p strong "How to claim tokens when the borrower does not pay back?"
    p "Search the loan you funded from the Funded Loan Requests section. When the loan period has passed (Days to lend), you can click the Get tokens button to get the tokens from the Smart Contract."
    get-faq-img-link(27)
    p "MetaMask pops up. Accept the transaction."
    get-faq-img-link(28)
    p "Now the tokens are transferred to your wallet."
    get-faq-img-link(29)
    p "When you click back button on your browser or search the loan from All Loan Requests section you should find that the loan is in default stage."
    get-faq-img-link(30)
    p "The token transfer is found at the Ethereum Explorer Etherscan.io if you click the heading of the loan. Now you can either keep the tokens or sell these in the token exchange to cover your loss."
    get-faq-img-link(31)
    p strong "Where can I sell the tokens from defaulted loans?"

    p a href:"https://etherdelta.github.io/",  em "https://etherdelta.github.io/"
    p strong "Where can I get help or assistance?"
    p "Find us on slack channel: " a href:"https://ethlend.slack.com", em "ethlend.slack.com."

    br!, br!, br!