require('babel-register');
require('babel-polyfill');

const HDWalletProvider = require('truffle-hdwallet-provider');
require('dotenv').config();

const mnemonic = process.env.MNEMONIC || 'foourd seed foourd seed foourd seed foourd seed foourd seed foourd seed';
const mnemonicTest = process.env.MNEMONIC_TEST || 'foourd seed foourd seed foourd seed foourd seed foourd seed foourd seed';

const providerUrls = {
  mainnet: 'https://mainnet.infura.io',
  ropsten: 'https://ropsten.infura.io',
  localhost: 'http://localhost:8545',
};

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // eslint-disable-line camelcase
      gas: 4700000,
      gasPrice: 20e9,
    },
    test: {
      network_id: '*', // eslint-disable-line camelcase
      provider () {
        return new HDWalletProvider(mnemonicTest, providerUrls.localhost, 0, 50);
      },
      gas: 4700000,
      gasPrice: 100e9,
    },
    ropsten: {
      network_id: 3, // eslint-disable-line camelcase
      provider () {
        return new HDWalletProvider(mnemonic, providerUrls.ropsten, 0, 50);
      },
      gas: 4700000,
      gasPrice: 100e9,
    },
    mainnet: {
      network_id: '1', // eslint-disable-line camelcase
      provider () {
        return new HDWalletProvider(mnemonic, providerUrls.mainnet, 0, 50);
      },
      gas: 4700000,
      gasPrice: 25e9,
    },
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
};
