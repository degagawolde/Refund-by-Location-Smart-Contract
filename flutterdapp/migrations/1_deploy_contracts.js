const RefundContract = artifacts.require("RefundContract");
  
module.exports = function (deployer) {
  deployer.deploy(RefundContract);
};