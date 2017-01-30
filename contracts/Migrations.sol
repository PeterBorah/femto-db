pragma solidity ^0.4.4;

contract Migrations {
  address public admin;
  uint public last_completed_migration;
  address public hub;

  modifier onlyAdmin() {
    if (msg.sender == admin) _;
  }

  function Migrations() {
    admin = msg.sender;
  }

  function setHub(address _hub) onlyAdmin {
    hub = _hub;
  }

  function setCompleted(uint completed) onlyAdmin {
    last_completed_migration = completed;
  }
}
