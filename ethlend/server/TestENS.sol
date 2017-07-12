pragma solidity ^0.4.4;

contract AbstractENS {
     function owner(bytes32 node) constant returns(address){
          return 0;
     }

     function resolver(bytes32 node) constant returns(address){
          return 0;
     }

     function ttl(bytes32 node) constant returns(uint64){
          return 0;
     }

     function setOwner(bytes32 node, address owner){
     }

     function setSubnodeOwner(bytes32 node, bytes32 label, address owner){
     }
     
     function setResolver(bytes32 node, address resolver){
     }

     function setTTL(bytes32 node, uint64 ttl){
     }

     // Logged when the owner of a node assigns a new owner to a subnode.
     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);

     // Logged when the owner of a node transfers ownership to a new account.
     event Transfer(bytes32 indexed node, address owner);

     // Logged when the resolver for a node changes.
     event NewResolver(bytes32 indexed node, address resolver);

     // Logged when the TTL of a node changes
     event NewTTL(bytes32 indexed node, uint64 ttl);
}

// this is just a fake contract for tests!
contract TestENS is AbstractENS {
     function owner(bytes32 node) constant returns(address out){
          out = owner_;
          return;
     }

     function setOwner(bytes32 node, address o){
          owner_ = o; 
     }
     
     address public owner_;
}
