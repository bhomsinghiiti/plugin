// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VaultPlugin  {
    struct Vault {
        address owner;
        uint256 value;
    }

    uint256 public nextVaultId;
    mapping(uint256 => Vault) public vaults;

    function performAction(uint256 input) external returns (uint256) {
        uint256 vaultId = nextVaultId++;
        vaults[vaultId] = Vault({
            owner: msg.sender,
            value: input
        });

        return vaultId;
    }

    function getVault(uint256 id) external view returns (address owner, uint256 value) {
        Vault memory v = vaults[id];
        return (v.owner, v.value);
    }
}
