// SPDX-License-Identifier: GPL v3.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

interface CasinoInterface {
    function payWinnings(address to, uint256 amount) external;
}

interface ChipInterface {
    function casinoGameBalanceOf(address _owner) external view returns (uint256 balance);
    function casinoGameTransfer(address _to, uint256 _value) external returns (bool success);
    function casinoGameApprove(address _spender, uint256 _value) external returns (bool success);
}

/* The CasinoGame contract defines top-level state variables
*  and functions that all casino games must have. More game-specific
*  variables and functions will be defined in subclasses that inherit it.
*/
contract CasinoGame is Ownable {

    // State variables
    CasinoInterface private casinoContract;
    ChipInterface private chipContract;
    uint256 internal minimumBet;
    mapping (address => bool) private gameInProgress;

    // Events (to be emitted)
    event ContractPaid(address player, uint256 amount);
    event RewardPaid(address player, uint256 amount);

    // Sets the address of the Casino contract.
    function setCasinoContractAddress(address _address) external onlyOwner {
        casinoContract = CasinoInterface(_address);
    }

    // Sets the address of the Chip contract.
    function setChipContractAddress(address _address) external onlyOwner {
        chipContract = ChipInterface(_address);
    }


    // Sets the minimum bet required for all casino games.
    function setMinimumBet(uint256 _bet) external onlyOwner {
        require(_bet >= 0, "Bet is too low.");
        minimumBet = _bet;
    }

     // Sets the value of gameInProgress to true or false for a player.
    function setGameInProgress(address _address, bool _isPlaying) internal {
        gameInProgress[_address] = _isPlaying;
    }

    // Rewards the user for the specified amount if they have won
    // anything from a casino game. Uses the Casino contract's payWinnings
    // function to achieve this.
    function rewardUser(address _user, uint256 _amount) internal {
        require(_amount >= 0, "Not enough to withdraw.");
        casinoContract.payWinnings(_user, _amount);
        emit RewardPaid(_user, _amount);
    }

    // Allows a user to place a bet by paying the contract the specified amount.
    function payContract(uint256 _amount) public  {
        require(chipContract.casinoGameBalanceOf(msg.sender) >= _amount, "Not enough tokens.");
        emit ContractPaid(msg.sender, _amount);
    }
}