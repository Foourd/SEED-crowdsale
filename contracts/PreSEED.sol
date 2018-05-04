pragma solidity ^0.4.21;

import "./mimime/MiniMeToken.sol";


contract PreSEED is MiniMeToken {
  function PreSEED()
    MiniMeToken(
      0x00,                     // _tokenFactory,
      0x00,                     // _parentToken,
      0,                        // _parentSnapShotBlock,
      "SEED Pre-release token", // _tokenName,
      18,                       // _decimalUnits,
      "SPT",                    // _tokenSymbol,
      false                     // _transfersEnabled
    )
    public
  {}
}
