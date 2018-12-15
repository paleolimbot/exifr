
cd data-raw
git clone -b gh-pages ssh://git@github.com/paleolimbot/exifr.git gh-pages-branch
cd gh-pages-branch
cp ../exiftool.zip ./exiftool.zip
git add --all *
git commit -m"Update exiftool version" || true
git push origin gh-pages
cd ..
rm -rf gh-pages-branch
