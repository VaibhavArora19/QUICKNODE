require("dotenv").config();
const path = require("path");
const fs = require("fs");
const { ethers } = require("hardhat");

const p = path.join(__dirname, "..", "artifacts", "contracts", "Vote.sol", "Vote.json");
const contractAddress = "0x9772ccD69738CF4618CD5725A90cD0c20903e085";

const provider = new ethers.providers.JsonRpcProvider(process.env.QUICKNODE_RPC);

const main = async () => {
    let abi;
    let data = fs.readFileSync(p);
    
    data = JSON.parse(data);
    abi = data.abi;
    
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
    const contract = new ethers.Contract(contractAddress, abi, provider);
    const contractWithWallet = contract.connect(wallet);


    const mint = await contractWithWallet.mintToContract(contractAddress);

    await mint.wait();

    const claim = await contractWithWallet.claim();

    await claim.wait();
    console.log(claim);

    const suggest = await contractWithWallet.suggest("Should also launch at polygon mumbai");

    await suggest.wait();

    console.log(suggest);
};

main()
.then(() => process.exit(0))
.catch((e) =>{
    console.log(e);
    process.exit(1);
});