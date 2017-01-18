pragma solidity ^0.4.8;

contract FemtoDB {
  event LogPut(uint indexed revisionID, address indexed owner, address indexed target, uint key, uint value);

  // Public API

  function revisionID() constant returns(uint) {
    return _load(keccak256("revisionID"));
  }

  function get(address owner, address target, uint key) constant returns(uint) {
    bytes32 dataLocation = keccak256(owner, target, key);
    return _load(dataLocation);
  }

  function put(address target, uint key, uint value) {
    bytes32 dataLocation = keccak256(msg.sender, target, key);
    _store(dataLocation, value);

    _incrementRevisionID();
    LogPut(revisionID(), msg.sender, target, key, value);
  }

  // Private functions

  function _store(bytes32 dataLocation, uint value) private {
    assembly {
      sstore(dataLocation, value)
    }
  }

  function _load(bytes32 dataLocation) private returns(uint result) {
    assembly {
      result := sload(dataLocation)
    }
  }

  function _incrementRevisionID() private {
    uint newVal = revisionID() + 1;
    _store(keccak256("revisionID"), newVal);
  }
}
