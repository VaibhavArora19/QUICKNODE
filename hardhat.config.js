require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */

const QUICKNODE_RPC = process.env.QUICKNODE_RPC;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  solidity: "0.8.17",
  networks:{
    goerli:{
      url: QUICKNODE_RPC,
      accounts: [PRIVATE_KEY]
    }
  }
};
