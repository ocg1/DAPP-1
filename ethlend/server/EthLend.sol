pragma solidity ^0.4.16;

/**
 * @title SafeMath by OpenZeppelin
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title ERC20 interface, by OpenZeppelin
 */
contract ERC20Token {
     function balanceOf(address who) public constant returns (uint256);
     function transfer(address to, uint256 value) public returns (bool);
     function allowance(address owner, address spender) public constant returns (uint256);
     function transferFrom(address from, address to, uint256 value) public returns (bool);
     function approve(address spender, uint256 value) public returns (bool);
}

contract ReputationTokenInterface {
     function issueTokens(address forAddress, uint tokenCount) returns (bool success);
     function burnTokens(address forAddress) returns (bool success);
     function lockTokens(address forAddress, uint tokenCount) returns (bool success);
     function unlockTokens(address forAddress, uint tokenCount) returns (bool success);
     function approve(address _spender, uint256 _value) returns (bool success);
     function nonLockedTokensCount(address forAddress) constant returns (uint tokenCount);
}

contract AbstractENS {
     function owner(bytes32 node) constant returns(address);
     function resolver(bytes32 node) constant returns(address);
     function ttl(bytes32 node) constant returns(uint64);
     function setOwner(bytes32 node, address owner);
     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
     function setResolver(bytes32 node, address resolver);
     function setTTL(bytes32 node, uint64 ttl);
}

contract Registrar {
     function transfer(bytes32, address);
}


contract Ledger {     
     address public mainAddress;             //Contract Owner/Deployer address
     address public whereToSendFee;          //Platform fee collector address
     address public repTokenAddress;         //ReputationToken contract address
     address public ensRegistryAddress;      //ENS Registry address
     address public registrarAddress;        //Registrar address

     uint public totalLrCount = 0;           //Total count of LendingRequest created
     uint public borrowerFeeAmount = 0.01 ether; //Platform fee for Borrower

     mapping (address => mapping(uint => address)) lrsPerUser; //Mapping of LendingRequests per User
     mapping (address => uint) lrsCountPerUser;                //Lending request count per User
     mapping (uint => address) lrs;                            //Lending Requests

     
     function Ledger(address _whereToSendFee,     address _repTokenAddress, 
                     address _ensRegistryAddress, address _registrarAddress){
          mainAddress = msg.sender;
          whereToSendFee = _whereToSendFee;
          repTokenAddress = _repTokenAddress;
          ensRegistryAddress = _ensRegistryAddress;
          registrarAddress = _registrarAddress;
     }

     function getFeeSum() constant returns(uint){ return borrowerFeeAmount; }
     function getRepTokenAddress() constant returns(address){ return repTokenAddress; }
     function getLrCount() constant returns(uint){ return totalLrCount; }
     function getLr(uint _index) constant returns (address){ return lrs[_index]; }
     function getLrCountForUser(address _addr) constant returns(uint){ return lrsCountPerUser[_addr]; }
     function getLrForUser(address _addr, uint _index) constant returns (address){ return lrsPerUser[_addr][_index]; }

     
     /// Must be called by Borrower
     // tokens as a collateral 
     function createNewLendingRequest() payable returns(address){
          return newLr(0);
     }

     // domain as a collateral 
     function createNewLendingRequestEns() payable returns(address){
          return newLr(1);
     }
     // reputation as a collateral
     function createNewLendingRequestRep() payable returns(address){
          return newLr(2);
     }

     function newLr(int _collateralType) payable returns(address out){
          // 1 - send Fee to wherToSendFee           
          if(msg.value < borrowerFeeAmount){
               revert();
          }

          whereToSendFee.transfer(borrowerFeeAmount);

          // 2 - create new LR
          // will be in state 'WaitingForData'
          out = new LendingRequest(msg.sender, _collateralType);

          // 3 - add to list
          uint currentCount = lrsCountPerUser[msg.sender];
          lrsPerUser[msg.sender][currentCount] = out;
          lrsCountPerUser[msg.sender]++;

          lrs[totalLrCount] = out;
          totalLrCount++;
     }


     function getLrFundedCount() constant returns(uint out){
          out = 0;

          for(uint i=0; i<totalLrCount; ++i){
               LendingRequest lr = LendingRequest(lrs[i]);
               if(lr.getState() == LendingRequest.State.WaitingForPayback){
                    out++;
               }
          }

          return;
     }

     function getLrFunded(uint index) constant returns (address){          
          LendingRequest lr = LendingRequest(lrs[index]);
          if(lr.getState() == LendingRequest.State.WaitingForPayback){
               return lrs[index];
          } else {
               return 0;
          }
     }

     function addRepTokens(address _potentialBorrower, uint _weiSum){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          LendingRequest lr = LendingRequest(msg.sender);  
          // we`ll check is msg.sender is a real our LendingRequest
          if(lr.borrower() == _potentialBorrower && address(this) == lr.creator()){// we`ll take a lr contract and check address a – is he a borrower for this contract?
               uint repTokens = _weiSum / 10;
               repToken.issueTokens(_potentialBorrower,repTokens);               
          }
     }

     function lockRepTokens(address _potentialBorrower, uint _weiSum){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          LendingRequest lr = LendingRequest(msg.sender);  
          // we`ll check is msg.sender is a real our LendingRequest
          if(lr.borrower() == _potentialBorrower && address(this)==lr.creator()){// we`ll take a lr contract and check address a – is he a borrower for this contract?
               uint repTokens = _weiSum;
               repToken.lockTokens(_potentialBorrower, repTokens);               
          }
     }

     function unlockRepTokens(address _potentialBorrower, uint _weiSum){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          LendingRequest lr = LendingRequest(msg.sender);
          // we`ll check is msg.sender is a real our LendingRequest
          if(lr.borrower() == _potentialBorrower && address(this)==lr.creator()){// we`ll take a lr contract and check address a – is he a borrower for this contract?
               uint repTokens = _weiSum;
               repToken.unlockTokens(_potentialBorrower, repTokens);               
          }
     }

     function burnRepTokens(address _potentialBorrower){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          LendingRequest lr = LendingRequest(msg.sender);  
          // we`ll check is msg.sender is a real our LendingRequest
          if(lr.borrower() == _potentialBorrower && address(this) == lr.creator()){// we`ll take a lr contract and check address a – is he a borrower for this contract?
               repToken.burnTokens(_potentialBorrower);               
          }
     }     

     function approveRepTokens(address _potentialBorrower,uint _weiSum) returns (bool success){
          ReputationTokenInterface repToken = ReputationTokenInterface(repTokenAddress);
          success = repToken.nonLockedTokensCount(_potentialBorrower) >= _weiSum;
          return;             
     } 

     function() payable{
          createNewLendingRequest();
     }
}

