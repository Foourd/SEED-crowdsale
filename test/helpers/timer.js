// timer for tests specific to testrpc
module.exports = s => new Promise((resolve, reject) => {
  web3.currentProvider.sendAsync({
    jsonrpc: '2.0',
    method: 'evm_increaseTime',
    params: [s],
    id: new Date().getTime(), // Id of the request; anything works, really
  }, (err) => {
    if (err) return reject(err);
    resolve();
  });
});
