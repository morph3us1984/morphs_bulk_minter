# morphs_bulk_minter
morphs Chia NFT bulk minting tool<br>
<br>
<br>
!!!!!!!!CAUTION: Use this with caution! This is a beta build! You could ruin your NFT project if something goes wrong!<br>
I am not responsible for anything that happens to your collection!!!!!!!!!<br>
<br>
<br>
Requirements:<br>
You need jq and curl to use this tool:<br>
sudo apt install jq curl -y<br>
You also need parallel and imagemagick if you want to use my short convert&rename script in data/images/<br>
sudo apt install parallel imagemagick -y<br>
---------------------<br>
-Chia has to be installed in users home directory<br>
-Chia wallet has to be up and synced<br>
-You generated an NFT wallet already<br>
-Optional: You generated a did wallet<br>
-You have to upload all Image files and put them in data/images/<br>
-You have to upload all Metadata files and put them in data/metadata<br>
Those 2 filesnames have to match. For example: image-1.jpg and image-1.json
-You have to upload the License and insert the CID and filename in the config section<br>
-You can only use nft.storage for now<br>
I recommend using NFT UP from nft.storage. It gives you the CID after upload and you just have to copy paste it in the config section<br>
-Only jpg for now. Though you could search and replace any "jpg" in the script and replace it with "png" or whatever file extension you wish if you really need to.<br>
<br>
<br>
Install and run:<br>
cd ~ && git clone https://github.com/morph3us1984/morphs_bulk_minter<br>
Use:<br>
cd ~ && cd morphs_bulk_minter<br>
-First configure everything you need in bulk_minter.sh using nano for example:<br>
nano bulk_minter.sh<br>
-then run the script:<br>
bash bulk_minter.sh<br>
<br>
<br>
Features:<br>
-bulk minting of Chia NFTs (duh)<br>
<br>
-generating minting.json´s using 2 different methods<br>
First Method:<br>
From config section - Uses CID´s from config section and file names<br>
Second Method:<br>
From links files - Uses list of your files and links in image_links.csv and metadata_links.csv located in the app folder.<br>
Useful if you have not uploaded your collection in a single go. You have to generate this files yourself. I included 2 example files<br>
<br>
-Batch minting:<br>
You can choose between minting 10,100,200,300,500 and 1000 NFTs in one go. Default is set to 0 = ALL.<br>
You can set it using the menu point 2.<br>
I recommend minting 10 first and maximum of 200 for now. 200 will take some hours anyway due to<br>
the nature of minting them one by one at the moment<br>
<br>
-Start minting at any point:<br>
You can set start_minting_at="1" in the config section to anything you want. This is not your filename, it is the<br>
the first NFT of your collection. You can set this to anything you want. For example: setting it to 100<br>
will skip the first 99 NFTs and start minting at number 99 of your collection.<br>
<br>
-You can combine Batch minting and start_minting_at:<br>
For example: you can set star_minting_at to 100 and Batch minting to 300. Now the tool will mint NFTs #100 to #400<br>
<br>
-Already minted check:<br>
The tool has a function to compare which NFTs are already in your wallet to the the collection you are <br>
minting right now. If the NFT exists already, it will mark this NFT as minted already.<br>
You can trigger this by executing it manuelly with option 5 of the menu. It will also check before and after each minting round.<br>
-Reset functions 4 and 5 in the menu:<br>
"Reset Minting Jsons" will delete all jsons from the folder minting. You can regenerate your files after the reset.<br>
"Reset Minting Logs" will delete all jsons from the folder minting/done. This will delete the log of already minted NFTs.<br>
<br>
-Ask you the right order to mint:<br>
The tool will ask you if the order it sees your files is the order you want to mint when its relevant. You can test your files<br>
by issuing a "ls -1v *.jpg" first and rename your files accordingly. This command will show the order in which the tool sees your collection.<br>
<br>
-File online check:<br>
Checks if files are really online before hashing and creating the minting Json´s<br>
Process will be aborted if a single file is not available!<br>
<br>
<br>
<br>
If this tool was helping you, consider buying me a beer, or a beer factory, I am not your supervisor!<br>
XCH:xch1ac74hll6w0ldmrpx3eldhxdck6e4hfyhdw5z8dt8seanfldyj0sqfna064
