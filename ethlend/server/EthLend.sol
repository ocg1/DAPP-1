pragma solidity ^0.4.16;

contract SafeMath {
     function safeMul(uint a, uint b) internal returns (uint) {
          uint c = a * b;
          assert(a == 0 || c / a == b);
          return c;
     }

     function safeSub(uint a, uint b) internal returns (uint) {
          assert(b <= a);
          return a - b;
     }

     function safeAdd(uint a, uint b) internal returns (uint) {
          uint c = a + b;
          assert(c>=a && c>=b);
          return c;
     }
}

contract ERC20Token {
     function balanceOf(address _address) constant returns (uint balance);
     function transfer(address _to, uint _value) returns (bool success);
}

contract ReputationTokenInterface {
     function issueTokens(address _forAddress, uint _tokenCount) returns (bool success);
     function burnTokens(address _forAddress) returns (bool success);
     function lockTokens(address _forAddress, uint _tokenCount) returns (bool success);
     function unlockTokens(address _forAddress, uint _tokenCount) returns (bool success);
     function approve(address _spender, uint256 _value) returns (bool success);
     function nonLockedTokensCount(address _forAddress) constant returns (uint tokenCount);
}

contract AbstractENS {
     function owner(bytes32 _node) constant returns(address);
     function resolver(bytes32 _node) constant returns(address);
     function ttl(bytes32 _node) constant returns(uint64);
     function setOwner(bytes32 _node, address _owner);
     function setSubnodeOwner(bytes32 _node, bytes32 _label, address _owner);
     function setResolver(bytes32 _node, address _resolver);
     function setTTL(bytes32 _node, uint64 _ttl);
}

contract Registrar {
     function transfer(bytes32, address){
          return;
     } 
}

