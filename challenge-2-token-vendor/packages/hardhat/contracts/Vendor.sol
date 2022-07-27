pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;
    uint256 public tokensPerEth = 100;
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(
        address seller,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        uint256 amountOfETH = msg.value;
        uint256 amountOfTokens = amountOfETH * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, amountOfETH, amountOfTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        uint256 amountOfETH = address(this).balance;
        (bool success, ) = msg.sender.call{value: amountOfETH}("");
        require(success, "Withdrawal failed");
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) public {
        uint256 amountOfETH = _amount / tokensPerEth;
        console.log("Contract Balance", address(this).balance);
        console.log("SELLING TOKENS", _amount);
        console.log("ETH OWED", amountOfETH);
        bool sendTokenSuccess = yourToken.transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(sendTokenSuccess, "Send Token failed");
        console.log("success token");
        (bool sendETHSuccess, ) = msg.sender.call{value: amountOfETH}("");
        require(sendETHSuccess, "Send Eth failed");
        console.log("success eth");
        emit SellTokens(msg.sender, amountOfETH, _amount);
    }
}
