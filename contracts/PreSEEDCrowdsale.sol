pragma solidity ^0.4.21;

import "./PreSEED.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/distribution/utils/RefundVault.sol";


contract FinalizeReceiver {
  function onPresaleFinalized(uint256 _weiRaised) public returns (bool);
}


contract PreSEEDCrowdsale is Ownable, CanReclaimToken, Pausable {
  using SafeMath for uint256;

  // States
  PreSEED token;
  RefundVault vault;

  uint256 public startTime;
  uint256 public endTime;
  uint256 public weiRaised;
  bool public isFinalized;

  uint256[6] public rates = [
    25000,
    22000,
    19500,
    19500,
    17000,
    14500,
    12000
  ];

  uint256[6] public rateOffsets;

  mapping (address => uint256) purchaserFunded;

  // Events
  event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _tokens);

  function PreSEEDCrowdsale(
    uint256 _startTime,
    uint256 _endTime,
    PreSEED _token,
    RefundVault _vault,
    address _nextOwner,
    uint256[6] _rateOffsets)
    public
  {
    require(_startTime != 0);
    require(_endTime != 0);
    require(address(_token) != address(0));
    require(address(_vault) != address(0));
    require(_rateOffsets.length == 6);

    for (uint256 i = 0; i < _rateOffsets.length; i++) {
      rateOffsets[i] = _rateOffsets[i];
    }
  }

  function() public payable {
    buyTokens(msg.sender);
  }

  function buyTokens(address _beneficiary) public payable whenNotPaused {
    validatePurchase();

    uint256 rate = getRate();
    uint256 tokens = rate.mul(msg.value);

    weiRaised = weiRaised.add(msg.value);
    purchaserFunded[msg.sender] = purchaserFunded[msg.sender].add(msg.value);

    emit TokenPurchase(msg.value, _beneficiary, tokens);

    tokens.generateTokens(_beneficiary, tokens);
    vault.deposit.value(msg.value)(msg.sender);
  }

  function finalize(FinalizeReceiver nextOwner) public onlyOwner {
    require(nextOwner.onPresaleFinalized(weiRaised));

    token.changeController(address(0)); // freeze SEED Pre-release token contract
    vault.transferOwnership(address(nextOwner));
  }

  function getRate() public returns (uint256) {
    uint256 offset = block.timestamp.sub(startTime); // solium-disable-line security/no-block-members

    for (uint256 i = 0; i < rates.length; i++) {
      if (offset < rateOffsets[i]) {
        return rates[i];
      }
    }

    return 0;
  }

  function validatePurchase() internal {
    require(block.timestamp >= startTime && block.timestamp <= endTime); // solium-disable-line security/no-block-members
    require(!isFinalized);
  }
}
