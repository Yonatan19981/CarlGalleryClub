
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CarlGalleryClub is ERC721{

    event Mint(
        address indexed _to,
        uint256 indexed _tokenId,
        uint256 indexed _projectId,
        uint256 _value
    );

    struct Project {
        string name;
        string artist;
        string description;
        uint invocations;
        uint maxInvocations;
        uint256 pricePerTokenInWei;
        string projectBaseURI;
        bool paused;
        bool preSale;
        bool reveal;
        mapping(address => bool) whiteListed;
    }

    mapping(uint256 => Project) projects;

    address payable public CGCAddress;
    uint256 public CGCPercentage = 10;
    uint id;
    mapping(uint256 => uint256) public tokenIdToProjectId;
    mapping(uint256 => uint256[]) internal projectIdToTokenIds;
    mapping(address => uint256[]) public userOwnedTokens;
    mapping(address => bool) public isAdmin;

    uint256 public nextProjectId;

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Only admin");
        _;
    }


    constructor(string memory _tokenName, string memory _tokenSymbol) ERC721(_tokenName, _tokenSymbol)  {
        isAdmin[msg.sender]=true;
        CGCAddress = payable(msg.sender);
        id=0;
    }

    function purchase(uint256 _projectId) public payable returns (uint256 _tokenId) {
        return purchaseTo(msg.sender, _projectId);
    }

    function purchaseTo(address _to, uint256 _projectId) public payable returns (uint256 _tokenId) {
        uint price=projects[_projectId].pricePerTokenInWei;
        if (projects[_projectId].whiteListed[_to]){
            price=price*90/100;
        }
        if(isPreSale(_projectId)){
            price=price*80/100;
        }
        require(msg.value >= price-1, "Must send at least price");
        require(projects[_projectId].invocations+1 <= projects[_projectId].maxInvocations, "Must not exceed max invocations");
        require(!projects[_projectId].paused , "Purchases are paused.");

        uint256 tokenId = _mintToken(_to, _projectId);

        CGCAddress.transfer(price);


        return tokenId;
    }

    function _mintToken(address _to, uint256 _projectId) internal returns (uint256 _tokenId) {
        require(projects[_projectId].invocations+1<=projects[_projectId].maxInvocations,"No more tokens can be minted");
        projects[_projectId].invocations=projects[_projectId].invocations+1;
        uint tokenId=id;
        _mint(_to, tokenId);

        tokenIdToProjectId[tokenId] = _projectId;
        projectIdToTokenIds[_projectId].push(tokenId);

        emit Mint(_to, tokenId, _projectId, projects[_projectId].pricePerTokenInWei);
        id=id+1;
        return tokenId;
    }

    function updateCGCAddress(address payable _CGCAddress) public onlyAdmin {
        CGCAddress = _CGCAddress;
    }

    function updateCGCPercentage(uint256 _CGCPercentage) public onlyAdmin {
        CGCPercentage = _CGCPercentage;
    }

    function addAdmin(address _address) public onlyAdmin {
        isAdmin[_address] = true;
    }

    function removeAdmin(address _address) public onlyAdmin {
        isAdmin[_address] = false;
    }

    function toggleProjectIsPreSale(uint256 _projectId) public onlyAdmin {
        projects[_projectId].preSale = !projects[_projectId].preSale;
    }

    function toggleProjectIsPaused(uint256 _projectId) public onlyAdmin {
        projects[_projectId].paused = !projects[_projectId].paused;
    }

  function toggleWhiteListed(uint256 _projectId,address user) public onlyAdmin {
        projects[_projectId].whiteListed[user] = !projects[_projectId].whiteListed[user];
    }
    function addProject(string memory _name,uint256 _pricePerTokenInWei,uint _maxInvocations, string memory _artist,string memory _description,string memory _projectBaseURI,bool _reveal) public onlyAdmin{

        uint256 projectId = nextProjectId;
        projects[projectId].name=_name;
        projects[projectId].artist=_artist;
        projects[projectId].description = _description;
        projects[projectId].pricePerTokenInWei = _pricePerTokenInWei;
        projects[projectId].paused=true;
        projects[projectId].invocations=0;
        projects[projectId].maxInvocations =_maxInvocations;
        projects[projectId].projectBaseURI =_projectBaseURI;
        projects[projectId].reveal =_reveal;
        nextProjectId = nextProjectId+1;
    }

    function updateProjectPricePerTokenInWei(uint256 _projectId, uint256 _pricePerTokenInWei) public {
        projects[_projectId].pricePerTokenInWei = _pricePerTokenInWei;
    }

 

    function updateProjectMaxInvocations(uint256 _projectId, uint256 _maxInvocations) onlyAdmin public {
        require(_maxInvocations > projects[_projectId].invocations, "You must set max invocations greater than current invocations");
        projects[_projectId].maxInvocations = _maxInvocations;
    }
    function updateProjectBaseURI(uint256 _projectId, string memory _newBaseURI) public {
        projects[_projectId].projectBaseURI = _newBaseURI;
    }


    function projectDetails(uint256 _projectId) view public returns (string memory projectName, string memory artist, string memory description) {
        projectName = projects[_projectId].name;
        artist = projects[_projectId].artist;
        description = projects[_projectId].description;
    }

    function projectTokenInfo(uint256 _projectId) view public returns (uint256 pricePerTokenInWei, uint256 invocations, uint256 maxInvocations) {
        pricePerTokenInWei = projects[_projectId].pricePerTokenInWei;
        invocations = projects[_projectId].invocations;
        maxInvocations = projects[_projectId].maxInvocations;
    }


    function projectShowAllTokens(uint _projectId) public view returns (uint256[] memory){
        return projectIdToTokenIds[_projectId];
    }

    function isPreSale(uint _projectId) public view returns (bool){
        return projects[_projectId].preSale;
    }

       function isWhiteListed(uint _projectId,address _user) public view returns (bool){
        return projects[_projectId].whiteListed[_user];
    }
    function uint2str(
  uint256 _i
)
  internal
  pure
  returns (string memory str)
{
  if (_i == 0)
  {
    return "0";
  }
  uint256 j = _i;
  uint256 length;
  while (j != 0)
  {
    length++;
    j /= 10;
  }
  bytes memory bstr = new bytes(length);
  uint256 k = length;
  j = _i;
  while (j != 0)
  {
    bstr[--k] = bytes1(uint8(48 + j % 10));
    j /= 10;
  }
  str = string(bstr);
}

