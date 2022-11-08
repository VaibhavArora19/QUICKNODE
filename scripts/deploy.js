const {ethers} = require("hardhat");

const main = async() => {

  const VoteContractFactory = await ethers.getContractFactory("Vote");

  const VoteContract = await VoteContractFactory.deploy();

  await VoteContract.deployed();

  console.log("Contract is deployed at address ", VoteContract.address);

}

main()
.then(() => process.exit(0))
.catch((e) => {
  console.log(e);
  process.exit(1);
})

//contract address -> 0x9772ccD69738CF4618CD5725A90cD0c20903e085
