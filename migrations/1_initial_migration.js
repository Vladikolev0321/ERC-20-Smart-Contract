const ADXLike = artifacts.require("ADXLike");
const SafeMath = artifacts.require("SafeMath");

module.exports = function (deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ADXLike);
  deployer.deploy(ADXLike);

};
