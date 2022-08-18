import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

let mnemonic=""
const config: HardhatUserConfig = {
  networks: {
	
		hardhat: {
			accounts:{
			  accountsBalance:"100000000000000000000000000000000000000000000000000000000000",
			},

		},
		mainnet: {
			accounts: { mnemonic },
			url: 'https://polygon-mainnet.infura.io/v3/',
			chainId: 1,
			gas:"auto"
		},

	},
	solidity: {
		compilers: [
			{
				version: '0.8.16',
				settings: {
					optimizer: {
						enabled: true,
						runs: 200
					}
				}
			},
			{
				version: '0.7.0',
				settings: {
					optimizer: {
						enabled: true,
						runs: 200
					}
				}
			}
		]
	},
	etherscan: {
		//apiKey: etherscan_key
	},
	mocha: {
		timeout: 400000
	  }
};

export default config;
