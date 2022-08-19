import { ethers } from "hardhat";

async function main() {

  const CarlGalleryClub = await ethers.getContractFactory("CarlGalleryClub");
  const carlGalleryClub = await CarlGalleryClub.deploy();

  await carlGalleryClub.deployed();

  console.log("CarlGalleryClub deployed to:", carlGalleryClub.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
