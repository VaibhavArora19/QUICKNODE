// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//This contract is a community driven DAO
//It allows it's members to make a suggestion on the DAO or to vote on a certain suggestion

contract Vote is ERC20{

    struct suggestions {
        uint id;            //suggestion Id
        string suggestion;  //suggestion that should be proposed
        bool isExecuted;    // if the suggestion is executed or not
        bool shouldBeExecuted;  //if the DAO members want this suggestion to implement or not
        uint256 yes;             //Votes in favor of suggestion
        uint256 no;               //Votes against suggestion
    }

    //Check if the given address is a member of the DAO
    mapping(address => bool) public isMember;       

    //The owner of the DAO
    address public immutable owner;

    //Shows the no of suggestions took place
    uint public _id;

    //Time to become a member of the DAO, initially user can only become member after the 30 minutes of launch of DAO
    uint256 public timeToClaim = block.timestamp + 60 days;
    
    //Total suggestions that ever took place
    suggestions[] public totalSuggestions;


    //Total tokens claimed
    uint16 public totalClaimed;

    constructor() ERC20("QNTOKEN", "QNT"){
        owner = msg.sender;
    }


    modifier onlyOwner{
        require(msg.sender == owner, "You are not the owner");
        
        _;
    }

    //modifier to check if the user is a member of the DAO
    modifier isAMember{
        require(isMember[msg.sender] == true, "Not a member");
        _;
    }

    //Mint 100 ERC20 tokens to the contract so that the contract can then transfer ERC20 tokens to the members of the DAO. This function can only be called by the owner
    function mintToContract(address _contractAddress) external onlyOwner{
        _mint(_contractAddress, 100*10**18);

    }

    //Claim ERC20 token(TWT) to become a member of the DAO
    function claim() external {
        require(timeToClaim >= block.timestamp, "You are late");
        require(isMember[msg.sender] == false, "Already a member");
        require(totalClaimed <= 100, "All tokens claimed");
        isMember[msg.sender] = true;
        totalClaimed++;
        _transfer(address(this), msg.sender, 1*10**18);
    }


    //Make a new suggestion if you are the member of the DAO
    function suggest(string memory _newSuggestion) external isAMember {

        totalSuggestions.push(suggestions({id: _id, suggestion: _newSuggestion, isExecuted: false,shouldBeExecuted: false ,yes: 0, no: 0}));
        _id++;
    }

    //Vote on the given suggestions if they aren't already executed and check if the votes reached more than 51 than take action based on votes
    function vote(uint index, uint8 yesOrNo) external isAMember{
        require(totalSuggestions[index].isExecuted == false, "Already Executed");
        
        suggestions storage currentSuggestion = totalSuggestions[index];

        if(yesOrNo == 1){
            currentSuggestion.yes++;
        }else{
            currentSuggestion.no++;
        }

        if(currentSuggestion.yes >= 51){
            currentSuggestion.shouldBeExecuted = true;
        }else{
            currentSuggestion.shouldBeExecuted = false;
        }

        currentSuggestion.isExecuted = true;
    }
}