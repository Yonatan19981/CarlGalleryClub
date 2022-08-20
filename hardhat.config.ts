import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { config } from 'dotenv'
config()
const mnemonic = process.env.MNEMONIC
const infura_key = process.env.INFURA_KEY
var private_key = process.env.PRIVATE_KEY
if(!private_key){
  private_key="asdsad"
}
const hhconfig: HardhatUserConfig = {
  networks: {
	
		hardhat: {
			accounts:{
			  accountsBalance:"100000000000000000000000000000000000000000000000000000000000",
			},
		},
		polygon: {
			accounts: { mnemonic },
			url: 'https://polygon-mainnet.infura.io/v3/' + infura_key,
			chainId: 137,
			gas:"auto"
		},
		arbitrum: {
			accounts: { mnemonic },
			url: 'https://arbitrum-mainnet.infura.io/v3/' + infura_key,
			chainId: 42161,
		},
		kovan: {
			accounts: { mnemonic },
			url: 'https://kovan.infura.io/v3/' + infura_key,
			chainId: 42,
			gas:"auto"
		},
		ropsten: {
			accounts: [private_key],
			url: 'https://ropsten.infura.io/v3/' + infura_key,
			chainId: 3
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

export default hhconfig;
