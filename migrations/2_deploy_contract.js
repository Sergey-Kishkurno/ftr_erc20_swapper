// const FTR = artifacts.require("FuturisticToken");
// const FTR = artifacts.require("FuturisticToken");

module.exports = function (deployer) {
   deployer.deploy("FuturisticToken");
   deployer.deploy("FTR_ETH_Swap");
};

