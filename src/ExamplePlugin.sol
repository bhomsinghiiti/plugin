// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ExamplePlugin  {
    uint256 public multiplier = 5;
    
    function performAction(uint256 input) external returns (uint256) {
        return input * 5;
    }
}
