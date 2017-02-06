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
    FemtoStorage.slotFor("foo").put(initial);
    uint result = FemtoStorage.slotFor("foo").getUint();

    Assert.equal(result, initial, "didn't get back stored value");    
  }

  function testAndWorksWithDifferentDatatypes() {
    FemtoStorage.slotFor("foo").and("bar").and(uint(2)).and(this).put(uint(42));
    uint result = FemtoStorage.slotFor("foo").and("bar").and(uint(2)).and(this).getUint();

    Assert.equal(result, 42, "didn't get back stored value");
  }

  function testGetUintThrowsForWrongType() {
    FemtoStorage.slotFor("bing").put(address(42));

    // Needs to be roundabout like this until Solidity has 'catch' blocks
    uint hash = FemtoStorage.slotFor("bing");
    bool result = this.call(stringToSig("checkGetUint(uint256)"), hash);
    Assert.equal(result, false, "getUint call didn't throw");
  }

  function checkGetUint(uint hash) {
    FemtoStorage.getUint(hash);
  }

  function testIncrement() {
    uint initial = 42;
    FemtoStorage.slotFor("foo").put(initial);
    
    FemtoStorage.slotFor("foo").increment();
    uint result = FemtoStorage.slotFor("foo").getUint();

    Assert.equal(result, 43, "didn't increment correctly");    
  }

  function testIncrementThrowsForNonUint() {
    FemtoStorage.slotFor("bing").put(address(42));

    // Needs to be roundabout like this until Solidity has 'catch' blocks
    uint hash = FemtoStorage.slotFor("bing");
    bool result = this.call(stringToSig("checkIncrement(uint256)"), hash);
    Assert.equal(result, false, "increment call didn't throw");
  }

  function checkIncrement(uint hash) {
    FemtoStorage.increment(hash);
  }

  function testIncreaseBy() {
    uint initial = 42;
    FemtoStorage.slotFor("foo").put(initial);
    
    FemtoStorage.slotFor("foo").increaseBy(3);
    uint result = FemtoStorage.slotFor("foo").getUint();

    Assert.equal(result, 45, "didn't increase by 3");    
  }

  function testIncreaseByThrowsForNonUint() {
    FemtoStorage.slotFor("bing").put(address(42));

    // Needs to be roundabout like this until Solidity has 'catch' blocks
    uint hash = FemtoStorage.slotFor("bing");
    bool result = this.call(stringToSig("checkIncreaseBy(uint256)"), hash);
    Assert.equal(result, false, "increaseBy call didn't throw");
  }

  function checkIncreaseBy(uint hash) {
    FemtoStorage.increaseBy(hash, 2);
  }

  function testDecreaseBy() {
    uint initial = 42;
    FemtoStorage.slotFor("foo").put(initial);
    
    FemtoStorage.slotFor("foo").decreaseBy(4);
    uint result = FemtoStorage.slotFor("foo").getUint();

    Assert.equal(result, 38, "didn't decrease by 4");    
  }

  function testDecreaseByThrowsForNonUint() {
    FemtoStorage.slotFor("bing").put(address(42));

    // Needs to be roundabout like this until Solidity has 'catch' blocks
    uint hash = FemtoStorage.slotFor("bing");
    bool result = this.call(stringToSig("checkDecreaseBy(uint256)"), hash);
    Assert.equal(result, false, "decreaseBy call didn't throw");
  }

  function checkDecreaseBy(uint hash) {
    FemtoStorage.decreaseBy(hash, 3);
  }

  function testStoringAddress() {
    address initial = this;
    FemtoStorage.slotFor("someKey").put(initial);
    address result = FemtoStorage.slotFor("someKey").getAddress();

    Assert.equal(result, initial, "didn't get back stored value");    
  }

  function testGetAddressThrowsForWrongType() {
    FemtoStorage.slotFor("bing").put(uint(42));

    uint hash = FemtoStorage.slotFor("bing");
    bool result = this.call(stringToSig("checkGetAddress(uint256)"), hash);
    Assert.equal(result, false, "getAddress call didn't throw");
  }

  function checkGetAddress(uint hash) {
    FemtoStorage.getAddress(hash);
  }

  function testStoringBool() {
    bool initial = true;
    FemtoStorage.slotFor("someKey").put(initial);
    bool result = FemtoStorage.slotFor("someKey").getBool();

    Assert.equal(result, initial, "didn't get back stored value");    
  }

  function testGetBoolThrowsForWrongType() {
    FemtoStorage.slotFor("bing").put(uint(42));

    uint hash = FemtoStorage.slotFor("bing");
    bool result = this.call(stringToSig("checkGetBool(uint256)"), hash);
    Assert.equal(result, false, "getBool call didn't throw");
  }

  function checkGetBool(uint hash) {
    FemtoStorage.getBool(hash);
  }

  function testList() {
    FemtoStorage.slotFor("bar").push(uint(42));
    FemtoStorage.slotFor("bar").push(uint(23));
    FemtoStorage.slotFor("bar").index(1).put(uint(24));
    Assert.equal(2, FemtoStorage.slotFor("bar").length(), "length was not incremented correctly");
    Assert.equal(42, FemtoStorage.slotFor("bar").index(0).getUint(), "the first was not set correctly by 'push'");
    Assert.equal(24, FemtoStorage.slotFor("bar").index(1).getUint(), "the second value was not set correctly by 'index.put'");
  }

  function testSetLength() {
    FemtoStorage.slotFor("boop").setLength(3);
    FemtoStorage.slotFor("boop").index(1).put(uint(25));
    Assert.equal(3, FemtoStorage.slotFor("boop").length(), "length was not set correctly");
    Assert.equal(0, FemtoStorage.slotFor("boop").index(0).getUint(), "unset location was not 0");
    Assert.equal(25, FemtoStorage.slotFor("boop").index(1).getUint(), "the second value was not set correctly by 'index.put'");
    Assert.equal(0, FemtoStorage.slotFor("boop").index(2).getUint(), "unset location was not 0");
  }

  function testPushingAddresses() {
    FemtoStorage.slotFor("bar").push(address(42));
    FemtoStorage.slotFor("bar").push(address(23));
    FemtoStorage.slotFor("bar").index(1).put(this);
    Assert.equal(2, FemtoStorage.slotFor("bar").length(), "length was not incremented correctly");
    Assert.equal(address(42), FemtoStorage.slotFor("bar").index(0).getAddress(), "the first was not set correctly by 'push'");
    Assert.equal(this, FemtoStorage.slotFor("bar").index(1).getAddress(), "the second value was not set correctly by 'index.put'");
  }

  function testLengthThrowsForNonList() {
    FemtoStorage.slotFor("baz").put(uint(42));

    uint hash = FemtoStorage.slotFor("baz");
    bool result = this.call(stringToSig("checkLength(uint256)"), hash);
    Assert.equal(result, false, "length call didn't throw");
  }

  function checkLength(uint hash) {
    hash.length();
  }

  function testIndexThrowsForNonList() {
    FemtoStorage.slotFor("fleep").put(uint(42));

    uint hash = FemtoStorage.slotFor("fleep");
    bool result = this.call(stringToSig("checkIndex(uint256)"), hash);
    Assert.equal(result, false, "index call didn't throw");
  }

  function checkIndex(uint hash) {
    hash.index(0);
  }

  function stringToSig(string signature) constant returns(bytes4) {
    return bytes4(keccak256(signature));                           
  }                                                                
}
