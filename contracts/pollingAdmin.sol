pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './CandidateSide.sol';
contract PollingAdmin is CandidateSide{
  address owner;
  struct poll{
    uint64 poll_id;
    string pollname;
    uint64[] candidates;
    string[] positions;
    uint128 total_votes;
    bool isValue;
  }
  mapping(uint64=> poll) private polls;
  constructor() public {
    owner = msg.sender;
  }
uint64[] private cids;
string[] private posts;
  function createPoll(uint64 pid,string memory pname) public payable{
    require(polls[pid].isValue == false, "duplicate occured -> Poll already present");
    polls[pid] = poll(pid,pname,cids,posts,0,true);
  }
  function isPost(string memory post,string[] memory postss) private pure returns(bool){
      for(uint64 i = 0; i<postss.length;i++){
          if(keccak256(abi.encode(post))==keccak256(abi.encode(postss[i])))
            return true;
      }
      return false;
  }

  function addpost(uint64 pid,string memory pos) public payable {
    require(polls[pid].isValue == true,"Poll not present");
    require(isPost(pos,polls[pid].positions) == false, "Post Already Present");
    polls[pid].positions.push(pos);
  }

  function addCandidate(uint64 cid, string memory name, uint64 pid,string memory post, string memory cAddress) public payable{
    require(polls[pid].isValue == true,"Poll not present");
    require(Key[cid] != "0x0","Candidate Exists already");
    require(isPost(post,polls[pid].positions),"position Not Found");
    Candidate_keys[cid] = keccak256(abi.encode(cid));
    polls[pid].candidates.push(cid);
    Candidates[cid] = Candidate(name,pid,post,Candidate_keys[cid],0,cAddress);
  }

  function getCandidates(uint64 pid)public view returns(uint64[] memory){
      return polls[pid].candidates;
  }

  function getPosts(uint64 pid) public view returns(string[] memory){
    require(polls[pid].isValue==true, "Poll is not Present");
    return polls[pid].positions;
  }

  struct result{
    string candidate;
    uint128 votes;
  }
  result[] private res;

  function calculateResult(uint64 pid, string memory post)public{
    delete res;
    for(uint64 i = 0; i < polls[pid].candidates.length; i++){
      uint64 cid = polls[pid].candidates[i];
      string memory pos = Candidates[cid].post;
      if(keccak256(abi.encode(pos)) == keccak256(abi.encode(post)))
        res.push(result(Candidates[cid].name,Candidates[cid].vote_Count));
    }
  }

  function getResult() public view returns(result[] memory){
      return res;
  }
}
