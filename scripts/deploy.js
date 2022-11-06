const hre = require("hardhat");

async function main() {
  const ExampleUSDCNFT = await hre.ethers.getContractFactory("ExampleUSDC");
  //const ExampleUSDC = await ExampleUSDCNFT.deploy("0xFEca406dA9727A25E71e732F9961F680059eF1F9"); // mumbai
  const ExampleUSDC = await ExampleUSDCNFT.deploy("0x98339D8C260052B7ad81c28c16C0b98420f2B46a"); // goerli

  await ExampleUSDC.deployed();

  console.log("ExampleUSDC deployed to:", ExampleUSDC.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
