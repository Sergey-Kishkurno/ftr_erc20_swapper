import { web3 } from 'hardhat';
// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers, run } from "hardhat";

// const hre = require("hardhat");
// const ethers = hre.ethers;
// const web3 = hre.web3;


async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const FTR = await ethers.getContractFactory("FuturisticToken");
  const ftr = await FTR.deploy();

  await ftr.deployed();

  await new Promise(resolve => setTimeout(resolve, 60000)); // pause 3-4 blocks for etherscan update


  // Verifying contract
  await run("verify:verify", {address: ftr.address, constructorArguments: []});

  console.log("Futuristic Token deployed and verified to:", ftr.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
