pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate,
        address payable wallet,
        PupperCoin token,
        uint256 goal,
        uint StartTime,
        uint EndTime
    )

        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(StartTime, EndTime)
        RefundableCrowdsale(goal)
        RefundablePostDeliveryCrowdsale()

        public

    {


    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet  // receiver
    )
        public
    {
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        uint goal = 300 ether;

        PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, token, goal, now, now + 15 minutes);
        token_sale_address = address(pupper_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
