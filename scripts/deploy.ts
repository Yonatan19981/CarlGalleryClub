import { ethers } from "hardhat";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  const lockedAmount = ethers.utils.parseEther("1");

  const CarlGalleryClub = await ethers.getContractFactory("CarlGalleryClub");
  const carlGalleryClub = await CarlGalleryClub.deploy("CarlGalleryClub","CGC");

  await carlGalleryClub.deployed();

  console.log("CarlGalleryClub deployed to:", carlGalleryClub.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
