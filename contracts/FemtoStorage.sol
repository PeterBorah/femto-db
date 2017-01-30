pragma solidity ^0.4.8;
import "./FemtoDB.sol";
import "./FemtoStorageConsumer.sol";

// This library is designed for a very specific purpose: replacing native contract storage with a FemtoDB.
// It requires that the contract in which it is imported has a `db()` method that returns a FemtoDB.

library FemtoStorage {
  function _db() returns(FemtoDB) {
    return FemtoStorageConsumer(this).db();
  }

  function keyFor(string key) returns(uint) {
    return uint(keccak256(key));
  }

  function keyFor(address key) returns(uint) {
    return uint(keccak256(key));
  }

  function keyFor(uint key) returns(uint) {
    return uint(keccak256(key));
  }

  function keyFor(uint currentHash, string nextKey) returns(uint) {
    return uint(keccak256(currentHash, nextKey));
  }

  function and(uint currentHash, address nextKey) returns(uint) {
    return uint(keccak256(currentHash, nextKey));
  }

  function and(uint currentHash, uint nextKey) returns(uint) {
    return uint(keccak256(currentHash, nextKey));
  }

  function and(uint currentHash, bytes32 nextKey) returns(uint) {
    return uint(keccak256(currentHash, nextKey));
  }

  function put(uint hash, bool value) {
    _db().put(this, hash, toUint(value));
  }

  function put(uint hash, uint value) {
    _db().put(this, hash, value);
  }

  function put(uint hash, address value) {
    _db().put(this, hash, uint(value));
  }

  function putString(uint hash, string value) returns(address) {
    /* uint dbValue = uint(_hub().stringWrapperFor(value)); */
    /*  */
    /* _db().put(this, hash, dbValue); */
    /* return address(dbValue); */
  }

  function get(uint hash) returns(uint) {
    return _db().get(this, this, hash);
  }

  function increment(uint hash) returns(uint) {
    uint newValue = _db().get(this, this, hash) + 1;
    _db().put(this, hash, newValue);
    return newValue;
  }

  function increaseBy(uint hash, uint amount) returns(uint) {
    uint newValue = _db().get(this, this, hash) + amount;
    _db().put(this, hash, newValue);
    return newValue;
  }

  function decreaseBy(uint hash, uint amount) returns(uint) {
    uint newValue = _db().get(this, this, hash) - amount;
    _db().put(this, hash, newValue);
    return newValue;
  }

  function initializeList(uint hash) returns(address) {
    return putList(hash, new uint[](0));
  }

  function putList(uint hash, uint[] value) returns(address) {
    /* StubListWrapper listWrapper = StubListWrapper(_hub().create(listWrapperID, this)); */
    /* listWrapper.set(value); */
    /*  */
    /* uint dbValue = uint(listWrapper); */
    /* _db().put(this, hash, dbValue); */
    /*  */
    /* return address(listWrapper); */
  }

  function push(uint hash, uint value) {
    uint length = get(hash);
    uint indexHash = and(hash, length);
    put(hash, length + 1);
    put(indexHash, value);
  }

  function length(uint hash) returns(uint) {
    return get(hash);
  }

  function index(uint hash, uint _index) returns(uint) {
    return and(hash, _index);
  }

  function toUint(bool value) constant returns(uint) {
    if (value) {
      return 1;
    } else {
      return 0;
    }
  }

  function toBool(uint value) constant returns(bool) {
    if (value == 0) {
      return false;
    } else if (value == 1) {
      return true;
    } else {
      throw;
    }
  }

  function toAddress(uint value) constant returns(address) {
    return address(value);
  }
}
