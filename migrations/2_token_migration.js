const Rupert = artifacts.require("Rupert")

module.exports = function (deployer) {
    let proxyRegistryAddress = "0xf57b2c51ded3a29e6891aba85459d600256cf317"

    let ipfsHashes = [
        'QmcsBWn7p1wocNLHQpkZ88ohWSYUugmGhLdKMhpd2mNjfw',
        'QmZLbSDpzAvSdowAWkGf6yzBUy3JHiV926YKxw796wChQC',
        'QmS8fiwdRGRwMtVgCywzggGWztJefxjK9HhEARiADbsT1b',
        'QmYZr3dQDo5QSLdfKTn98oXeku9x7ZJFoLe451j9xNZ1Pi',
        'QmdvGBmihht1XdAtVwTN66oG7UpgeEf4ven8CQmY5AsCG9'
    ]

    deployer.deploy(Rupert, proxyRegistryAddress, ipfsHashes)
}
