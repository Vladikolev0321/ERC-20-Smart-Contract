var ADXLike = artifacts.require("./ADXLike.sol");

contract("ADXLike", function(accounts) {


    it("should have 0 eth in the start", function() {
        return ADXLike.deployed().then(function(instance){
            return instance.currentEth.call()
        }).then(function(currentEth){
            assert.equal(currentEth.valueOf(), 0, "0 isn't the current eth");
        })
    });


    it("the total supply should be 100000000", function() {
        return ADXLike.deployed().then(function(instance){
            return instance.totalSupply();
        }).then(function(totalSupply){
            assert.equal(totalSupply.valueOf(), 100000000, "total supply isn't 100000000");
        })
    });


    it("buyADX with 1 eth should increase the collectedEth", function() {
        return ADXLike.deployed().then(function(instance){
            return instance
        }).then(async function(instance){

            let buyTokens = await instance.buyADX({
                from: '0x837aEe60D177DB1C0190d3E3DDC2550c86FdE645',
                value: web3.utils.toWei('1', "ether")
            });
            let ethCollected = await instance.currentEth.call();

            assert.equal(ethCollected.valueOf(), 1, "eth collected should be 1 after sell")
        })
    });

    it("buyADX with 1 eth should increase the buyer balance by 1170 tokens", function() {
        return ADXLike.deployed().then(function(instance){
            return instance
        }).then(async function(instance){

            let buyTokens = await instance.buyADX({
                from: '0x76e490B6B8FBb6f1DA715646fB9FC84bFbEAED30',
                value: web3.utils.toWei('1', "ether")
            });
            let balance = await instance.balanceOf('0x76e490B6B8FBb6f1DA715646fB9FC84bFbEAED30');
            
            assert.equal(balance.valueOf(), 1170, "tokens collected should be 1170 ")
        })
    });

});