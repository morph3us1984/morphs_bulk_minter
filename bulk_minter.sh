#!/usr/bin/env bash

#CONFIG SECTION
 ####################################################
    wallet_id_xch="" #Wallet with XCH funding for minting process
    wallet_id="" #NFT Wallet
    wallet_fingerprint="" #Your Wallet Fingerprint
    royalty_address="xch1ac74hll6w0ldmrpx3eldhxdck6e4hfyhdw5z8dt8seanfldyj0sqfna064"
    target_address="xch1ac74hll6w0ldmrpx3eldhxdck6e4hfyhdw5z8dt8seanfldyj0sqfna064"
    fee="0"
    royalty_percentage="1000" #1000 = 10% ; 100 = 1% ; 10000 = 100%
    cid_images=""
    cid_metadata=""
    license_cid=""
    license_filename="license.pdf"
    ######The following 2 variables are optional. I highly recommend waiting for the next Chia Version before using them
    series_number="" #Leave empty if you want to set this to 1 (Chia default)
    series_total="" #Leave empty if you want to set this to 1 (Chia defualt)
    start_minting_at="1" #This will skip minting to Number X of the Collection. It will mint every NFT after X, INCLUDED NFT X
####################################################
# MINTING CONFIG DEFAULTS
    batch_minting_range="0" #Zero means ALL NFTs of a Collection will be minted. Please set this only using the Menu! 
    #Lets say you only want to mint #100 to #200 of your Collection. 
    #Then you set start_minting_at to 100 and batch_minting_range to 100
