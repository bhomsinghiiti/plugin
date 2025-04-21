// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Core} from "src/Core.sol";
import {ExamplePlugin} from "src/ExamplePlugin.sol";
import {VaultPlugin} from "src/VaultPlugin.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";


contract CoreTest is Test {
    Core public core;
    ExamplePlugin public examplePlugin;
    VaultPlugin public vaultPlugin;

    address public owner;

    function setUp() public {
        owner = address(this);
        core = new Core(owner);
        examplePlugin = new ExamplePlugin();
        vaultPlugin = new VaultPlugin();
    }


    function test_onlyOwner() public {
        address attacker = address(2);
        vm.startPrank(attacker);
        // addplugin
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, attacker));
        core.addPlugin(address(5));

        // removePlugin
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, attacker));
        core.removePlugin(0);

        //updatePlugin
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, attacker));
        core.updatePlugin(0, address(15));

        vm.stopPrank();
    }

    function test_AddPlugin() public {
        vm.startPrank(owner);
        // Deploy a dummy plugin that implements IPlugin
        address dummyPlugin = address(1);

        // Add plugin to Core
        core.addPlugin(dummyPlugin);

        // Assert plugin count is 1
        assertEq(core.pluginCount(), 1);
        vm.stopPrank();
    }

    function test_removePlugin() public{
        vm.startPrank(owner);

        // Deploy a dummy plugin that implements IPlugin
        address dummyPlugin = address(1);

        // Add plugin to Core
        core.addPlugin(dummyPlugin);

        assertEq(dummyPlugin, core.getPluginAddress(0));
       
        core.removePlugin(0);
         
        //removed successfully
        assertEq(address(0), core.getPluginAddress(0));

        vm.stopPrank();
    }

    function testExamplePlugin() public{
        vm.prank(owner);
        core.addPlugin(address(examplePlugin));

        address user = address(50);
        vm.startPrank(user);
        uint256 input = 25;
        uint256 result = core.executePlugin(0, input);
        assertEq(result, input*5);
    }

    function testVaultPlugin() public{
        vm.prank(owner);
        core.addPlugin(address(vaultPlugin));

        address user = address(55);
        vm.startPrank(user);
        uint256 input = 100;
        uint256 id = core.executePlugin(0, input);
        assertEq(id, 0); // vaultid must be zero for the first user
        (address _Owner, uint256 value) = vaultPlugin.getVault(id);
        assertEq(value, input);
        assertEq(_Owner, address(core));
    }


}
