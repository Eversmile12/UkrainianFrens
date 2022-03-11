// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const UkrainianFrens = await hre.ethers.getContractFactory("UkraineFrens");
  const ukrainianFrens = await UkrainianFrens.deploy(50000, "ipfs://bafkreibryykx47t4ytvwllwqycns4yuizla3okhebjtvxypy6bvrwvh4qy");

  await ukrainianFrens.deployed();

  console.log("Ukrainian Frens deployed to:", nft.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
