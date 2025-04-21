// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IPlugin.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Core is Ownable {
    mapping(uint256 => address) public plugins;
    uint256 public pluginCount;

    constructor(address initialOwner) Ownable(initialOwner) {}

    function addPlugin(address plugin) external onlyOwner {
        plugins[pluginCount] = plugin;
        pluginCount++;
    }

    function updatePlugin(uint256 id, address newPlugin) external onlyOwner {
        require(plugins[id] != address(0), "Plugin does not exist");
        plugins[id] = newPlugin;
    }

    function removePlugin(uint256 id) external onlyOwner {
        require(plugins[id] != address(0), "Plugin does not exist");
        delete plugins[id];
    }

    function executePlugin(uint256 id, uint256 input) external returns (uint256) {
        address plugin = plugins[id];
        require(plugin != address(0), "Invalid plugin");
        return IPlugin(plugin).performAction(input);
    }

    function getPluginAddress(uint256 id) external view returns (address) {
        return plugins[id];
    }
}
