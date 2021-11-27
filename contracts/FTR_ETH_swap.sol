pragma solidity ^0.8.10;
// SPDX-License-Identifier: MIT

import {SafeMath} from "./safe_math.sol";
import "./futuristic_token.sol";

// /**
//  * Network: Rinkeby
//  * Aggregator: ETH/USD
//  * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
//  */

interface IExchangeFeed {
  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

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


    address private rateSource = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e; // 0x8facae210c796bcac7afe147b622ffc1064629f6 
    address private home2 = 0x0E822C71e628b20a35F8bCAbe8c11F274246e64D; // From previous task

    function getExchange() public payable returns (uint) {      
        return uint (
            SafeMath.div ( uint256(_getLatestPrice()), getNumberOfStudents())
        );
    }

    function _getLatestPrice() public view returns (uint) {
            (
                uint80 roundID, 
                int256 answer,
                uint256 startedAt,
                uint256 updatedAt,
                uint80 answeredInRound
            ) = IExchangeFeed(rateSource).latestRoundData();
        return uint(SafeMath.div(uint256(answer), 1e8));
    }

    function getNumberOfStudents() public view returns (uint256) {  // From Home2 contract
        return uint256(
            IHome2(home2)
            .getStudentsList()
            .length
        );
    }

    function buyTokens() public payable {
        uint amount;
        FuturisticToken token;

        uint exchangeRate = getExchange();

        amount = uint(SafeMath.mul(msg.value, exchangeRate));
        uint endBalance = FuturisticToken(token).balanceOf(address(FuturisticToken(token)));
    
        if( endBalance > amount ){  
                FuturisticToken(token).transfer(msg.sender, amount);
        }
        else {
            msg.sender
            .call {
                gas   : 210000,
                value : msg.value}
            ("Sorry,there is not enough tokens");
        }
    }
}