/*
 * LendingRequest Contract will be created for each loan request.
 */
contract LendingRequest {
     /* Different states of LendingRequest contract */
     enum State {
          WaitingForData,     //Initial state
          WaitingForTokens,   //Waiting for ERC20 tokens from Borrower
          Cancelled,          //When loan cancelled
          WaitingForLender,   //When ERC20 tokens received from borrower, now looing for Lender
          WaitingForPayback,  //When money received from Lender and sent to Borrower
          Default,            //When loan defaulted by Borrower
          Finished            //When loan paid in full by Borrower and finished 
     }

     /* Collateral Types */
     enum Type {
          TokensCollateral,   //Tokens as a Collateral
          EnsCollateral,      //ENS Domain as a Collateral
          RepCollateral       //Reputation tokens as a Collateral
     }

     using SafeMath for uint256;               //SafeMath Library using for uint256
     Ledger ledger;                            //Ledger Contract
     address public creator            = 0x0;  //Creator of this contract, always be Ledger's address
     address public registrarAddress   = 0x0;  //Registrar contract address
     address public ensRegistryAddress = 0x0;  //This is an address of AbstractENS contract
     address public mainAddress        = 0x0;  //Who deployed Parent Ledger
     address public whereToSendFee     = 0x0;  //Platform fee will be sent to this wallet address

     uint public lenderFeeAmount = 0.01 ether;            //Lender's platform fee
     State public currentState   = State.WaitingForData;  //Initial state WaitingForData
     Type public currentType     = Type.TokensCollateral; //Initialized with Tokens Collateral 

     

     /* These variables will be set by borrower: */
     address public borrower  = 0x0;                     //Borrower's wallet address
     uint public wanted_wei   = 0;                       //How much wei Borrower request from Lender
     uint public premium_wei  = 0;                       //How much premium in wei Borrower wants to pay to Lender
     uint public token_amount = 0;                       //Count of ERC20-tokens Borrower wants to put as collateral
     uint public days_to_lend = 0;                       //Number of days to lend the loan
     string public token_name = "";                      //Name of the ERC20-token Borrower putting as a collateral
     bytes32 public ens_domain_hash;                     //ENS Domain hash which Borrower putting as a collateral
     string public token_infolink = "";                  //Token info link (optional)
     address public token_smartcontract_address = 0x0;   //ERC20 Token's contract address
     

     /* These variables will be set when Lender is found */
     uint public start     = 0;    //Holds the startTime of the loan when loan Funded
     address public lender = 0x0;  //Lender's wallet address


     /* Constants Methods: */
     function isEns() constant returns(bool){ return (currentType==Type.EnsCollateral); }
     function isRep() constant returns(bool){ return (currentType==Type.RepCollateral); }
     function getState() constant returns(State){ return currentState; }
     function getLender() constant returns(address){ return lender; }     
     function getBorrower() constant returns(address){ return borrower; }
     function getWantedWei() constant returns(uint){ return wanted_wei; }
     function getTokenName() constant returns(string){ return token_name; }
     function getDaysToLen() constant returns(uint){ return days_to_lend; }
     function getPremiumWei() constant returns(uint){ return premium_wei; }
     function getTokenAmount() constant returns(uint){ return token_amount; }     
     function getTokenInfoLink() constant returns(string){ return token_infolink; }
     function getEnsDomainHash() constant returns(bytes32){ return ens_domain_hash; }
     function getTokenSmartcontractAddress() constant returns(address){ return token_smartcontract_address; }
               
     
     modifier onlyByLedger(){
          require(Ledger(msg.sender) == ledger);
          _;
     }

     modifier onlyByMain(){
          require(msg.sender == mainAddress);
          _;
     }

     modifier byLedgerOrMain(){
          require(msg.sender == mainAddress || Ledger(msg.sender) == ledger);
          _;
     }

     modifier byLedgerMainOrBorrower(){
          require(msg.sender == mainAddress || Ledger(msg.sender) == ledger || msg.sender == borrower);
          _;
     }

     modifier onlyByLender(){
          require(msg.sender == lender);
          _;
     }

     modifier onlyInState(State state){
          require(currentState == state);
          _;
     }

     function LendingRequest(address _borrower, int _collateralType){
          creator = msg.sender;
          ledger = Ledger(msg.sender);

          borrower = _borrower;
          mainAddress = ledger.mainAddress();
          whereToSendFee = ledger.whereToSendFee();
          registrarAddress = ledger.registrarAddress();
          ensRegistryAddress = ledger.ensRegistryAddress();
                    
          // collateral: tokens or ENS domain?
          if (_collateralType == 0){
               currentType = Type.TokensCollateral;
          } else if(_collateralType == 1){
               currentType = Type.EnsCollateral;
          } else if(_collateralType == 2){
               currentType = Type.RepCollateral;
          } else {
               revert();
          }
          
     }

     function changeLedgerAddress(address _new) onlyByLedger{
          ledger = Ledger(_new);
     }

     function changeMainAddress(address _new) onlyByMain{
          mainAddress = _new;
     }

     function setData(uint _wanted_wei, uint _token_amount, uint _premium_wei,
                         string _token_name, string _token_infolink, address _token_smartcontract_address, 
                         uint _days_to_lend, bytes32 _ens_domain_hash) 
               byLedgerMainOrBorrower onlyInState(State.WaitingForData)
     {
          wanted_wei = _wanted_wei;
          premium_wei = _premium_wei;
          token_amount = _token_amount; // will be ZERO if isCollateralEns is true 
          token_name = _token_name;
          token_infolink = _token_infolink;
          token_smartcontract_address = _token_smartcontract_address;
          days_to_lend = _days_to_lend;
          ens_domain_hash = _ens_domain_hash;

          if(currentType == Type.RepCollateral){
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
          if((currentState != State.WaitingForData) && (currentState != State.WaitingForLender))
               revert();

          if(currentState == State.WaitingForLender){
               // return tokens back to Borrower
               releaseToBorrower();
          }
          currentState = State.Cancelled;
     }

     // Should check if tokens are 'trasferred' to this contracts address and controlled
     function checkTokens() byLedgerMainOrBorrower onlyInState(State.WaitingForTokens){
          if(currentType != Type.TokensCollateral){
               revert();
          }

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
          if(currentState == State.WaitingForLender){
               waitingForLender();
          } else if(currentState == State.WaitingForPayback){
               waitingForPayback();
          } else {
               revert(); //In any other state, do not accept Ethers
          }
     }

     // If no lenders -> borrower can cancel the LR
     function returnTokens() byLedgerMainOrBorrower onlyInState(State.WaitingForLender){
          // tokens are released back to borrower
          releaseToBorrower();
          currentState = State.Finished;
     }

     function waitingForLender() payable onlyInState(State.WaitingForLender){
          if(msg.value < wanted_wei.add(lenderFeeAmount)){
               revert();
          }

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
     function waitingForPayback() payable onlyInState(State.WaitingForPayback){
          if(msg.value < wanted_wei.add(premium_wei)){
               revert();
          }
          // ETH is sent back to lender in full with premium!!!
          lender.transfer(msg.value);

          releaseToBorrower(); // tokens are released back to borrower
          ledger.addRepTokens(borrower,wanted_wei);
          currentState = State.Finished; // finished
     }

     // How much should lender send
     function getNeededSumByLender() constant returns(uint){
          return wanted_wei.add(lenderFeeAmount);
     }

     // How much should borrower return to release tokens
     function getNeededSumByBorrower()constant returns(uint){
          return wanted_wei.add(premium_wei);
     }

     // After time has passed but lender hasn't returned the loan -> move tokens to lender
     // anyone can call this (not only the lender)
     function requestDefault() onlyInState(State.WaitingForPayback){
          if(now < (start + days_to_lend * 1 days)){
               revert();
          }

          releaseToLender(); // tokens are released to the lender        
          // ledger.addRepTokens(lender,wanted_wei); // Only Lender get Reputation tokens
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

