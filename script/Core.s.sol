// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Core} from "../src/Core.sol";

contract CounterScript is Script {
    Core public core;
    
    function run() public {
        vm.startBroadcast();
        core = new Core(address(this));
        vm.stopBroadcast();
    }
}
