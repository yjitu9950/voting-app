var PollingAdmin = artifacts.require("./PollingAdmin.sol");
module.exports = function(deployer) {
  deployer.deploy(PollingAdmin);
};
