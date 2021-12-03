import { web3 } from 'hardhat';
import { ethers, run } from "hardhat";

const hre = require("hardhat");
// const ethers = hre.ethers;
// const web3 = hre.web3;


async function main() {

  // --- A token is deployed: --------------------------------------------------------------
  const FTR = await hre.ethers.getContractFactory("FuturisticToken");
  const ftr = await FTR.deploy();
  await ftr.deployed();
  await new Promise(resolve => setTimeout(resolve, 61000)); // pause 3-4 blocks for etherscan update

  // --- A swapper is deployed: ------------------------------------------------------------
  const FTR_ETH_Swap = await hre.ethers.getContractFactory("FTR_ETH_Swap", {address: ftr.address});
  const ftr_eth_swap = await FTR_ETH_Swap.deploy(ftr.address);
  await ftr_eth_swap.deployed();
  await new Promise(resolve => setTimeout(resolve, 61000)); // pause 3-4 blocks for etherscan update


  // --- Verification: ---------------------------------------------------------------------
  await run("verify:verify", {address: ftr_eth_swap.address, constructorArguments: [ftr.address]});
  console.log("FTR/ETH Swapper deployed and verified, address:", ftr_eth_swap.address);
  await run("verify:verify", {address: ftr.address, contract: "contracts/futuristic_token.sol:FuturisticToken"});
  console.log("Futuristic Token deployed and verified, address:", ftr.address);

  // const Interceptor = await hre.ethers.getContractFactory("Interceptor");
  // const interceptor = await Interceptor.deploy();
  // await interceptor.deployed();
  // await new Promise(resolve => setTimeout(resolve, 61000)); // pause 3-4 blocks for etherscan update
  // //await run("verify:verify", {address: interceptor.address, constructorArguments: []});
  // console.log("Interceptor deployed and verified, address:", interceptor.address);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
