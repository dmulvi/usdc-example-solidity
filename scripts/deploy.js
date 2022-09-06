const hre = require("hardhat");

async function main() {
  const EthMerk721NFT = await hre.ethers.getContractFactory("EthMerk721");
  const EthMerk721 = await EthMerk721NFT.deploy();

  await EthMerk721.deployed();

  console.log("EthMerk721 deployed to:", EthMerk721.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
