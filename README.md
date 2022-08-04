# morphs_bulk_minter
morph's Chia NFT bulk minting tool


> !!!!!!!! :warning: CAUTION: Use this with caution! This is a beta build! You could ruin your NFT project if something goes wrong!
I am not responsible for anything that happens to your collection!!!!!!!!!


## Requirements
- You need jq and curl to use this tool:
```bash
sudo apt install jq curl -y
```
- You also need parallel and imagemagick if you want to use my short convert&rename script in data/images/
```bash
sudo apt install parallel imagemagick -y
```
- Chia has to be installed in users home directory
- Chia wallet has to be up and synced
- You generated an NFT wallet already
- Optional: You generated a DID wallet
- You have to upload all image files and put them in data/images/
- You have to upload all metadata files and put them in data/metadata
- The image file and metadata filenames have to match. For example: _image-1.jpg_ and _image-1.json_
-You have to upload the License and insert the CID and filename in the config section
-You can only use nft.storage for now

I recommend using NFT UP from [nft.storage](https://nft.storage/). It gives you the CID after upload and you just have to copy paste it in the config section.

**NOTE**: Only jpg image files for now. Though you could search and replace any "jpg" in the script and replace it with "png" or whatever file extension you wish if you really need to.

## Installation

Install and run:
```bash
cd ~ && git clone https://github.com/morph3us1984/morphs_bulk_minter
```
Use:
```bash
cd ~ && cd morphs_bulk_minter
```
First configure everything you need in bulk_minter.sh using nano for example:
```bash
nano bulk_minter.sh
```
Then run the script:
```bash
bash bulk_minter.sh
```

## Features
- bulk minting of Chia NFTs (duh)
- generating minting.json´s using 2 different methods
  - First Method:
      From config section - Uses CID´s from config section and file names
  - Second Method:
      From links files - Uses list of your files and links in image_links.csv and metadata_links.csv located in the app folder.
  Useful if you have not uploaded your collection in a single go. You have to generate this files yourself. I included 2 example files.

- Batch minting:
  - You can choose between minting 10,100,200,300,500 and 1000 NFTs in one go. Default is set to 0 = ALL. You can set it using the menu point 2.

  I recommend minting 10 first and maximum of 200 for now. 200 will take some hours anyway due to the nature of minting them one by one at the moment.

- Start minting at any point:
  You can set `start_minting_at="1"` in the config section to anything you want. This is not your filename, it is the
the first NFT of your collection. You can set this to anything you want. For example: setting it to 100 will skip the first 99 NFTs and start minting at number 99 of your collection.

- You can combine Batch minting and start_minting_at:

For example: you can set star_minting_at to 100 and Batch minting to 300. Now the tool will mint NFTs #100 to #400

- Already minted check:

The tool has a function to compare which NFTs are already in your wallet to the the collection you are 
minting right now. If the NFT exists already, it will mark this NFT as minted already.
You can trigger this by executing it manuelly with option 5 of the menu. It will also check before and after each minting round.

- Reset functions 4 and 5 in the menu:
"Reset Minting Jsons" will delete all jsons from the folder minting. You can regenerate your files after the reset.
"Reset Minting Logs" will delete all jsons from the folder minting/done. This will delete the log of already minted NFTs.

- Ask you the right order to mint:
The tool will ask you if the order it sees your files is the order you want to mint when its relevant. You can test your files
by issuing a "ls -1v *.jpg" first and rename your files accordingly. This command will show the order in which the tool sees your collection.

- File online check:
Checks if files are really online before hashing and creating the minting Json´s
Process will be aborted if a single file is not available!

## Acknowledgements 
Kudos to https://github.com/steppsr for providing the NFT lookup and list command.

If you want to buy him a beer: 
- XCH: xch1u6m6u8kf4ps5lgup0ce2x0xrcysnm70ag4kzzdte0ggt7z8h6m0qx798nk

If this tool was helping you, consider buying me a beer, or a beer factory, I am not your supervisor!
- XCH:xch1ac74hll6w0ldmrpx3eldhxdck6e4hfyhdw5z8dt8seanfldyj0sqfna064
