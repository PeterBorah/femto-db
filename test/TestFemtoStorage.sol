pragma solidity ^0.4.8;
import "../contracts/FemtoDB.sol";
import "../contracts/FemtoStorage.sol";
import "truffle/Assert.sol"; 

contract TestFemtoStorage {
  using FemtoStorage for uint;

  FemtoDB public db;

  function beforeEach() {
    db = new FemtoDB();
  }

  function testStoringUint() {
    uint initial = 42;
    FemtoStorage.keyFor("foo").put(initial);
    uint result = FemtoStorage.keyFor("foo").getUint();

    Assert.equal(result, initial, "didn't get back stored value");    
  }

  function testGetUintThrowsForWrongType() {
    FemtoStorage.keyFor("bing").put(address(42));

    uint hash = FemtoStorage.keyFor("bing");
    bool result = this.call(stringToSig("checkGetUint(uint256)"), hash);
    Assert.equal(result, false, "getUint call didn't throw");
  }

  function checkGetUint(uint hash) {
    FemtoStorage.getUint(hash);
  }

  function testArray() {
    FemtoStorage.keyFor("bar").push(42);
    FemtoStorage.keyFor("bar").push(23);
    FemtoStorage.keyFor("bar").index(1).put(uint(24));
    Assert.equal(2, FemtoStorage.keyFor("bar").length(), "length was not incremented correctly");
    Assert.equal(42, FemtoStorage.keyFor("bar").index(0).getUint(), "the first was not set correctly by 'push'");
    Assert.equal(24, FemtoStorage.keyFor("bar").index(1).getUint(), "the second value was not set correctly by 'index.put'");
  }

  function testLengthThrowsForNonArray() {
    FemtoStorage.keyFor("baz").put(uint(42));

    uint hash = FemtoStorage.keyFor("baz");
    bool result = this.call(stringToSig("checkLength(uint256)"), hash);
    Assert.equal(result, false, "length call didn't throw");
  }

  function checkLength(uint hash) {
    hash.length();
  }

  function stringToSig(string signature) constant returns(bytes4) {
    return bytes4(keccak256(signature));                           
  }                                                                
}
