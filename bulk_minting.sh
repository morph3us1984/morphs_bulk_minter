#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
NC="\e[0m"
rm links_images_with_hashes.csv
rm links_metadata_with_hashes.csv
rm minting/*.json
####################################################
#CONFIG SECTION
wallet_id_xch="1" #Wallet with funding for minting process
wallet_id="2" #NFT Wallet
wallet_fingerprint="301xxxxxx71"
royalty_address="xch1ac74hll6w0ldmrpx3eldhxdck6e4hfyhdw5z8dt8seanfldyj0sqfna064" #YOUR royalty address
target_address="xch1ac74hll6w0ldmrpx3eldhxdck6e4hfyhdw5z8dt8seanfldyj0sqfna064" #YOUR target address
fee="0"
royalty_percentage="1000" #1000 = 10% ; 100 = 1% ; 10000 = 100%
cid_images="bafybeidajxxxxxxxxxxxxxxxxxxxxxxxxxxxxx4wup6jem"
cid_metadata="bafybeixxxxxxxxxxxxxxxxxxxxxxxxxxxbmqalc4yuj3aim2q"
license_cid="bafybeigkdxxxxxxxxxxxxxxxxxxxxxxxxxxxxxptkkirwete2heple"
license_filename="license.pdf" #just an example
####################################################
i=1
images_count=$(ls data/images/*.jpg | wc -l)
metadata_count=$(ls data/metadata/*.json | wc -l)

link_license="https://$license_cid.ipfs.nftstorage.link/$license_filename"
echo $link_license
license_hash=$(curl "$link_license" | sha256sum | cut -d " " -f 1)
for (( c=$i; c<=$images_count; c++ ))
do
echo $i
link_image="https://$cid_images.ipfs.nftstorage.link/$i.jpg"
echo "$link_image"
hash=$(curl "$link_image" | sha256sum | cut -d " " -f 1)
echo "$i.jpg,$link_image,$hash" >> links_images_with_hashes.csv

link_metadata="https://$cid_metadata.ipfs.nftstorage.link/$i.json"
echo "$link_metadata"
hash=$(curl "$link_metadata" | sha256sum | cut -d " " -f 1)
echo "$i.jpg,$link_metadata,$hash" >> links_metadata_with_hashes.csv
let i++
done
set -x
cat links_images_with_hashes.csv

mkdir minting

while IFS= read -r line; do
echo "Creating minting jsons"
#read in image links hand hashes
filename=$(echo "$line" | cut -d "," -f 1)
nft_link=$(echo "$line" | cut -d "," -f 2)
nft_hash=$(echo "$line" | cut -d "," -f 3)
nft_number="${filename%%.*}"
new_filename=$(echo minting/"$nft_number"_minting.json)
filename_metadata=$(echo "$nft_number".json)
metadata_line=$(grep "$filename_metadata" links_metadata_with_hashes.csv | head -1)
metadata_hash=$(echo "$metadata_line" | cut -d "," -f 3)
metadata_link=$(echo "$metadata_line" | cut -d "," -f 2)

echo "$new_filename"
echo "processing NFT minting json of number $nft_number"

echo "{" >>"$new_filename"
echo -e "\t\"wallet_id\": $wallet_id," >>"$new_filename"
echo -e "\t\"royalty_address\": \"$royalty_address\"," >>"$new_filename"
echo -e "\t\"target_address\": \"$target_address\"," >>"$new_filename"
echo -e "\t\"hash\": \"$nft_hash\"," >>"$new_filename"
echo -e "\t\"uris\": [\"$nft_link\"]," >>"$new_filename"
echo -e "\t\"meta_hash\": \"$metadata_hash\"," >>"$new_filename"
echo -e "\t\"meta_uris\": [\"$metadata_link\"]," >>"$new_filename"
echo -e "\t\"license_hash\": \"$license_hash\"," >>"$new_filename"
echo -e "\t\"license_uris\": [\"https://$license_cid.ipfs.nftstorage.link/$license_filename\"]," >>"$new_filename"
echo -e "\t\"fee\": 0," >>"$new_filename"
echo -e "\t\"royalty_percentage\": 1000" >>"$new_filename"
echo "}" >>"$new_filename"
done < links_images_with_hashes.csv


cd ~/chia-blockchain && . ./activate && cd -
chia wallet show -f "$wallet_fingerprint"

for minting_file in `ls ./minting/ | sort -g`
do
                                paymentin="notdone"
                                while [[ "$paymentin" != "done" ]]
                                do
                                        until [ `chia rpc wallet get_sync_status  | grep "synced"   | cut -d"\"" -f 3  | cut -d" " -f2  | cut -d"," -f1` == "true" ];
                                        do
                                                echo  -e "${YELLOW}SEND Wallet not synced!${NC}"
                                                sleep 30s
                                        done
                                        until [ `chia rpc wallet get_wallet_balance '{"wallet_id": '$wallet_id_xch'}' | grep "spendable_balance" | cut -d ":" -f 2 | cut -d " " -f2 | cut -d "," -f1` -ge "100000" ] ;
                                        do
                                                echo  -e "${YELLOW}SEND Wallet not ready...${NC}"
                                                sleep 10s
                                        done
					echo "working on minting file:"
					echo "----$minting_file----"
                                        output=$(chia rpc wallet nft_mint_nft -j minting/$minting_file)
					echo "$output"
                                        #result=$(echo "$output" | grep "$minting_file" | cut -d "/" -f 4)
					result=$(echo "$output" | grep "success" | cut -d ":" -f 2 | cut -d " " -f 2 | cut -d "," -f 1)
                                        echo "the result is ----$result----"
					if [ "$result" != "true" ]
                                        then
                                                echo -e "${RED}Error while minting, trying again...${NC}"
                                                echo -e "Error: ${output}"
                                                sleep 1s
                                        elif [ "$result" == "true" ]
                                        then
                                                echo -e "${GREEN}minting success${NC}"
                                                paymentin="done"
                                        fi
                                done
done
