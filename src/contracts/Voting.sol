pragma solidity 0.5.16;

import "./ERC721Full.sol";

contract Voting is ERC721Full {
    address payable private contractOwner;
    
    mapping(string => bool) _candidateExists;
    string[] private candidates;
    uint256 public candidatesCounter;
    
    uint256 private pricePerVote = 10000000000000; // WEI Value
    
    mapping(address =>  bool) _voteExists; 
    mapping(string =>  uint256[]) votes; // token creation mapping candidateID to vote counts
    
    uint256[] private tokens;

    event Sold(uint256 amount);
    
    constructor() ERC721Full("Vote", "VOTE") public {
        contractOwner = msg.sender;
    }
    
    function setPricePerVote(uint256 _price) public { 
        pricePerVote = _price;
    }
    
    function getPricePerVote() public view returns(uint256) {
        // return (pricePerVote / (safePow(10,pricePerVoteDemical))) * 1000000000000000000;
        return pricePerVote;
    }
    
    function payTax()payable public returns(uint256){ 
        require(msg.value == pricePerVote, "Transfer price invalid price per vote."); 
        // return returnsValue();
        emit Sold(msg.sender.balance);
    }
    
    function setCandidate(string memory _candidate) public {
        require(!_candidateExists[_candidate], "This candidate is already in the list.");
        candidates.push(_candidate);
        _candidateExists[_candidate] = true;
        candidatesCounter++;
    }
    
    function getCandidate(uint256 candidateId) public view returns(string memory) {
        require(candidates.length > 0, "No candidates in list");
        return candidates[candidateId];
    }
    
    function getCandidateVotes(uint256 _candidateId) public view returns(uint256) {
        require(candidates.length > 0, "No candidates in list");
        require(!_candidateExists[candidates[_candidateId]], "This candidate is not in the list."); 
        return votes[candidates[_candidateId]].length;
    }
    
    function mintCheck(uint256 _candidateId) payable public returns(string memory){ 
        require(!_candidateExists[candidates[_candidateId]], "This candidate is not in the list."); 
        require(!_voteExists[msg.sender], "Can't cast your vote more than once."); 
        require(msg.value != pricePerVote, "Transfer price invalid price per vote."); 
        mint(_candidateId);
    }

    function mint(uint256 _candidateId) internal {
      uint256 _id = tokens.push(_candidateId); // Token address with candidate ID
      _mint(msg.sender, _id); // Minting token to user address
      _voteExists[msg.sender] = true;
      votes[candidates[_candidateId]].push(_id);
      contractOwner.transfer(msg.value);
      emit Sold(msg.value);
    }
    
    function safePow(uint256 base, uint256 exponent) public pure returns (uint256) {
        if (exponent == 0) {
            return 1;
        }
        else if (exponent == 1) {
            return base;
        }
        else if (base == 0 && exponent != 0) {
            return 0;
        }
        else {
            uint256 z = base;
            for (uint256 i = 1; i < exponent; i++)
                z = safeMul(z, base);
            return z;
        }
    }
    
    function safeMul(uint256 n, uint256 base) public pure returns (uint256) { 
        return n*base;
    }
}
