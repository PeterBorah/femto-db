pragma solidity ^0.4.8;

contract DB {
  // Hierarchy is owner => target => key => value
  mapping(address => mapping(address => mapping(uint => uint))) public data;

  event LogPut(uint indexed revisionID, address indexed owner, address indexed target, uint key, uint value);

  function revisionID() constant returns(uint) {
    return data[this][this][uint(sha3("revisionID"))];
  }

  function _incrementRevisionID() private {
    data[this][this][uint(sha3("revisionID"))] = data[this][this][uint(sha3("revisionID"))] + 1;
  }

  function put(address target, uint key, uint value) {
    data[msg.sender][target][key] = value;
    _incrementRevisionID();
    LogPut(revisionID(), msg.sender, target, key, value);
  }

  function get(address owner, address target, uint key) constant returns(uint) {
    return data[owner][target][key];
  }
}
