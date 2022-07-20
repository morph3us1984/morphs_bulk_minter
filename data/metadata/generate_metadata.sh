
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

i=1
START=1
metadata_file_count=$(ls ../images/*.jpg | wc -l)
echo "metadata file count is: "$metadata_file_count""
for (( c=$START; c<=$metadata_file_count; c++ ))
do
echo $i
cp metadata.json.default $i.json
let i++
done

for f in *.json;
do
echo "Processing $f file..";
filename="${f%%.*}"
echo "$filename"
number="Stick Figure #${filename}"
echo "$number"
echo "$f"
tmpfile=$(mktemp)
cp "$f" "$tmpfile"
jq --arg num "$number" '.name |= $num' "$tmpfile" >$f.temp
mv $f.temp $f
rm -f "$tmpfile"
tmpfile=$(mktemp)
cp "$f" "$tmpfile"
jq --arg id "$uuid" '.collection.id |= $id' "$tmpfile" >$f.temp
mv $f.temp $f
rm -f "$tmpfile"
done

