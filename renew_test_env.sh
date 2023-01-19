#!/bin/zsh
# test0 --> test へテスト環境をコピー (test0 はいじってないもともとのやつ)
rm -rf ./test
cp -a ./test0 ./test
cp ./ln.sh ./test/.config/
