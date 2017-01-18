pragma solidity ^0.4.8;

contract FemtoDB {
  event LogPut(uint indexed revisionID, address indexed owner, address indexed target, uint key, uint value);

  function revisionID() constant returns(uint) {
    return get(this, this, uint(keccak256("revisionID")));
  }

  function put(address target, uint key, uint value) {
    _put(msg.sender, target, key, value);
    _incrementRevisionID();
    LogPut(revisionID(), msg.sender, target, key, value);
  }

  function get(address owner, address target, uint key) constant returns(uint result) {
    bytes32 dataLocation = keccak256(owner, target, key);
    assembly {
      result := sload(dataLocation)
    } 
  }

  function _put(address sender, address target, uint key, uint value) private {
    bytes32 dataLocation = keccak256(sender, target, key);

    _store(dataLocation, value);
  }

  function _store(bytes32 dataLocation, uint value) private {
    assembly {
      sstore(dataLocation, value)
    }
  }

  function _incrementRevisionID() private {
    uint newVal = revisionID() + 1;
    _put(this, this, uint(keccak256("revisionID")), newVal);
  }
}
