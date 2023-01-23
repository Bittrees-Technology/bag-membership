// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract BAGMembers is ERC1155Upgradeable, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIds;

    uint256 public mintPrice;

    event MemberJoined(address indexed member, uint256 indexed tokenId);
    event MintPriceUpdated(uint256 indexed oldValue, uint256 indexed newValue);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        mintPrice = 0.01 ether;

        __ERC1155_init("ipfs://xxx/{id}");
        __Ownable_init();
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function setMintPrice(uint256 _newPrice) external onlyOwner {
        // Mint price in wei
        emit MintPriceUpdated(mintPrice, _newPrice);
        mintPrice = _newPrice;
    }

    function mintMembership(address to) external payable returns (uint256) {
        require(mintPrice <= msg.value, "Not enough funds sent");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId, 1, "");

        emit MemberJoined(to, newItemId);

        return newItemId;
    }

    function withdraw() external onlyOwner {
        uint256 _balance = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: _balance}("");
        require(success, "Unable to withdraw");
    }
}
