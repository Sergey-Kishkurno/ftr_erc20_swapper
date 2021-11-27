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

  const FTR_ETH_Swap = await ethers.getContractFactory("FTR_ETH_Swap");
  const ftr_eth_swap = await FTR_ETH_Swap.deploy();

  await ftr_eth_swap.deployed();

  await new Promise(resolve => setTimeout(resolve, 60000)); // pause 3-4 blocks for etherscan update

  // Verifying contract
  await run("verify:verify", {address: ftr_eth_swap.address, constructorArguments: []});

  console.log("FTR/ETH Swapper deployed and verified to:", ftr_eth_swap.address);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
