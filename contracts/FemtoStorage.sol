pragma solidity ^0.4.8;
import "./FemtoDB.sol";
import "./FemtoStorageConsumer.sol";

// This library is designed for a very specific purpose: replacing native contract storage with a FemtoDB.
// It requires that the contract in which it is imported has a `db()` method that returns a FemtoDB.

library FemtoStorage {
  enum DataType { Null, Uint, Address, Bool, List }

  modifier onlyType(uint hash, DataType _type) {
    if (dataType(hash) != _type) { throw; }
    _;
  }

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

  function index(uint hash, uint _index) onlyType(hash, DataType.List) returns(uint) {
    return and(hash, _index);
  }

  function put(uint hash, bool value) {
    setType(hash, DataType.Bool);
    _put(hash, toUint(value));
  }

  function put(uint hash, uint value) {
    setType(hash, DataType.Uint);
    _put(hash, value);
  }

  function put(uint hash, address value) {
    setType(hash, DataType.Address);
    _put(hash, uint(value));
  }

  function setType(uint hash, DataType value) {
    uint typeHash = and(hash, "type");
    _put(typeHash, uint(value));
  }

  function _put(uint hash, uint value) {
    _db().put(this, hash, value);
  }

  function getUint(uint hash) onlyType(hash, DataType.Uint) returns(uint) {
    return _get(hash);
  }

  function getAddress(uint hash) onlyType(hash, DataType.Address) returns(address) {
    return address(_get(hash));
  }

  function getBool(uint hash) onlyType(hash, DataType.Bool) returns(bool) {
    return toBool(_get(hash));
  }

  function _get(uint hash) returns(uint) {
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

  function push(uint hash, uint value) {
    uint length = _get(hash);
    uint indexHash = and(hash, length);

    setType(hash, DataType.List);
    _put(hash, length + 1);

    setType(indexHash, DataType.Uint);
    _put(indexHash, value);
  }

  function dataType(uint hash) returns(DataType) {
    return DataType(_get(and(hash, "type")));
  }

  function length(uint hash) onlyType(hash, DataType.List) returns(uint) {
    return _get(hash);
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
}
