const Rupert = artifacts.require("Rupert")
const truffleAssert = require("truffle-assertions")

contract("Rupert", (accounts) => {
    const [deployerAddress, tokenHolderOneAddress, tokenHolderTwoAddress] =
        accounts

    let token = null

    before(async () => {
        token = await Rupert.deployed()
    })

    it("mints 5 tokens for the deployer", async () => {
        let deployerBalance = await token.balanceOf(deployerAddress)
        assert.equal(deployerBalance.toString(), "5")
    })

    it("is possible to mint up to 5 more tokens", async () => {
        for (i = 0; i < 5; i++) {
            await token.mintTo(tokenHolderOneAddress, "hash")
        }

        await truffleAssert.fails(
            token.mintTo(tokenHolderOneAddress, "hash"),
            truffleAssert.ErrorType.REVERT,
            "All of Rupert's NFTs have already been minted."
        )

        let tokenHolderOneBalance = await token.balanceOf(tokenHolderOneAddress)
        assert.equal(tokenHolderOneBalance.toString(), "5")
    })

    it("is possible to transfer tokens", async () => {
        let tokenId = await token.tokenOfOwnerByIndex(deployerAddress, 0)

        await token.transferFrom(
            deployerAddress,
            tokenHolderTwoAddress,
            tokenId
        )

        let deployerBalance = await token.balanceOf(deployerAddress)
        let tokenHolderTwoBalance = await token.balanceOf(tokenHolderTwoAddress)

        assert.equal(deployerBalance.toString(), "4")
        assert.equal(tokenHolderTwoBalance.toString(), "1")
    })

    it("returns the correct token URI", async () => {
        let URI = await token.tokenURI(1)

        assert.equal(URI, "ipfs://QmcsBWn7p1wocNLHQpkZ88ohWSYUugmGhLdKMhpd2mNjfw")
    })
})