function tokenURI(uint256 _tokenId) public override view returns (string memory) {
        if(projects[tokenIdToProjectId[_tokenId]].reveal==false){
            return projects[tokenIdToProjectId[_tokenId]].projectBaseURI;
        }
       return string.concat(projects[tokenIdToProjectId[_tokenId]].projectBaseURI,uint2str(_tokenId));
  
}


}


// File contracts/mock/ERC721ReceiverMock.sol

// SPDX-License-Identifier: MIT

/*
Network: Eth
Price: 
Supply: 20
Name: Carl Gallery-Abdul Qader Genesis collection 
Symbol: CGC - Carl gallery club
Limit per wallet: 2
Pre sale- 20% discount
-WL: 10% discount 
Royalties: 10%
Second market: open sea
Wallet-
0xF67C4Fb7f7b12ef35cA4B04b09E3ccD5ffE97D24



Nfts-



https://drive.google.com/drive/folders/1snz9hJ_Vg1YFPKTcfhBsk-ksugxp3i1U



2.
Network: Eth
Price: 0.15 eth
Supply: 3000
Pre sale- 20% discount
Name: Carl Gallery-ITZHAQ MEVORAH
Symbol: CGC - Carl gallery club
Limit per wallet: 5
-WL: 10% discount 
Royalties: 10%
Second market: open sea
Wallet-
0xF67C4Fb7f7b12ef35cA4B04b09E3ccD5ffE97D24
*/