contract Ledger is SafeMath {
// Fields:
     address public mainAddress = 0x0;        // who deployed Ledger
     address public whereToSendFee = 0x0;
     address public repTokenAddress = 0x0;
     address public ensRegistryAddress = 0x0;
     address public registrarAddress = 0x0;

     mapping (address => mapping(uint => address)) lrsPerUser;
     mapping (address => uint) lrsCountPerUser;

     uint public totalLrCount = 0;
     mapping (uint => address) lrs;

     // 0.01 ETH
     uint public borrowerFeeAmount = 0.01 * 1 ether; 

     modifier byAnyone(){
          _;
     }

// Methods:
     function Ledger(address _whereToSendFee,address _repTokenAddress,address _ensRegistryAddress, address _registrarAddress){
          mainAddress = msg.sender;
          whereToSendFee = _whereToSendFee;
          repTokenAddress = _repTokenAddress;
          ensRegistryAddress = _ensRegistryAddress;
          registrarAddress = _registrarAddress;
     }

     function getRepTokenAddress()constant returns(address out){
          out = repTokenAddress;
          return;
     }

     function getFeeSum()constant returns(uint out){
          out = borrowerFeeAmount;
          return;
     }

     /// Must be called by Borrower
     // tokens as a collateral 
     function createNewLendingRequest()payable byAnyone returns(address out){
          out = newLr(0);
     }
     // domain as a collateral 
     function createNewLendingRequestEns()payable byAnyone returns(address out){
          out = newLr(1);
     }
     // reputation as a collateral
     function createNewLendingRequestRep()payable byAnyone returns(address out){
          out = newLr(2);
     }

     function newLr(int _collateralType)payable byAnyone returns(address out){
          // 1 - send Fee to wherToSendFee 
          uint feeAmount = borrowerFeeAmount;
          require(msg.value>=feeAmount);

          whereToSendFee.transfer(feeAmount);

          // 2 - create new LR (in 'WaitingForData' state)
          out = new LendingRequest(mainAddress,msg.sender,whereToSendFee,_collateralType,ensRegistryAddress,registrarAddress);

          // 3 - add to list
          uint currentCount = lrsCountPerUser[msg.sender];
          lrsPerUser[msg.sender][currentCount] = out;
          lrsCountPerUser[msg.sender]++;

          lrs[totalLrCount] = out;
          totalLrCount++;
          return;
     }

     function getLrCount()constant returns(uint out){
          out = totalLrCount;
          return;
     }

     function getLr(uint _index) constant returns (address out){
          out = lrs[_index];  
          return;
     }

     function getLrCountForUser(address _a)constant returns(uint out){
          out = lrsCountPerUser[_a];
          return;
     }

     function getLrForUser(address _a,uint _index) constant returns (address out){
          out = lrsPerUser[_a][_index];  
          return;
     }

     function getLrFundedCount()constant returns(uint out){
          out = 0;

          for(uint i=0; i<totalLrCount; ++i){
               LendingRequest lr = LendingRequest(lrs[i]);
               if(lr.getState()==LendingRequest.State.WaitingForPayback){
                    out++;
               }
          }

          return;
     }

     function getLrFunded(uint _index) constant returns (address out){
          uint indexFound = 0;
          for(uint i=0; i<totalLrCount; ++i){
               LendingRequest lr = LendingRequest(lrs[i]);
               if(lr.getState()==LendingRequest.State.WaitingForPayback){
                    if(indexFound==_index){
                         out = lrs[i];
                         return;
                    }

                    indexFound++;
               }
          }
          return;
     }

     function addRepTokens(address _potentialBorrower, uint _weiSum){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          LendingRequest lr = LendingRequest(msg.sender);  

          // we`ll check is msg.sender is a real our LendingRequest
          require((lr.borrower()==_potentialBorrower) && (address(this)==lr.creator()));

          // we`ll take a lr contract and check address a – is he a borrower for this contract?
          uint repTokens = (_weiSum/10);
          repToken.issueTokens(_potentialBorrower,repTokens);               
     }

     function lockRepTokens(address _potentialBorrower, uint _weiSum){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          LendingRequest lr = LendingRequest(msg.sender);  

          // we`ll check is msg.sender is a real our LendingRequest
          require((lr.borrower()==_potentialBorrower) && (address(this)==lr.creator()));

          // we`ll take a lr contract and check address a – is he a borrower for this contract?
          uint repTokens = (_weiSum);
          repToken.lockTokens(_potentialBorrower,repTokens);               
     }

     function unlockRepTokens(address _potentialBorrower, uint _weiSum){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          LendingRequest lr = LendingRequest(msg.sender);

          // we`ll check is msg.sender is a real our LendingRequest
          require((lr.borrower()==_potentialBorrower) && (address(this)==lr.creator()));

          // we`ll take a lr contract and check address a – is he a borrower for this contract?
          uint repTokens = (_weiSum);
          repToken.unlockTokens(_potentialBorrower,repTokens);               
     }

     function burnRepTokens(address _potentialBorrower){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          LendingRequest lr = LendingRequest(msg.sender);  

          // we`ll check is msg.sender is a real our LendingRequest
          require((lr.borrower()==_potentialBorrower) && (address(this)==lr.creator()));

          // we`ll take a lr contract and check address a – is he a borrower for this contract?
          repToken.burnTokens(_potentialBorrower);               
     }     

     function approveRepTokens(address _potentialBorrower, uint _weiSum) returns (bool success){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          success = (repToken.nonLockedTokensCount(_potentialBorrower) >= _weiSum);
          return;             
     } 

     function() payable{
          createNewLendingRequest();
     }
}

