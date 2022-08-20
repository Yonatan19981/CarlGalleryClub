import { ethers } from "hardhat";

async function main() {
  const [wallet1] = await ethers.getSigners();
	console.log(wallet1.address);
  const CarlGalleryClub = await ethers.getContractFactory("CarlGalleryClub");
  const carlGalleryClub = await CarlGalleryClub.deploy("0x7A3C7cabce56Dee0d3a166cd207ed094dE0C09DF");

  await carlGalleryClub.deployed();

  console.log("CarlGalleryClub deployed to:", carlGalleryClub.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
