**Ethereum Merkle Tree Based Whitelist Sample**

This is an example project to help explain merkle tree based whitelists. It is only a sample. You will very likely need to modify it to fit your needs. No warranty or guarantee of any sort is included with this ***SAMPLE*** software package.

**Getting Started**

Install the dependencies

`npm install`


Copy the .env file template

`cp sample.env .env`

Add required environment variables

```env
RINKEBY_RPC_URL=
GOERLI_RPC_URL=
ETHERSCAN_KEY=
PUBLIC_KEY=
PRIVATE_KEY=
```

1. You can get RPC urls from providers such as https://infura.io/, https://www.alchemy.com/, etc. 

2. Get an Etherscan key (to verify your contract)
https://info.etherscan.com/etherscan-developer-api-key/

3. Save your public key address to the .env file

4. Export private key from metamask or another wallet. You probably should not use the same wallet that you store mainnet assets in. Create a new dev focused metamask account to minimize the risk of storing your private key in plaintext files. 

---

**To deploy the contract to a testnet run the following command:**

`npx hardhat run --network goerli scripts/deploy.js`

Wait about a minute and then verify the Contract. (You'll need an etherscan API key)

`npx hardhat verify --network goerli "0x__CONTRACT_ADDR_FROM_PREVIOUS_STEP__"`

---

To test out the `mintWhitelist` function in this sample contract you'll need to calculate a merkle root and then update the contract with it. 

**How to calculate a merkle root:**
You can use this package to calculate merkle root in javascript: https://github.com/Crossmint/merkle-pkg. There are directions in that repo. 

Once you have your merkle root calculated you need to update the contract. A sample merkle root will look like this: `0x57570dbcb8388f7a4cb09bf05bcb6c44f46b11a956b25a1b6d50a2d27f2ee71e`

With your contract verified navigate to the write contract tab on the relevant etherscan block explorer. For example, here is a link to a deployed copy of this repo: https://goerli.etherscan.io/address/0x67b221ce0e5f41d445a5623ee52dfe95b4dc3bbf#writeContract

Connect your metamask using the "Connect to Web3" button above the function sections: If the button isn't working open metamask and select the correct network. For example, in this scenario I had to pre-select Goerli network. Then try clicking the connect button again.

![connect web3 screenshot](https://nftstorage.link/ipfs/bafkreicl7zb5jfb5nxaiytpflg4t27ijxdn6ctp7itcf5uguji7mpxut2e)
*Note: this will need to be the same pub/private key that you deployed the contract with*

Then scroll down to the `setMerkleRoot` function and set the calculated merkle root. 

![setMerkleRoot](https://nftstorage.link/ipfs/bafkreiedpcqoh65jnih624y67jc7sxhckb3bk2llnmsk6amx55wu2wiymq)
*Just a sample, you should calculate your own root*

Click the "Write" button, this will open metamask. You may want to edit the gas estimate and set it to High to speed things up while on the testnet. Approve the transaction and wait for the update to be confirmed. 

---
Now that you have a real deal contract deployed with a whitelist and everything you're ready to add crossmint support. As of the writing of this readme it requires some manual assistance from our support. Contact us on discord or at support@crossmint.io. We will be adding the ability to edit whitelist to the console soon. We will need the full list of whitelisted addresses so that we can calculate the proof for minting. 

To support mintint with a credit card your users will need to have a crossmint account first. All we need to generate this for them is an email address. To support a high number of credit card minters during the presale you may want to use our free accesslist tool to collect their emails. This automatically generates a crossmint account for them. We still need to coordinate before your presale goes live to share the list of crossmint wallet addresses with you and get your full list of standard ethereum addresses too. 