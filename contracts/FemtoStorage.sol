pragma solidity ^0.4.8;
import "./FemtoDB.sol";
import "./FemtoStorageConsumer.sol";

// This library is designed for a very specific purpose: replacing native contract storage with a FemtoDB.
// FemtoStorage should only be used by contracts that implement the FemtoStorageConsumer interface.

library FemtoStorage {
  enum DataType { Null, Uint, Address, Bool, List }

  modifier onlyType(uint hash, DataType expectedType) {
    DataType actualType = dataType(hash);
    if (actualType != expectedType && actualType != DataType.Null ) { throw; }
    _;
  }

  // Functions for building keys

  function slotFor(string key) returns(uint) {
    return uint(keccak256(key));
  }

  function slotFor(address key) returns(uint) {
    return uint(keccak256(key));
  }

  function slotFor(uint key) returns(uint) {
    return uint(keccak256(key));
  }

  function and(uint currentHash, address nextKey) returns(uint) {
    return uint(keccak256(currentHash, nextKey));
  }

  function and(uint currentHash, uint nextKey) returns(uint) {
    return uint(keccak256(currentHash, nextKey));
  }

  function and(uint currentHash, string nextKey) returns(uint) {
    return uint(keccak256(currentHash, nextKey));
  }

  // Functions for setting data

  function setType(uint hash, DataType value) {
    uint typeHash = and(hash, "FemtoDBDataType");
    _put(typeHash, uint(value));
  }

  function put(uint hash, bool value) {
    setType(hash, DataType.Bool);
    _put(hash, _toUint(value));
  }

  function put(uint hash, uint value) {
    setType(hash, DataType.Uint);
    _put(hash, value);
  }

  function put(uint hash, address value) {
    setType(hash, DataType.Address);
    _put(hash, uint(value));
  }

  function increment(uint hash) onlyType(hash, DataType.Uint) returns(uint) {
    uint newValue = _db().get(this, this, hash) + 1;
    _db().put(this, hash, newValue);
    return newValue;
  }

  function increaseBy(uint hash, uint amount) onlyType(hash, DataType.Uint) returns(uint) {
    uint newValue = _db().get(this, this, hash) + amount;
    _db().put(this, hash, newValue);
    return newValue;
  }

  function decreaseBy(uint hash, uint amount) onlyType(hash, DataType.Uint) returns(uint) {
    uint newValue = _db().get(this, this, hash) - amount;
    _db().put(this, hash, newValue);
    return newValue;
  }

  // Functions for getting data

  function dataType(uint hash) returns(DataType) {
    return DataType(_get(and(hash, "FemtoDBDataType")));
  }

  function getUint(uint hash) onlyType(hash, DataType.Uint) returns(uint) {
    return _get(hash);
  }

  function getAddress(uint hash) onlyType(hash, DataType.Address) returns(address) {
    return address(_get(hash));
  }

  function getBool(uint hash) onlyType(hash, DataType.Bool) returns(bool) {
    return _toBool(_get(hash));
  }

  // Functions for Lists

  function index(uint hash, uint _index) onlyType(hash, DataType.List) returns(uint) {
    return and(hash, _index);
  }

  function push(uint hash, uint value) {
    _push(hash, value, DataType.Uint);
  }

  function push(uint hash, address value) {
    _push(hash, uint(value), DataType.Address);
  }

  function push(uint hash, bool value) {
    _push(hash, _toUint(value), DataType.Bool);
  }

  function setLength(uint hash, uint length) {
    _put(hash, length);
  }

  function length(uint hash) onlyType(hash, DataType.List) returns(uint) {
    return _get(hash);
  }

  // Helpers

  function _db() returns(FemtoDB) {
    return FemtoStorageConsumer(this).db();
  }

  function _get(uint hash) returns(uint) {
    return _db().get(this, this, hash);
  }

  function _put(uint hash, uint value) {
    _db().put(this, hash, value);
  }

  function _push(uint hash, uint value, DataType dataType) {
    uint length = _get(hash);
    uint indexHash = and(hash, length);

    setType(hash, DataType.List);
    _put(hash, length + 1);

    setType(indexHash, dataType);
    _put(indexHash, value);
  }


  function _toUint(bool value) constant returns(uint) {
    if (value) {
      return 1;
    } else {
      return 0;
    }
  }

  function _toBool(uint value) constant returns(bool) {
    if (value == 0) {
      return false;
    } else if (value == 1) {
      return true;
    } else {
      throw;
    }
  }
}
