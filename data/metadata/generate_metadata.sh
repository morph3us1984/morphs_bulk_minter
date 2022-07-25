i=1
set -x
for i in {1..13}
do
echo $i
cp metadata.json.default $i.json

done
#jq '.LINE.X_serial |= "Test Image #\$f"' 123.json
for f in *.json;
do
echo "Processing $f file..";
filename="${f%%.*}"
echo "$filename"
number="Testing morphs bulk minter #${filename}"
echo "$number"
echo "$f"
#jq '.description |= "Testfiles for morphs bulk minter!"' $f
#jq --arg num "$number" '.name |= $num' $f >$f
tmpfile=$(mktemp)

cp "$f" "$tmpfile"
jq --arg num "$number" '.name |= $num' "$tmpfile" >$f.temp
mv $f.temp $f
rm -f "$tmpfile"
done

