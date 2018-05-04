pragma solidity ^0.4.21;

import "./mimime/MiniMeToken.sol";


contract SEED is MiniMeToken {
  function SEED(address _preSEED)
    MiniMeToken(
      0x00,          // _tokenFactory,
      _preSEED,      // _parentToken,
      block.number,  // _parentSnapShotBlock,
      "SEED",        // _tokenName,
      18,            // _decimalUnits,
      "SEED",        // _tokenSymbol,
      false          // _transfersEnabled
    )
    public
  {}
}
