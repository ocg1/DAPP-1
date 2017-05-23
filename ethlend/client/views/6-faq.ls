Router.route \faq path:\/faq

template \faq -> main_blaze div style:'padding-top:50px; width:800px;' class:\container,
    h2  "How to use EthLend with MetaMask"
    br!
    p "Please follow these instructions and you will become a master. Make sure you have MetaMask connected to Main Ethereum Network. You can download MetaMask from " a href:"https://metamask.io/", em "https://metamask.io/"
    p strong "How to request for a loan?"
    p "Click New Loan Request from the menu. Next, click the New loan request button."
    p img src:\faq/image1.jpeg width:\642 height:\252, "MetaMask window will popup. Accept the transaction. 0.01 ETH platform fee is deducted."
    p img src:\faq/image2.jpeg width:\642 height:\281
    p "The transaction is complete and the new loan request is created."
    p img src:\faq/image3.jpeg width:\642 height:\253
    p "Find your loan request by pressing All Loan Requests from the menu. Ethereum might take a while to load."
    p img src:\faq/image4.jpeg width:\642 height:\254
    p "New loan request has the state of “no data”. Small bullet next to the “Borrower” field indicates your loan request. Click the new loan request."
    p img src:\faq/image5.jpeg width:\642 height:\250
    p "Your new loan request is loaded from the Ethereum Blockchain. Might take a while to load."
    p img src:\faq/image6.jpeg width:\642 height:\253
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
    p img src:\faq/image7.jpeg width:\642 height:\326
    p "Below is a sample loan data."
    p img src:\faq/image8.jpg width:\642 height:\430
    p "After you submitted the data, accept the transaction with MetaMask (should pop up)."
    p img src:\faq/image9.jpg width:\642 height:\335
    p "Below message should appear on successful data."
    p img src:\faq/image10.jpeg width:\642 height:\328
    p "Next you need to send tokens to the loan contract. Press back button on your browser and wait or go to All Loan Request and find your latest loan request and click it."
    p "Next, copy the loan request address (which you can find above the Check button)."
    p img src:\faq/image11.jpg width:\642 height:\418
    p "Then go to your Ethereum wallet and send the exact amount of tokens that you have pledged (in this example: 10 Vostoken tokens)."
    p img src:\faq/image12.jpeg width:\642 height:\315
    p "After you have sent the tokens from your wallet, go back to the loan and press the Check that tokens are transferred button. MetaMask will appear and accept the transaction to render the check."
    p img src:\faq/image13.jpg width:\642 height:\334
    p "You should see the following window on success."
    p img src:\faq/image14.jpeg width:\642 height:\327
    p "Now you can press the back button on your browser or search your loan from the All Loan Request section. You loan is now visible for lenders to fund. Now let us hope that your loan is attractive for the lender If not, you can always create a new loan request with more tokens pledged or with a smaller loan amount."
    p img src:\faq/image15.jpg width:\642 height:\408
    p strong "How to fund a loan?"
    p "Go to All Loan Requests. Click a loan that is waiting for lender and you want to fund. You can also see the amount the borrower wants to borrow, the token, and the amount of tokens that are used as a collateral for the loan."
    p img src:\faq/image16.jpeg width:\642 height:\227
    p "When you click the loan, it might take a while that the loan is rendered from the Ethereum Blockchain."
    p img src:\faq/image17.jpeg width:\642 height:\260
    p "Next, you will see the terms of the loan. If you are happy to fund the loan, press Fund this loan request. At this point, the tokens are in the loan agreement as a collateral. If the borrower defaults, the tokens are transferred to your Ethereum address."
    p img src:\faq/image18.jpg width:\642 height:\413
    p "MetaMask will popup. Accept the funding. The loan amount is transferred to the borrower and a fee is deducted by the platform."
    p img src:\faq/image19.jpg width:\642 height:\336
    p "When you see something that corresponds below, you have successfully borrowed Ethers"
    p img src:\faq/image20.jpeg width:\642 height:\275
    p "When you go to the Funded Loan Request, you should see your loan in a funded state. If there are many loans, you might need to shuffle a bit. Click the loan."
    p img src:\faq/image21.jpeg width:\642 height:\223
    p "You should see from the map on right side that the loan is in the Funded state. Now, either the borrower pays the loan on time or the loan defaults and the tokens are transferred to you."
    p "Please keep in mind that different tokens have different value. Use ",
        a href:\https://etherscan.io/tokens,
            em "https://etherscan.io/tokens"
        " or "
        a href:\https://coinmarketcap.com/,
            em "https://coinmarketcap.com/"
        " to value whether the tokens that are used as a collateral cover the loan amount in case of default."
    p img src:\faq/image22.jpg width:\642 height:\423
    p strong "How to pay the loan back?"
    p "Find you the loan you want to pay back from the Funded Loan Requests. Click on Return tokens to get the tokens returned."
    p img src:\faq/image23.jpg width:\642 height:\410
    p "MetaMask pops up. Make sure you have the whole loan amount with premium at your MetaMask account balance. Accept the transaction."
    p img src:\faq/image24.jpg width:\642 height:\330
    p "The loan is paid back and the tokens are transferred to your account. Whoa!"
    p img src:\faq/image25.jpeg width:\642 height:\255
    p "Now if you press back button on your browser or search your loan from the All Loan Requests section, you should see the loan at the Finished stage on the map."
    p img src:\faq/image26.jpg width:\642 height:\419
    p strong "How to claim tokens when the borrower does not pay back?"
    p "Search the loan you funded from the Funded Loan Requests section. When the loan period has passed (Days to lend), you can click the Get tokens button to get the tokens from the Smart Contract."
    p img src:\faq/image27.jpg width:\642 height:\417
    p "MetaMask pops up. Accept the transaction."
    p img src:\faq/image28.jpg width:\642 height:\380
    p "Now the tokens are transferred to your wallet."
    p img src:\faq/image29.jpeg width:\642 height:\229
    p "When you click back button on your browser or search the loan from All Loan Requests section you should find that the loan is in default stage."
    p img src:\faq/image30.jpg width:\642 height:\408
    p "The token transfer is found at the Ethereum Explorer Etherscan.io if you click the heading of the loan. Now you can either keep the tokens or sell these in the token exchange to cover your loss."
    p img src:\faq/image31.jpeg width:\642 height:\147
    p strong "Where can I sell the tokens from defaulted loans?"

    p a href:"https://etherdelta.github.io/",  em "https://etherdelta.github.io/"
    p strong "Where can I get help or assistance?"
    p "Find us on slack channel: " a href:"ethlend.slack.com", em "ethlend.slack.com."

    br!, br!, br!