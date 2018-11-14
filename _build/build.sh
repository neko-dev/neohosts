mkdir ./_build/tmp/basic -p
mkdir ./_build/tmp/full -p
mkdir ./_build/tmp/127.0.0.1/basic -p
mkdir ./_build/tmp/127.0.0.1/full -p
echo "Adding version code to head"
DATE="$(echo $(date +%Y%m%d%H%M%S))"
echo "#version=$DATE" >> ./_build/head.txt
echo "#*********************************************************" >> ./_build/head.txt
echo "Building standard hosts . . ."
find ./_data/basic -type f -name "*.txt" | xargs cat > ./_build/tmp/basic/1.txt
sed -e '/^#/d' ./_build/tmp/basic/1.txt > ./_build/tmp/basic/2.txt
cp ./_build/tmp/basic/2.txt ./_build/tmp/basic/3.txt
sed -i 's|0.0.0.0|::|g' ./_build/tmp/basic/3.txt
cat ./_build/tmp/basic/2.txt ./_build/tmp/basic/3.txt > ./_build/tmp/basic/4.txt
sort ./_build/tmp/basic/4.txt -u > ./_build/tmp/basic/5.txt
cat ./_build/head.txt ./_build/tmp/basic/5.txt > ./_build/tmp/basic/hosts
echo "Cleaning tmp . . ."
rm ./_build/tmp/basic/1.txt
rm ./_build/tmp/basic/2.txt
rm ./_build/tmp/basic/3.txt
rm ./_build/tmp/basic/4.txt
rm ./_build/tmp/basic/5.txt

echo "Building full hosts . . ."
find ./_data -type f -name "*.txt" | xargs cat > ./_build/tmp/full/1.txt
sed -e '/^#/d' ./_build/tmp/full/1.txt > ./_build/tmp/full/2.txt
cp ./_build/tmp/full/2.txt ./_build/tmp/full/3.txt
sed -i 's|0.0.0.0|::|g' ./_build/tmp/full/3.txt
cat ./_build/tmp/full/2.txt ./_build/tmp/full/3.txt > ./_build/tmp/full/4.txt
sort ./_build/tmp/full/4.txt -u > ./_build/tmp/full/5.txt
cat ./_build/head.txt ./_build/tmp/full/5.txt > ./_build/tmp/full/hosts
echo "Cleaning tmp . . ."
rm ./_build/tmp/full/1.txt
rm ./_build/tmp/full/2.txt
rm ./_build/tmp/full/3.txt
rm ./_build/tmp/full/4.txt
rm ./_build/tmp/full/5.txt

echo "Building hosts with redirecting to 127.0.0.1 . . ."
cp ./_build/tmp/basic/hosts ./_build/tmp/1.txt
sed -i 's|0.0.0.0|127.0.0.1|g' ./_build/tmp/1.txt
cp ./_build/tmp/full/hosts ./_build/tmp/2.txt
sed -i 's|0.0.0.0|127.0.0.1|g' ./_build/tmp/2.txt
cat ./_build/tmp/1.txt > ./_build/tmp/127.0.0.1/basic/hosts
cat ./_build/tmp/2.txt > ./_build/tmp/127.0.0.1/full/hosts
echo "Cleaning tmp . . ."
rm ./_build/tmp/1.txt
rm ./_build/tmp/2.txt

echo "Building Mikrotik Basic Shell . . ."
cat ./_build/tmp/basic/hosts > ./_build/tmp/basic/1.txt
sed -e '/^#/d' ./_build/tmp/basic/1.txt > ./_build/tmp/basic/2.txt
sed -e '/^:/d' ./_build/tmp/basic/2.txt > ./_build/tmp/basic/3.txt
sed -e '/^127.0.0.1/d' ./_build/tmp/basic/3.txt > ./_build/tmp/basic/4.txt
sed -i 's|0.0.0.0 |ip dns static add address=127.0.0.1 name=|g' ./_build/tmp/basic/4.txt
cat ./_build/tmp/basic/4.txt > ./_build/tmp/basic/mikrotik.rsc
echo "Cleaning tmp . . ."
rm ./_build/tmp/basic/1.txt
rm ./_build/tmp/basic/2.txt
rm ./_build/tmp/basic/3.txt
rm ./_build/tmp/basic/4.txt

echo "Building Mikrotik Full Shell . . ."
cat ./_build/tmp/full/hosts > ./_build/tmp/full/1.txt
sed -e '/^#/d' ./_build/tmp/full/1.txt > ./_build/tmp/full/2.txt
sed -e '/^:/d' ./_build/tmp/full/2.txt > ./_build/tmp/full/3.txt
sed -e '/^127.0.0.1/d' ./_build/tmp/full/3.txt > ./_build/tmp/full/4.txt
sed -i 's|0.0.0.0 |ip dns static add address=127.0.0.1 name=|g' ./_build/tmp/full/4.txt
cat ./_build/tmp/full/4.txt > ./_build/tmp/full/mikrotik.rsc
echo "Cleaning tmp . . ."
rm ./_build/tmp/full/1.txt
rm ./_build/tmp/full/2.txt
rm ./_build/tmp/full/3.txt
rm ./_build/tmp/full/4.txt

echo "Building dnsmasq configration . . ."
cat ./_build/tmp/basic/hosts | awk '{gsub(/^eTV(.*)$/,"server=/"$2"/")}1' | sed -e '/^#/d' | sed -e '/^:/d' | sed -e '/^127.0.0.1/d' | sed -e '/^$/d' | awk '{print tolower($0)}' | awk '{gsub(/^[\s\t]*0\.0\.0\.0[\s\t]*(.*)[\s\t]*$/,"server=/"$2"/")}1' | sort | uniq | tee ./_build/tmp/basic/dnsmasq.nxdomain.conf > /dev/null
cat ./_build/tmp/full/hosts  | awk '{gsub(/^eTV(.*)$/,"server=/"$2"/")}1' | sed -e '/^#/d' | sed -e '/^:/d' | sed -e '/^127.0.0.1/d' | sed -e '/^$/d' | sed -e '/^$/d' | awk '{print tolower($0)}' | awk '{gsub(/^[\s\t]*0\.0\.0\.0[\s\t]*(.*)[\s\t]*$/,"server=/"$2"/")}1' | sort | uniq | tee ./_build/tmp/full/dnsmasq.nxdomain.conf  > /dev/null
# TODO remove `awk '{gsub(/^eTV(.*)$/,"server=/"$2"/")}1'`
# TODO cat ./_build/tmp/full/hosts | grep 'eTV'
