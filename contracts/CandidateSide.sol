pragma solidity ^0.5.0;

contract CandidateSide {
  //Voters
  mapping(uint64 => bytes32) public Key;
  struct Voter{
    bool vote_given;
    bytes32 vote_given_to;
  }
  mapping(uint64 => Voter) public voters;
  constructor() public {
    owner = msg.sender;
    }
  function validation(uint64 roll_no, bytes32 key) public view returns(bool){
    if(Key[roll_no]==key)
      return true;
    else
      return false;
  }
  function addvoter(uint64 roll_no) public payable{
    require(Key[roll_no]==0x0,"Already a voter");
    voters[roll_no] = (Voter(false, ""));
    Key[roll_no] = keccak256(abi.encode(roll_no));
  }

  function getvoterkey(uint64 vid) public pure returns(bytes32){
    return keccak256(abi.encode(vid));
  }

  //Candidate
  address owner;
  struct Candidate{
    string name;
    uint64 poll_Id;
    string post;
    bytes32 key;
    uint64 vote_Count;
    string candidate_Address;
  }

  mapping(uint64 => bytes32) public Candidate_keys;
  mapping(uint64 => Candidate) public Candidates;
  function Vote(uint64 roll_no, uint64 candidate, bytes32 key) public payable {
    require(validation(roll_no, key),"Invalid Voter");
    require(keccak256(abi.encode(roll_no)) == Key[roll_no],"Not a voter");
    require(keccak256(abi.encode(candidate)) == Candidate_keys[candidate], "Not a Candidate");
    require(voters[roll_no].vote_given == false, "Invalid Vote already vote given");

    Candidates[candidate].vote_Count += 1;
    voters[roll_no].vote_given = true;
    voters[roll_no].vote_given_to = Candidate_keys[candidate];

  }
}
