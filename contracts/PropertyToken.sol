// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract PropertyToken is ERC721Enumerable, Ownable {
    uint256 public tokenIdCounter;

    mapping(uint256 => PropertyDetails) private propertyDetails;

    mapping(uint256 => OwnershipDetails[]) private ownershipHistory;
    mapping(uint256 => PropertyDetails) private toRent;
    mapping(uint256 => PropertyDetails) private toSell;
    mapping(uint256 => RentDetails) private onRent;

    uint256[] allProperties;
    // PropertyDetails[] tAllProperties;

    struct RentDetails {
        uint256 rentAmount;
        uint256 lastPaymentTime;
        uint256 contractMadeOn;
    }

    struct PropertyDetails {
        string agreement;
        address tenant;
        uint256 sellingPrice;
        uint256 rentingPrice;
        uint256 token;
    }

    struct OwnershipDetails {
        string owningPower;
        address owner;
    }

    event PropertyPurchased(
        address indexed buyer,
        address indexed seller,
        uint256 indexed tokenId,
        uint256 price
    );

    constructor() ERC721("DreamToken", "DRT") Ownable(msg.sender) {
        tokenIdCounter = 0;
    }

    // Tokenize
    function mint(
        string memory agreement
    ) external onlyOwner returns (uint256) {
        _safeMint(msg.sender, tokenIdCounter);
        propertyDetails[tokenIdCounter] = PropertyDetails(
            agreement,
            msg.sender,
            0,
            0,
            tokenIdCounter
        );
        allProperties.push(tokenIdCounter);
        ownershipHistory[tokenIdCounter].push(
            OwnershipDetails("owner", msg.sender)
        );
        return tokenIdCounter++;
    }

    // Sell
    function sellProperty(
        uint256 tokenId,
        uint256 newPrice
    ) external onlyOwner {
        propertyDetails[tokenId].sellingPrice = newPrice * (10 ** 18);
        toSell[tokenId] = propertyDetails[tokenId];
    }

    // Buy
    function purchaseProperty(uint256 tokenId) external payable {
        require(
            msg.value >= toSell[tokenId].sellingPrice,
            "Insufficient funds to purchase the property"
        );
        address seller = ownerOf(tokenId);
        address buyer = msg.sender;

        _transfer(seller, buyer, tokenId);

        ownershipHistory[tokenIdCounter].push(
            OwnershipDetails("owner", msg.sender)
        );

        payable(seller).transfer(msg.value);
        delete toSell[tokenId];
        propertyDetails[tokenId].sellingPrice = 0;

        emit PropertyPurchased(buyer, seller, tokenId, msg.value);
    }

    // List to rent
    function rentProperty(
        uint256 tokenId,
        uint256 newPrice
    ) external onlyOwner {
        propertyDetails[tokenId].rentingPrice = newPrice * (10 ** 18);
        toRent[tokenId] = propertyDetails[tokenId];
    }

    // Rent Property
    function rentToTenant(uint256 tokenId) external onlyOwner {
        onRent[tokenId] = RentDetails(
            propertyDetails[tokenId].rentingPrice,
            block.timestamp,
            block.timestamp
        );
    }

    // Pay Rent
    function payRent(uint256 tokenId) public payable {
        require(
            msg.value == onRent[tokenId].rentAmount,
            "Incorrect rent amount"
        );
        onRent[tokenId].lastPaymentTime = block.timestamp;
    }

    // Check if rent due
    function isRentDue(uint256 tokenId) public view returns (bool) {
        uint256 timeElapsed = block.timestamp - onRent[tokenId].lastPaymentTime;
        uint256 secondsInMonth = 30 days;
        return timeElapsed >= secondsInMonth;
    }

    // Check if term of rent is over
    function checkRentTerm(uint256 tokenId) public view returns (bool) {
        uint256 timeElapsed = block.timestamp - onRent[tokenId].contractMadeOn;
        uint256 secondsInMonth = 366 days;
        return timeElapsed >= secondsInMonth;
    }

    // Get All Properties
    function getAllProps() public view returns (PropertyDetails[] memory) {
        PropertyDetails[] memory tAllProperties = new PropertyDetails[](
            allProperties.length
        );
        for (uint i = 0; i < allProperties.length; i++) {
            tAllProperties[i] = propertyDetails[allProperties[i]];
        }
        return tAllProperties;
    }

    // Get Details
    function getPropertyDetails(
        uint256 tokenId
    ) external view returns (PropertyDetails memory) {
        return (propertyDetails[tokenId]);
    }

    // Get History
    function getOwnershipHistory(
        uint256 tokenId
    ) external view returns (OwnershipDetails[] memory) {
        return ownershipHistory[tokenId];
    }

    // function withdraw() external onlyOwner {
    //     payable(owner()).transfer(address(this).balance);
    // }
}
