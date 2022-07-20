n=1
#Converting all images to jpg if png
ls -1 *.png | parallel convert '{}' '{.}.jpg'
#Backup move all png files
mkdir pngs
mv *.png pngs/
for file in *.jpg ; do mv  "${file}" "${n}".jpg; n=$((n+1));  done
