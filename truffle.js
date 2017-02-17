module.exports  = {
  networks: {
    development: {
      host:       "localhost",
      port:       8545,
      network_id: "*",
      gas:        9999999 // For the Solidity tests.
    }
  }
};
