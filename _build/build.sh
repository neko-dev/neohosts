mkdir ./_build/tmp/basic -p
mkdir ./_build/tmp/full -p

echo "Building standard hosts . . ."
find ./_data/basic -type f -name "*.txt" | xargs cat > ./_build/tmp/basic/1.txt
sed -e '/^#/d' ./_build/tmp/basic/1.txt > ./_build/tmp/basic/2.txt
cp ./_build/tmp/basic/2.txt ./_build/tmp/basic/3.txt
sed -i 's|0.0.0.0|::|g' ./_build/tmp/basic/3.txt >  ./_build/tmp/basic/4.txt
cat ./_build/tmp/basic/2.txt ./_build/tmp/basic/4.txt > ./_build/tmp/basic/5.txt
sort ./_build/tmp/basic/5.txt -u > ./_build/tmp/basic/6.txt
cat ./_build/head.txt ./_build/tmp/basic/6.txt > ./_build/tmp/basic/hosts
echo "Cleaning tmp . . ."
rm ./_build/tmp/basic/1.txt
rm ./_build/tmp/basic/2.txt
rm ./_build/tmp/basic/3.txt
rm ./_build/tmp/basic/4.txt
rm ./_build/tmp/basic/5.txt
rm ./_build/tmp/basic/6.txt

echo "Building full hosts . . ."
find ./_data -type f -name "*.txt" | xargs cat > ./_build/tmp/full/1.txt
sed -e '/^#/d' ./_build/tmp/full/1.txt > ./_build/tmp/full/2.txt
sort ./_build/tmp/full/2.txt -u > ./_build/tmp/full/3.txt
cat ./_build/head.txt ./_build/tmp/full/3.txt > ./_build/tmp/full/hosts
echo "Cleaning tmp . . ."
rm ./_build/tmp/full/1.txt
rm ./_build/tmp/full/2.txt
rm ./_build/tmp/full/3.txt