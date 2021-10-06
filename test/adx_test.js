var ADXLike = artifacts.require("./ADXLike.sol");

contract("ADXLike", function(accounts) {


    it("should have 0 eth in the start", function() {
        return ADXLike.deployed().then(function(instance){
            return instance.currentEth.call()
        }).then(function(currentEth){
            assert.equal(currentEth.valueOf(), 0, "0 isn't the current eth");
        })
    });


    it("should have 0 eth in the start", function() {
        return ADXLike.deployed().then(function(instance){
            return instance.currentEth.call()
        }).then(function(currentEth){
            assert.equal(currentEth.valueOf(), 0, "0 isn't the current eth");
        })
    });


    it("buyADX with 1 eth should increase the collectedEth", function() {
        return ADXLike.deployed().then(function(instance){
            return instance
        }).then(async function(instance){

            let buyTokens = await instance.buyADX({
                from: '0xd72C73d9D7A3c8021d55EfA1A89EE7781da49DD1',
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
                from: '0x4d6a81738505397DE36320BFBfb363E7a3f61484',
                value: web3.utils.toWei('1', "ether")
            });
            let balance = await instance.balanceOf('0x4d6a81738505397DE36320BFBfb363E7a3f61484');
            
            assert.equal(balance.valueOf(), 1170, "tokens collected should be 1170 ")
        })
    });

});