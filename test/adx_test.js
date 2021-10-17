var ADXLike = artifacts.require("./ADXLike.sol");

contract("ADXLike", function(accounts) {
    
    let ADXInstance = null;

    before(async() => {
        ADXInstance = await ADXLike.deployed();
    })

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


    it("buyADX with 1 eth should increase the collectedEth and the buyer balance by 1170 tokens", function() {
        return ADXLike.deployed().then(function(instance){
            return instance
        }).then(async function(instance){

            let acc = accounts[0];
            let buyTokens = await instance.buyADX({
                from: acc,
                value: web3.utils.toWei('1', "ether")
            });
            let ethCollected = await instance.currentEth.call();
            
            let balance = await instance.balanceOf(acc);

            assert.equal(ethCollected.valueOf(), 1, "eth collected should be 1 after sell");
            assert.equal(balance.valueOf(), 1170, "tokens collected should be 1170");
        })
    });


    // it("the total supply should be 100000000", async() =>{

    //        let days = await ADXInstance.compareDates();

    //        assert.equal(days, 0, "date compare is 0");
        
    // });




    // it("buyADX with 1 eth should increase the buyer balance by 1170 tokens", function() {
    //     return ADXLike.deployed().then(function(instance){
    //         return instance
    //     }).then(async function(instance){

    //         let acc = accounts[1];
    //         let buyTokens = await instance.buyADX({
    //             from: acc,
    //             value: web3.utils.toWei('1', "ether")
    //         });
            
    //         assert.equal(balance.valueOf(), 1170, "tokens collected should be 1170 ");
    //     })
    // });


    // it("Should throw error when called transfer function when the daylimit hasn't passed", async() => {
    //     assert.throws(() => ADXInstance.transfer('0x8F13259D1B217CA6Ce158485B590D0d529b4Ac21', 20), Error);
    // });




});