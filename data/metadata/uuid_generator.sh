substr="1984"
while true
do

uuid=$(uuidgen)

	if [[ $uuid == *"$substr"* ]];
	then
    		echo "String contains substring."
    		echo "$uuid"
    		break
	else
    		echo "String does not contain substring."
	fi
done
