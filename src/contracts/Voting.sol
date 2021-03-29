pragma solidity 0.5.16;

import "./ERC721Full.sol";

contract Voting is ERC721Full {
    string[] private candidates;
    uint256 public candidatesCounter;
    address private contractOwner;
    mapping(string => bool) _candidateExists;

    constructor() ERC721Full("Vote", "VOTE") public {
        contractOwner = msg.sender;
    }
    
    function setCandidate(string memory _candidate) public {
        require(!_candidateExists[_candidate], "This candidate is already in the list.");
        candidates.push(_candidate);
        _candidateExists[_candidate] = true;
        candidatesCounter++;
    }
    
    function getCandidate(uint256 candidateId) public view returns(string memory) {
        require(candidates.length > 0, "No candidates in list");
        return candidates[candidateId-1];
    }

    // function mint(string memory _candidate) public {
    //   require(!_colorExists[_color]);
    //   uint _id = colors.push(_color);
    //   _mint(msg.sender, _id);
    //   _colorExists[_color] = true;
    // }
}
