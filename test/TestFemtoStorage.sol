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
    uint result = FemtoStorage.keyFor("foo").get();

    Assert.equal(result, initial, "didn't get back stored value");    
  }

  function testArray() {
    FemtoStorage.keyFor("bar").push(42);
    FemtoStorage.keyFor("bar").push(23);
    FemtoStorage.keyFor("bar").index(1).put(uint(24));
    Assert.equal(2, FemtoStorage.keyFor("bar").length(), "length was not incremented correctly");
    Assert.equal(42, FemtoStorage.keyFor("bar").index(0).get(), "the first was not set correctly by 'push'");
    Assert.equal(24, FemtoStorage.keyFor("bar").index(1).get(), "the second value was not set correctly by 'index.put'");
  }
}
