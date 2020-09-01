var CandidateSide = artifacts.require("./CandidateSide.sol");

module.exports = function(deployer) {
  deployer.deploy(CandidateSide);
};
