// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;
contract dao {
    struct Proposal{
        uint id;
        string description;
        uint voteCount;
     
        bool executed;
           mapping (address=>bool) votes;
    }
    mapping (uint=>Proposal) public proposals;
    uint public proposalCount;
    mapping (address=>uint) public numOfShares;
    uint public totalShares;
    address public admin;
    constructor() {
       admin=msg.sender;
    }
modifier onlyAdmin(){
    require(msg.sender==admin, "only admin can all this function");
    _;
}
modifier onlyShareHolder(){
    require(numOfShares[msg.sender]>0,"You're not a share holder");
    _;
}
function createProposal(string memory _description) public onlyShareHolder{
Proposal storage _proposal = proposals[proposalCount];
_proposal.id=proposalCount;
_proposal.description=_description;
_proposal.voteCount=0;
_proposal.executed=false;
proposalCount++;
}
function vote(uint id) public onlyShareHolder{
    Proposal storage _proposal = proposals[id];
    require(_proposal.votes[msg.sender]==false,"You've already voted");

_proposal.votes[msg.sender]=true;
_proposal.voteCount++;
}
function addShareHolder(address _shareHolder, uint _shares) public onlyAdmin {
require(_shareHolder != address(0),"Not a valid address");
require(_shares>0,"Shares must be greater than zero");
numOfShares[_shareHolder]+=_shares;
totalShares+=_shares;
}
function executeProposal(uint id) public onlyAdmin{
    Proposal storage _proposal = proposals[id];
    require(_proposal.executed==false,"This proposal is already executed.");
    require(_proposal.voteCount>totalShares/2,"Not enough votes");
    _proposal.executed=true;
}
function removeShareHolder(address _shareHolder) public onlyAdmin{
    require(_shareHolder!=address(0),"Not a valid address");
    totalShares-=numOfShares[_shareHolder];
    delete numOfShares[_shareHolder];
}
}