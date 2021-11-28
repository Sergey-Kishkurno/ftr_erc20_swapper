pragma solidity ^0.8.10;
// SPDX-License-Identifier: MIT

import {SafeMath} from "./safe_math.sol";
import "./futuristic_token.sol";

// /**
//  * Network: Rinkeby
//  * Aggregator: ETH/USD
//  * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
//  */

import "./AggregatorV3Interface.sol";

interface IHome2{
     function getStudentsList() external view returns (string[] memory); 
}

interface IFTR{
     function balanceOf(address ftr) external view returns (uint);
     function transfer(address _to, uint256 _value) external returns (bool);
}

contract FTR_ETH_Swap {
    using SafeMath for *;
    string private _name = "FTR/ETH Swapper";

    AggregatorV3Interface internal priceFeed;

    address private rateSource = 0x9326BFA02ADD2366b30bacB125260Af641031331; // 0x8facae210c796bcac7afe147b622ffc1064629f6 
    address private home2 = 0x0E822C71e628b20a35F8bCAbe8c11F274246e64D; // From previous task

    uint256 private NumberOfStudents;

    event Selling(address indexed receiver, uint value);
    event Fail(address indexed receiver, uint value, bool sent, bytes data);
    event Intercept(bytes message);

    address private owner = msg.sender;
    FuturisticToken internal token;

    constructor() {
        priceFeed = AggregatorV3Interface(rateSource);
        NumberOfStudents = uint256(IHome2(home2).getStudentsList().length);
        token = FuturisticToken(owner);
    }

    fallback() external payable {
        emit Intercept(msg.data);
    }

    function getExchange() public payable returns (uint) {      
        return uint (
            SafeMath.div (uint256(_getLatestPrice()), NumberOfStudents)
        );
    }

    function _getLatestPrice() internal view returns (uint) {
            ( , int256 answer, , , ) = priceFeed.latestRoundData();
        return uint(SafeMath.div(uint256(answer), 1e8));
    }

    function buyTokens() public payable returns (bool) {
        uint amount;
        
        uint exchangeRate = getExchange();

        //amount = uint(SafeMath.mul(msg.value, exchangeRate));
        amount = uint(msg.value * exchangeRate);

        uint currentBalance = token.balanceOf(address(this));
    
        if( currentBalance > amount ) {
            token.transfer(msg.sender, amount);
            emit Selling(msg.sender, amount);
            return true;
        }
        else {
            (bool sent, bytes memory data) = msg.sender.call {value : msg.value} ("Sorry,there is not enough tokens");
            emit Fail(msg.sender, amount, sent, data);
            return false;
       }
    }
}