####################################################
# Collection Counting
    images_count=$(ls data/images/*.jpg | wc -l)
    metadata_count=$(ls data/metadata/*.json | wc -l)
    minting_jsons_generated=$(ls minting/*.json | wc -l)
# COLOR SECTION
    ### Colors ##
    ESC=$(printf '\033') RESET="${ESC}[0m" BLACK="${ESC}[30m" RED="${ESC}[31m"
    GREEN="${ESC}[32m" YELLOW="${ESC}[33m" BLUE="${ESC}[34m" MAGENTA="${ESC}[35m"
    CYAN="${ESC}[36m" WHITE="${ESC}[37m" DEFAULT="${ESC}[39m"
   
    ### Color Functions ##

    greenprint() { printf "${GREEN}%s${RESET}\n" "$1"; }
    blueprint() { printf "${BLUE}%s${RESET}\n" "$1"; }
    redprint() { printf "${RED}%s${RESET}\n" "$1"; }
    yellowprint() { printf "${YELLOW}%s${RESET}\n" "$1"; }
    magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }
    cyanprint() { printf "${CYAN}%s${RESET}\n" "$1"; }
    fn_goodafternoon() { echo; echo "Good afternoon."; }
    fn_goodmorning() { echo; echo "Good morning."; }
    fn_bye() { echo "Bye bye."; exit 0; }
    fn_fail() { echo "Wrong option." exit 1; }

### Menu function
# mainmenu
    mainmenu() {
        
        if [ "$batch_minting_range" == "0" ]
        then
            batch_minting_range_display="ALL"
        else
            batch_minting_range_display="$batch_minting_range"
        fi
        echo -ne "
    $(magentaprint 'STATUS')
    Images in your Collection:\t\t"$images_count"
    Metadata Json´s in your Collection:\t"$metadata_count"
    Minting Startpoint is set to:\t"$start_minting_at"
    #########################################
    Minting Json´s generated:\t\t"$minting_jsons_generated"
    #########################################
    Batch Minting Range set to:\t\t"$batch_minting_range_display"
    #########################################
    $(magentaprint 'MAIN MENU')
    $(greenprint '1)') Generate minting JSONs
    $(greenprint '2)') Set Batch Minting Range
    $(greenprint '3)') Reset Minting Jsons
    $(greenprint '4)') Reset Minting Logs
    $(greenprint '5)') Update list of already minted NFTs
    $(greenprint '6)') Mint NFTs
    $(redprint '0)') Exit
    Choose an option:  "
        read -r ans
        case $ans in
        1)
            ask_order_generate_jsons
            mainmenu
            ;;
        2)
            mint_range_submenu
            mainmenu
            ;;
        3)  
            ask_reset
            mainmenu
            ;;
        4)
            ask_reset_already_minted
            mainmenu
            ;;
        5)
            already_minted_checker
            mainmenu
            ;;
	6)
		ask_order_minting
            mainmenu
		;;
        0)
            fn_bye
            ;;
        *)
            fn_fail
            ;;
        esac
    }
# submenu
    mint_range_submenu() {
        echo -ne "
    $(blueprint 'SET BATCH MINTING RANGE')
    $(greenprint '1)') Set Range to 10
    $(greenprint '2)') Set Range to 100
    $(greenprint '3)') Set Range to 200
    $(greenprint '4)') Set Range to 500
    $(greenprint '5)') Set Range to 1000
    $(greenprint '6)') Set Range to ALL
    $(magentaprint '7)') Go Back to Main Menu
    $(redprint '0)') Exit
    Choose an option:  "
        read -r ans
        case $ans in
        1)
            batch_minting_range="10"
            mainmenu
            ;;
        2)
            batch_minting_range="100"
            mainmenu
            ;;
        3)
            batch_minting_range="200"
            mainmenu
            ;;
        4)
            batch_minting_range="500"
            mainmenu
            ;;
        5)
            batch_minting_range="1000"
            mainmenu
            ;;
        6)
            batch_minting_range="0"
            mainmenu
            ;;
        7)
            mainmenu
            ;;
        0)
            fn_bye
            ;;
        *)
            fn_fail
            ;;
        esac
    }
minting_json_method_selection_submenu() {
        echo -ne "
    $(blueprint 'SELECT MINTING JSON GENERATION METHOD')
    #####################################################
    You can either use the config section to generate minting
    Jsons from CID´s if your whole collection was uploaded
    in one go.
    Select: from config
    #####################################################
    Or you have to generate files named:
    image_links.csv and metadata.csv
    The have to look like this:
    image_links.csv
    1.jpg,https://<YOUR CID>.ipfs.nftstorage.link/1.jpg
    2.jpg,https://<YOUR CID>.ipfs.nftstorage.link/2.jpg
    ...
    metadata_links.csv
    1.json,https://<YOUR CID>.ipfs.nftstorage.link/1.json
    2.json,https://<YOUR CID>.ipfs.nftstorage.link/2.json
    ....
    and then select: from link files
    #####################################################
    $(greenprint '1)') from config
    $(greenprint '2)') from link files
    $(magentaprint '3)') Go Back to Main Menu
    $(redprint '0)') Exit
    Choose an option:  "
        read -r ans
        case $ans in
        1)
            minting_json_generate
            mainmenu
            ;;
        2)
            minting_json_generate_from_link_files
            mainmenu
            ;;
        3)
            mainmenu
            ;;
        0)
            fn_bye
            ;;
        *)
            fn_fail
            ;;
        esac
    }
ask_order_minting(){
    echo -e "\t###################Your Collection##################"
    echo -e "\t####################################################"
    ls -1v data/images/*.jpg
    echo -e "\t####################################################"
    echo -e "\t####################################################"
    read -p $'\tThis is the Order in which this Tool will mint this Collection. Is this the right order of your Collection? (y/n)?' choice
    case "$choice" in 
    y|Y ) echo -e "\tyes"; ask_minting;;
    n|N ) echo -e "\tno"; echo -e "\tPlease rename your Collections files so this tool can order them accordingly. You can check the order with \"ls -1v data/images/*.jpg\"" ; return;;
    * ) echo -e "\tInvalid Input. Returning";;
    esac
    }
ask_order_generate_jsons(){
    echo -e "\t###################Your Collection##################"
    echo -e "\t####################################################"
    ls -1v data/images/*.jpg
    echo -e "\t####################################################"
    echo -e "\t####################################################"
    read -p $'\tThis is the Order in which this Tool will mint this Collection. Is this the right order of your Collection? (y/n)?' choice
    case "$choice" in 
    y|Y ) echo -e "\tyes"; minting_json_method_selection_submenu ;;
    n|N ) echo -e "\tno"; echo -e "\tPlease rename your Collections files so this tool can order them accordingly. You can check the order with \"ls -1v data/images/*.jpg\"" ; return;;
    * ) echo -e "\tInvalid Input. Returning";;
    esac
    }
ask_minting(){
    read -p $'\tDid you check everything? Do you realy want to mint? (y/n)?' choice
    case "$choice" in 
    y|Y ) echo -e "\tyes"; minting;;
    n|N ) echo -e "\tno"; return;;
    * ) echo -e "\tInvalid Input. Returning";;
    esac
    }
ask_reset(){
    read -p $'\tThis will delete all minting Json files previously generated. Do you really want to reset minting tool?  (y/n)?' choice
    case "$choice" in 
    y|Y ) echo -e "\tyes"; rm -rf minting/*.json ; minting_jsons_generated=$(ls minting/*.json | wc -l) ; echo -e "\n\n\tMinting Jsons have been deleted. Please regenerate minting.jsons";;
    n|N ) echo -e "\tno"; return;;
    * ) echo -e "\tInvalid Input. Returning";;
    esac
    }
ask_reset_already_minted(){
    read -p $'\tThis will delete all logs of already minted NFTs. Do you really want to reset logs?  (y/n)?' choice
    case "$choice" in 
    y|Y ) echo -e "\tyes"; rm -rf minting/done/*.json ; echo -e "\n\n\tMinting Logs deleted!";;
    n|N ) echo -e "\tno"; return;;
    * ) echo -e "\tInvalid Input. Returning";;
    esac
    }
# check config function
    check_config(){
    if [ -z "$wallet_id_xch" ] ; then echo -e "\tWallet ID which contains the funding is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$wallet_id" ] ; then echo -e "\tNFT Wallet ID is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$wallet_fingerprint" ] ; then echo -e "\tWallet Fingerprint which contains the funding is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$royalty_address" ] ; then echo -e "\tRoyalty Address is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$target_address" ] ; then echo -e "\tTarget address is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$fee" ] ; then echo -e "\tFee is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$royalty_percentage" ] ; then echo -e "\tRoyalty Percentage is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$cid_images" ] ; then echo -e "\tImages CID is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$cid_metadata" ] ; then echo -e "\tMetadata CID is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$license_cid" ] ; then echo -e "\tLicense CID is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$license_filename" ] ; then echo -e "\tLicense Filename is not set! Check Config Section. Aborting..." ; exit ; fi
    # additional mandatory variables
    if [ -z "$start_minting_at" ] ; then echo -e "\tNo starting point set. Tool needs to know where to start minting. Aborting..." ; exit ; fi
    }
    check_config_minting(){
    if [ -z "$wallet_id_xch" ] ; then echo -e "\tWallet ID which contains the funding is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$wallet_id" ] ; then echo -e "\tNFT Wallet ID is not set! Check Config Section. Aborting..." ; exit ; fi
    if [ -z "$wallet_fingerprint" ] ; then echo -e "\tWallet Fingerprint which contains the funding is not set! Check Config Section. Aborting..." ; exit ; fi
    #if [ -z "$royalty_address" ] ; then echo -e "\tRoyalty Address is not set! Check Config Section. Aborting..." ; exit ; fi
    #if [ -z "$target_address" ] ; then echo -e "\tTarget address is not set! Check Config Section. Aborting..." ; exit ; fi
    #if [ -z "$fee" ] ; then echo -e "\tFee is not set! Check Config Section. Aborting..." ; exit ; fi
    #if [ -z "$royalty_percentage" ] ; then echo -e "\tRoyalty Percentage is not set! Check Config Section. Aborting..." ; exit ; fi
    #if [ -z "$cid_images" ] ; then echo -e "\tImages CID is not set! Check Config Section. Aborting..." ; exit ; fi
    #if [ -z "$cid_metadata" ] ; then echo -e "\tMetadata CID is not set! Check Config Section. Aborting..." ; exit ; fi
    #if [ -z "$license_cid" ] ; then echo -e "\tLicense CID is not set! Check Config Section. Aborting..." ; exit ; fi
    #if [ -z "$license_filename" ] ; then echo -e "\tLicense Filename is not set! Check Config Section. Aborting..." ; exit ; fi
    # additional mandatory variables
    if [ -z "$start_minting_at" ] ; then echo -e "\tNo starting point set. Tool needs to know where to start minting. Aborting..." ; exit ; fi
    }
### BULK_MINTING_FUNCTIONS
# generate minting.jsons
minting_json_generate() {
    #check if every image file has its json
    check_config
    same="false"
    same=$(diff  <(ls -1 ./data/images/*.jpg | rev | cut -d "/" -f 1 | rev | sed s/.jpg//g) <( ls -1 ./data/metadata/*.json | rev | cut -d "/" -f 1 | rev | sed s/.json//g))
        if [ -z "$same" ]
        then
		rm minting/*.json
            rm lists/links_images_with_hashes.csv
            rm lists/links_metadata_with_hashes.csv
            touch lists/links_images_with_hashes.csv
            touch lists/links_metadata_with_hashes.csv
            rm lists/collection_nftlinklist.csv
            touch lists/collection_nftlinklist.csv
            i=1
            images_count=$(ls data/images/*.jpg | wc -l)
            metadata_count=$(ls data/metadata/*.json | wc -l)

            link_license="https://$license_cid.ipfs.nftstorage.link/$license_filename"
            echo $link_license
            license_hash=$(curl "$link_license" | sha256sum | cut -d " " -f 1)
            for image_file_name in `ls -1v ./data/images/*.jpg | rev | cut -d "/" -f 1 | rev`
            do
                echo $image_file_name
                link_image="https://$cid_images.ipfs.nftstorage.link/$image_file_name"
                echo $link_image >> lists/collection_nftlinklist.csv
                echo "$link_image"
                test_link=$(curl -o /dev/null --silent -Iw '%{http_code}' $link_image)
                echo $test_link
                if [ "$test_link" == "404" ]
                then
                    echo -e "\t################################################################"
                    echo -e "\t#############WARNING WARNING WARNING############################"
                    echo -e "\tImage does not exist at this resource!\n\tAborting all operations!"
                    return
                fi
                hash=$(curl "$link_image" | sha256sum | cut -d " " -f 1)
                echo "$image_file_name,$link_image,$hash" >> lists/links_images_with_hashes.csv
            done
            test_link="200"
            for metadata_file_name in `ls -1v ./data/metadata/*.json | rev | cut -d "/" -f 1 | rev`
            do
                echo $metadata_file_name
                link_metadata="https://$cid_metadata.ipfs.nftstorage.link/$metadata_file_name"
                echo "$link_metadata"
                test_link=$(curl -o /dev/null --silent -Iw '%{http_code}' $link_metadata)
                echo $test_link
                if [ "$test_link" == "404" ]
                then
                    echo -e "\t################################################################"
                    echo -e "\t#############WARNING WARNING WARNING############################"
                    echo -e "\tMetadata file does not exist at this resource!\n\tAborting all operations!"
                    return
                fi
                hash=$(curl "$link_metadata" | sha256sum | cut -d " " -f 1)
                echo "$metadata_file_name,$link_metadata,$hash" >> lists/links_metadata_with_hashes.csv
            done
            
            echo -e "Image files with hashes:\n"
            cat lists/links_images_with_hashes.csv
            echo -e "Metadata files with hashes:\n"
            cat lists/links_metadata_with_hashes.csv

            while IFS= read -r line; do
                echo "Creating minting jsons"
                #read in image links and hashes
                filename=$(echo "$line" | cut -d "," -f 1)
                nft_link=$(echo "$line" | cut -d "," -f 2)
                nft_hash=$(echo "$line" | cut -d "," -f 3)
                new_filename=$(echo minting/"$filename"_minting.json)
                filename_metadata=$(echo "${filename%%.*}".json)
                metadata_line=$(grep "$filename_metadata" lists/links_metadata_with_hashes.csv | head -1)
                metadata_hash=$(echo "$metadata_line" | cut -d "," -f 3)
                metadata_link=$(echo "$metadata_line" | cut -d "," -f 2)

                
                echo "creating NFT minting json of $filename"
                echo "Filename: $new_filename"

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
                echo -e "\t\"fee\": $fee," >>"$new_filename"
                if [ -n "${series_number}" ]
                then
                echo -e "\t\"series_number\": $series_number," >>"$new_filename"
                fi
                if [ -n "${series_total}" ]
                then
                echo -e "\t\"series_total\": $series_total," >>"$new_filename"
                fi
                echo -e "\t\"royalty_percentage\": $royalty_percentage" >>"$new_filename"
                echo "}" >>"$new_filename"
            done < lists/links_images_with_hashes.csv
        else
        echo -e "\tno matching image or metadata file found, make sure you have a metadata.json for every image file. They have to be named the same (Example: 1.jpg/1.json)\nDifference:\n"
        diff  <(ls -1 ./data/images/*.jpg | rev | cut -d "/" -f 1 | rev | sed s/.jpg//g) <( ls -1 ./data/metadata/*.json | rev | cut -d "/" -f 1 | rev | sed s/.json//g)
        fi
        minting_jsons_generated=$(ls minting/*.json | wc -l)
}
minting_json_generate_from_link_files() {
    #check if every image file has its json
    if [[ ! -f image_links.csv ]]
    then
        echo -e "\tWARNING: image_links.csv does not exist. Exiting"
        return
    fi
    if [[ ! -f metadata_links.csv ]]
    then
        echo -e "\tWARNING: image_links.csv does not exist. Exiting"
        return
    fi
    same="false"
    same=$(diff  <(ls -1 ./data/images/*.jpg | rev | cut -d "/" -f 1 | rev | sed s/.jpg//g) <( ls -1 ./data/metadata/*.json | rev | cut -d "/" -f 1 | rev | sed s/.json//g))
        if [ -z "$same" ]
        then
		rm minting/*.json
            rm lists/links_images_with_hashes.csv
            rm lists/links_metadata_with_hashes.csv
            touch lists/links_images_with_hashes.csv
            touch lists/links_metadata_with_hashes.csv
            rm lists/collection_nftlinklist.csv
            touch lists/collection_nftlinklist.csv
            i=1
            images_count=$(ls data/images/*.jpg | wc -l)
            metadata_count=$(ls data/metadata/*.json | wc -l)

            link_license="https://$license_cid.ipfs.nftstorage.link/$license_filename"
            echo $link_license
            license_hash=$(curl "$link_license" | sha256sum | cut -d " " -f 1)
            #FROM LIST METHOD
            while IFS= read -r line; do
                link_image=$(echo $line | cut -d "," -f 2)
                image_file_name=$(echo $line | cut -d "," -f 1)
                echo $link_image >> lists/collection_nftlinklist.csv
                echo "$link_image"
                test_link=$(curl -o /dev/null --silent -Iw '%{http_code}' $link_image)
                echo $test_link
                if [ "$test_link" == "404" ]
                then
                    echo -e "\t################################################################"
                    echo -e "\t#############WARNING WARNING WARNING############################"
                    echo -e "\tImage does not exist at this resource!\n\tAborting all operations!"
                    return
                fi
                hash=$(curl "$link_image" | sha256sum | cut -d " " -f 1)
                echo "$image_file_name,$link_image,$hash" >> lists/links_images_with_hashes.csv
            done < image_links.csv
            while IFS= read -r line; do
                link_metadata=$(echo $line | cut -d "," -f 2)
                metadata_file_name=$(echo $line | cut -d "," -f 1)
                echo "$link_metadata"
                test_link=$(curl -o /dev/null --silent -Iw '%{http_code}' $link_metadata)
                echo $test_link
                if [ "$test_link" == "404" ]
                then
                    echo -e "\t################################################################"
                    echo -e "\t#############WARNING WARNING WARNING############################"
                    echo -e "\tMetadata file does not exist at this resource!\n\tAborting all operations!"
                    return
                fi
                hash=$(curl "$link_metadata" | sha256sum | cut -d " " -f 1)
                echo "$metadata_file_name,$link_metadata,$hash" >> lists/links_metadata_with_hashes.csv
            done < metadata_links.csv
            #DEBUG
            #echo -e "Image files with hashes:\n"
            #cat lists/links_images_with_hashes.csv
            #echo -e "Metadata files with hashes:\n"
            #cat lists/links_metadata_with_hashes.csv
            ###############DO NOT CHANGE FROM THIS POINT!!!!!
            while IFS= read -r line; do
                echo "Creating minting jsons"
                #read in image links and hashes
                filename=$(echo "$line" | cut -d "," -f 1)
                nft_link=$(echo "$line" | cut -d "," -f 2)
                nft_hash=$(echo "$line" | cut -d "," -f 3)
                new_filename=$(echo minting/"$filename"_minting.json)
                filename_metadata=$(echo "${filename%%.*}".json)
                metadata_line=$(grep "$filename_metadata" lists/links_metadata_with_hashes.csv | head -1)
                metadata_hash=$(echo "$metadata_line" | cut -d "," -f 3)
                metadata_link=$(echo "$metadata_line" | cut -d "," -f 2)

                
                echo "creating NFT minting json of $filename"
                echo "Filename: $new_filename"

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
                echo -e "\t\"fee\": $fee," >>"$new_filename"
                if [ -n "${series_number}" ]
                then
                echo -e "\t\"series_number\": $series_number," >>"$new_filename"
                fi
                if [ -n "${series_total}" ]
                then
                echo -e "\t\"series_total\": $series_total," >>"$new_filename"
                fi
                echo -e "\t\"royalty_percentage\": $royalty_percentage" >>"$new_filename"
                echo "}" >>"$new_filename"
            done < lists/links_images_with_hashes.csv
        else
        echo -e "\tno matching image or metadata file found, make sure you have a metadata.json for every image file. They have to be named the same (Example: 1.jpg/1.json)\nDifference:\n"
        diff  <(ls -1 ./data/images/*.jpg | rev | cut -d "/" -f 1 | rev | sed s/.jpg//g) <( ls -1 ./data/metadata/*.json | rev | cut -d "/" -f 1 | rev | sed s/.json//g)
        fi
        minting_jsons_generated=$(ls minting/*.json | wc -l)
}
#minting

minting(){
            check_config_minting
            if [ -d minting/ ]
            then
	            if [ "$(ls -A minting/*.json)" ]
                then
                    echo -e "\tMinting Json files found."
	            else
                    echo -e "\tNo Minting Json files found. Abort minting...\n\n\tPlease generate minting Jsons first"
                    return
                fi
            else
	            echo "Directory $DIR not found."
            fi
            chia_activate 
            check_wallet_running=$(chia wallet show -f "$wallet_fingerprint" | grep "Connection error" | cut -d "." -f 1 | cut -d " " -f 2 )
            if [ "$check_wallet_running" == "error" ]
            then
                echo 'Wallet not running!!! exiting...'
                return
            else
                    already_minted_checker
                    start_minting_at_temp="$start_minting_at"
                    if [ "$batch_minting_range" == "0" ]
                    then
                        batch_range_end=$images_count
                        echo "DEBUG: batch_range_end is $images_count"
                    elif [ "$start_minting_at" == "1" ] && [ "$batch_minting_range" != "0" ]
                    then
                        start_minting_at_temp="0"
                        batch_range_end=$(($start_minting_at_temp + $batch_minting_range))
                    else
                        batch_range_end=$(($start_minting_at_temp + $batch_minting_range))
                    fi
                    echo -e "DEBUG: batch_range_end is $batch_range_end"
                    #let "start_minting_at_temp=start_minting_at_temp-1"
                    minting_json_number="1"
                    for minting_file in `ls -1v ./minting/*.json`
                    do
                        minting_file=$(echo $minting_file | rev | cut -d "/" -f 1 | rev)
                        if [ "$minting_json_number" -gt "$batch_range_end" ]
                        then
                            echo -e "\tMinting Range End reached. Aborting..."
                            return
                        fi
                        if [ "$minting_json_number" -lt "$start_minting_at" ]
                        then
                            echo -e "\tSkipping minting of $minting_file because it is mint # $minting_json_number and minting will not start before $start_minting_at"
                            let "minting_json_number=minting_json_number+1"
                            continue
                        fi
                        if [ -f minting/done/$minting_file ]
                        then
                            echo -e "\t$minting_file was already minted. Skipping..."
                            let "minting_json_number=minting_json_number+1"
                            continue
                        fi
                            echo "minting $minting_file"
                                                        paymentin="notdone"
                                                        while [[ "$paymentin" != "done" ]]
                                                        do
                                                                until [ `chia rpc wallet get_sync_status  | grep "synced"   | cut -d"\"" -f 3  | cut -d" " -f2  | cut -d"," -f1` == "true" ];
                                                                do
                                                                        echo  -e "${YELLOW}SEND Wallet not synced!${DEFAULT}"
                                                                        sleep 30s
                                                                done
                                                                until [ `chia rpc wallet get_wallet_balance '{"wallet_id": '$wallet_id_xch'}' | grep "spendable_balance" | cut -d ":" -f 2 | cut -d " " -f2 | cut -d "," -f1` -ge "100000" ] ;
                                                                do
                                                                        echo  -e "${YELLOW}SEND Wallet not ready...${DEFAULT}"
                                                                        sleep 10s
                                                                done
                                            echo "working on minting file:"
                                            echo "----$minting_file----"
                                                                output=$(chia rpc wallet nft_mint_nft -j minting/$minting_file)
                                            echo "$output"
                                            result=$(echo "$output" | grep "success" | cut -d ":" -f 2 | cut -d " " -f 2 | cut -d "," -f 1)
                                                                echo "the result is ----$result----"
                                            if [ "$result" != "true" ]
                                                                then
                                                                        echo -e "${RED}Error while minting, trying again...${DEFAULT}"
                                                                        echo -e "Error: ${output}"
                                                                        sleep 10s
                                                                elif [ "$result" == "true" ]
                                                                then
                                                                        echo -e "${GREEN}minted $minting_file successfully${DEFAULT}"
                                                                        paymentin="done"
									sleep 120s
                                                                fi
                                                        done
                    
                    
                    let "minting_json_number=minting_json_number+1"
                    done
		already_minted_checker
            fi
        }
already_minted_checker(){
    chia_activate
    nfturis=$(chia rpc wallet nft_get_nfts '{"wallet_id": '\"$wallet_id\"'}' | jq '.nft_list[].data_uris[0]' | cut --fields 2 --delimiter=\")
    printf "$nfturis\n" > lists/currenturis.csv
    while IFS= read -r nft_data_uri; do
        nft_data_uri_temp=$(echo $nft_data_uri | cut -d "," -f 2 | cut -d "," -f1)
        while IFS= read -r current_nft_data_uri; do
            if [ "$nft_data_uri_temp" == "$current_nft_data_uri" ]
            then
                nft_minting_filename=$(echo $nft_data_uri_temp | rev | cut -d "/" -f1 | rev )
                nft_minting_file=$(echo "$nft_minting_filename"_minting.json)
                echo -e "MATCH FOUND!!!!!!!!!!!!!!!!!!!!!!!!!"
                echo -e "DEBUG: current nft_data_uri is $nft_data_uri_temp"
                echo -e "DEBUG: current current_nft_data_uri is $current_nft_data_uri"
                echo -e "DEBUG: Minting file to be copied: $nft_minting_file"
                cp minting/$nft_minting_file minting/done/$nft_minting_file
            fi
        done < lists/currenturis.csv
    done < lists/links_images_with_hashes.csv
}
chia_activate(){
            echo -e "\tAcitvating Chia Client..."
            echo -e "\treturning to folder:"
            cd ~/chia-blockchain && . ./activate && cd -
}
###
#check_config
mainmenu
