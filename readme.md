## FemtoDB

A simple key/value datastore for Ethereum smart contracts.

### Disclaimer

This library has NOT been security reviewed, pentested, production-hardened, or used in anger. Do not use for any contract intended to control more than, like, $10. There are definitely bugs, and it WILL lose your money.

### NPM

FemtoDB is available on npm as [`femto-db`](https://www.npmjs.com/package/femto-db), and is compatible with [Truffle's beta NPM integration](http://truffleframework.com/tutorials/package-management).

### Basic Usage

The core functions are:

`put(address target, uint256 key, uint256 value)`

which adds data to the database, and:

`get(address owner, address target, uint256 key) constant returns(uint256 value)`

which retrieves it.

* `owner` is automatically set to the address that sends the `put` call. You must provide it for a `get`.
* `target` represents the address the data is "about". In case you want to store data "about" yourself, you can simply provide your own address. 
* `key` is a unsigned integer representing the key.
* `value` is an unsigned integer representing the value.

This API is designed to be as minimal as possible. We recommend using a more convenient interface built on top of this basic API, especially for handling other datatypes. Ownage's interface will be released shortly.

### Synchronization

If you would like to synchronize a `FemtoDB` with an off-chain database, you can watch the following event:

`LogPut(uint256 indexed revisionID, address indexed owner, address indexed target, uint256 key, uint256 value);`

`revisionID` is a simple counter, which increments on each put. It can be used to notice lost messages, or check if your data is stale. There is also a function for accessing the latest `revisionID` directly:

`revisionID() constant returns(uint256)`

### Compatibility with EtherRouter

`FemtoDB` is fully compatible with [EtherRouter](https://github.com/ownage-ltd/ether-router), Ownage's solution for contract upgrades. Simply follow the directions in the [EtherRouter repo](https://github.com/ownage-ltd/ether-router).
