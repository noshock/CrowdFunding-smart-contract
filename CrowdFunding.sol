// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding{

    address public creator;
    uint public goal;
    uint public deadline;
    uint public raisedAmount;

    mapping(address => uint) public donations;

    constructor(uint _goal, uint _duration) {
        creator  = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
           // timetamp works in seconds
   }

   function donate() public payable {
    require(block.timestamp < deadline, "campaign ended");
    donations[msg.sender] += msg.value;
    raisedAmount += msg.value;
   }

   function withdraw() public {
    require(msg.sender == creator, "not creator");

    require(block.timestamp >= deadline,"campaign still running");

    require(raisedAmount >= goal, "goal not reached");

    (bool success, ) = payable(creator).call{value: raisedAmount}("");
    require(success, "transfer failed");

   }
}       