contract LendingRequest is SafeMath {
// Fields:
     // who deployed Ledger
     address public mainAddress = 0x0;
     string public name = "LendingRequest";
     address public creator = 0x0;
     address public registrarAddress = 0x0;

     // 0.01 ETH
     uint public lenderFeeAmount   = 0.01 * 1 ether;
     
     Ledger ledger;

     enum State {
          WaitingForData,

          // borrower has set data
          WaitingForTokens,
          Cancelled,

          // tokens received from borrower
          WaitingForLender,

          // money received from Lender
          WaitingForPayback,

          Default,

          Finished
     }

     enum Type {
          TokensCollateral,
          EnsCollateral,
          RepCollateral
     }

     State public currentState = State.WaitingForData;
     Type public currentType = Type.TokensCollateral;

     address public whereToSendFee = 0x0;
     uint public start = 0;

     // This must be set by borrower:
     address public borrower = 0x0;
     uint public wanted_wei = 0;
     uint public token_amount = 0;
     uint public premium_wei = 0;
     string public token_name = "";
     bytes32 public ens_domain_hash; 
     string public token_infolink = "";
     address public token_smartcontract_address = 0x0;
     uint public days_to_lend = 0;
     address public ensRegistryAddress = 0;       // this is the address of AbstractENS contract
     address public lender = 0x0;

// Access methods:
     function getBorrower()constant returns(address out){
          out = borrower;
     }

     function getWantedWei()constant returns(uint out){
          out = wanted_wei;
     }

     function getPremiumWei()constant returns(uint out){
          out = premium_wei;
     }

     function getTokenAmount()constant returns(uint out){
          out = token_amount;
     }

     function getTokenName()constant returns(string out){
          out = token_name;
     }

     function getTokenInfoLink()constant returns(string out){
          out = token_infolink;
     }

     function getTokenSmartcontractAddress()constant returns(address out){
          out = token_smartcontract_address;
     }

     function getDaysToLen()constant returns(uint out){
          out = days_to_lend;
     }
     
     function getState()constant returns(State out){
          out = currentState;
          return;
     }

     function getLender()constant returns(address out){
          out = lender;
     }

     function isEns()constant returns(bool out){
          out = (currentType==Type.EnsCollateral);
     }

     function isRep()constant returns(bool out){
          out = (currentType==Type.RepCollateral);
     }


     function getEnsDomainHash()constant returns(bytes32 out){
          out = ens_domain_hash;
     }

// Modifiers:
     modifier byAnyone(){
          _;
     }

     modifier onlyByLedger(){
          require(Ledger(msg.sender)==ledger);
          _;
     }

     modifier onlyByMain(){
          require(msg.sender==mainAddress);
          _;
     }

     modifier byLedgerOrMain(){
          require((msg.sender==mainAddress) || (Ledger(msg.sender)==ledger));
          _;
     }

     modifier byLedgerMainOrBorrower(){
          require((msg.sender==mainAddress) || (Ledger(msg.sender)==ledger) || (msg.sender==borrower));
          _;
     }

     modifier onlyByLender(){
          require(msg.sender==lender);
          _;
     }

     modifier onlyInState(State state){
          require(currentState==state);
          _;
     }

// Methods:
     function LendingRequest(address _mainAddress,address _borrower,address _whereToSendFee, int _contractType, address _ensRegistryAddress, address _registrarAddress){
          ledger = Ledger(msg.sender);

          mainAddress = _mainAddress;
          whereToSendFee = _whereToSendFee;
          registrarAddress = _registrarAddress;
          borrower = _borrower;
          creator = msg.sender;

          // collateral: tokens or ENS domain?
          if (_contractType==0){
               currentType = Type.TokensCollateral;
          }else if(_contractType==1){
               currentType = Type.EnsCollateral;
          }else if(_contractType==2){
               currentType = Type.RepCollateral;
          } else {
               revert();
          }

          ensRegistryAddress = _ensRegistryAddress;
     }

     function changeLedgerAddress(address new_)onlyByLedger{
          ledger = Ledger(new_);
     }

     function changeMainAddress(address new_)onlyByMain{
          mainAddress = new_;
     }

// 
     function setData(uint _wanted_wei, uint _token_amount, uint _premium_wei,
          string _token_name, string _token_infolink_, address _token_smartcontract_address, uint _days_to_lend, bytes32 _ens_domain_hash) byLedgerMainOrBorrower onlyInState(State.WaitingForData)
     {
          wanted_wei = _wanted_wei;
          premium_wei = _premium_wei;
          token_amount = _token_amount; // will be ZERO if isCollateralEns is true 
          token_name = _token_name;
          token_infolink = _token_infolink_;
          token_smartcontract_address = _token_smartcontract_address;
          days_to_lend = _days_to_lend;
          ens_domain_hash = _ens_domain_hash;

          if(currentType==Type.RepCollateral){
               if(ledger.approveRepTokens(borrower, wanted_wei)){
                    ledger.lockRepTokens(borrower, wanted_wei);
                    currentState = State.WaitingForLender;
               }
          } else {
               currentState = State.WaitingForTokens;
          }
     }

     function cancell() byLedgerMainOrBorrower {
          // 1 - check current state
          require((currentState==State.WaitingForData) || (currentState==State.WaitingForLender));

          if(currentState==State.WaitingForLender){
               // return tokens back to Borrower
               releaseToBorrower();
          }
          currentState = State.Cancelled;
     }

     // Should check if tokens are 'trasferred' to this contracts address and controlled
     function checkTokens()byLedgerMainOrBorrower onlyInState(State.WaitingForTokens){
          require(currentType==Type.TokensCollateral);

          ERC20Token token = ERC20Token(token_smartcontract_address);

          uint tokenBalance = token.balanceOf(this);
          if(tokenBalance >= token_amount){
               // we are ready to search someone 
               // to give us the money
               currentState = State.WaitingForLender;
          }
     }

     function checkDomain() onlyInState(State.WaitingForTokens){
          // Use 'ens_domain_hash' to check whether this domain is transferred to this address
          AbstractENS ens = AbstractENS(ensRegistryAddress);
          if(ens.owner(ens_domain_hash)==address(this)){
               // we are ready to search someone 
               // to give us the money
               currentState = State.WaitingForLender;
               return;
          }
     }

     // This function is called when someone sends money to this contract directly.
     //
     // If someone is sending at least 'wanted_wei' amount of money in WaitingForLender state
     // -> then it means it's a Lender.
     //
     // If someone is sending at least 'wanted_wei' amount of money in WaitingForPayback state
     // -> then it means it's a Borrower returning money back. 
     function() payable {
          if(currentState==State.WaitingForLender){
               waitingForLender();
          }else if(currentState==State.WaitingForPayback){
               waitingForPayback();
          }
     }

     // If no lenders -> borrower can cancel the LR
     function returnTokens() byLedgerMainOrBorrower onlyInState(State.WaitingForLender){
          // tokens are released back to borrower
          releaseToBorrower();
          currentState = State.Finished;
     }

     function waitingForLender()payable onlyInState(State.WaitingForLender){
          require(msg.value>=safeAdd(wanted_wei,lenderFeeAmount));

          // send platform fee first
          whereToSendFee.transfer(lenderFeeAmount);

          // if you sent this -> you are the lender
          lender = msg.sender;     

          // ETH is sent to borrower in full
          // Tokens are kept inside of this contract
          borrower.transfer(wanted_wei);

          currentState = State.WaitingForPayback;

          start = now;
     }

     // if time hasn't passed yet - Borrower can return loan back
     // and get his tokens back
     // 
     // anyone can call this (not only the borrower)
     function waitingForPayback()payable onlyInState(State.WaitingForPayback){
          require(msg.value>=safeAdd(wanted_wei,premium_wei));

          // ETH is sent back to lender in full with premium!!!
          lender.transfer(msg.value);

          releaseToBorrower(); // tokens are released back to borrower
          ledger.addRepTokens(borrower,wanted_wei);
          currentState = State.Finished; // finished
     }

     // How much should lender send
     function getNeededSumByLender()constant returns(uint out){
          uint total = safeAdd(wanted_wei,lenderFeeAmount);
          out = total;
          return;
     }

     // How much should borrower return to release tokens
     function getNeededSumByBorrower()constant returns(uint out){
          uint total = safeAdd(wanted_wei,premium_wei);
          out = total;
          return;
     }

     // After time has passed but lender hasn't returned the loan -> move tokens to lender
     // anyone can call this (not only the lender)
     function requestDefault()onlyInState(State.WaitingForPayback){
          require(now >= (start + days_to_lend * 1 days));

          releaseToLender(); // tokens are released to the lender        
          currentState = State.Default; 
     }

     function releaseToLender() internal {
          if(currentType==Type.EnsCollateral){
               AbstractENS ens = AbstractENS(ensRegistryAddress);
               Registrar registrar = Registrar(registrarAddress);

               ens.setOwner(ens_domain_hash,lender);
               registrar.transfer(ens_domain_hash,lender);
          }else if (currentType==Type.RepCollateral){
               ledger.unlockRepTokens(borrower, wanted_wei);
          }else{
               ERC20Token token = ERC20Token(token_smartcontract_address);
               uint tokenBalance = token.balanceOf(this);
               token.transfer(lender,tokenBalance);
          }

          ledger.burnRepTokens(borrower);
     }

     function releaseToBorrower() internal {
          if(currentType==Type.EnsCollateral){
               AbstractENS ens = AbstractENS(ensRegistryAddress);
               Registrar registrar = Registrar(registrarAddress);
               ens.setOwner(ens_domain_hash,borrower);
               registrar.transfer(ens_domain_hash,borrower);
          }else if (currentType==Type.RepCollateral){
               ledger.unlockRepTokens(borrower, wanted_wei);
          }else{
               ERC20Token token = ERC20Token(token_smartcontract_address);
               uint tokenBalance = token.balanceOf(this);
               token.transfer(borrower,tokenBalance);
          }
     }
}

