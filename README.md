# 目的
ドットファイル群を git 管理するため、.config へ移動させた上でもとあった場所へシンボリックリンクを張る。  
またその操作を元に戻す。  
  
git での管理方法は別途調べてください。 

<img width="386" alt="スクリーンショット 2023-01-20 3 57 32" src="https://user-images.githubusercontent.com/29378271/213535696-96157df8-d6d6-4d59-b10a-ac1173f84648.png">

<img width="478" alt="スクリーンショット 2023-01-20 3 57 06" src="https://user-images.githubusercontent.com/29378271/213536234-9c815b20-46e5-4edf-b5d5-ce46753da977.png">

# 概要
## フォルダ
*test0*  
テスト環境の元々の構成を保存。renew_test_env.sh がこれを test へコピーする。  

*test*  
テスト環境。何やってもいい。  

## 実行ファイル
*ln.sh*  
ドットファイルを .config へ移動し、元の場所へシンボリックリンクを張る。  
どのドットファイルを操作するかは、中に書いてあるんで適宜編集してね。  
*オプション : *  
-r / --revert ... 上記の操作を元に戻す。  

*renew_test_env*  
テスト環境 test フォルダ を元に戻す。  

*cp_real_to_test.sh*  
.pyenv .zshrc を始めとする実環境のドットファイル群を、一つ上の階層 ../ にコピーする。これなら何やってもいい。  
どのドットファイルを操作するかは、中に書いてあるんで適宜編集してね。  

*README.md*  
このファイル  

# Usage
## テスト
### テスト環境を構築
```zsh
./renew_test_env.sh
```
### ドットファイルを.config へ移動し、元あった場所へシンボリックリンクを張る
```zsh
cd .config
./ln.sh
```
### 上記の操作を元に戻す
```zsh
./ln.sh -r
# または
./ln.sh --revert
```
### 注意
ln.sh / cp_real_to_test.sh は、test/.config ディレクトリ内から実行すること。ディレクトリを相対指定してるので。

### 実環境のドットファイル群をテスト環境へコピー
```zsh
cd test/.config
../../cp_real_to_test.sh
```
## 本番実行
```zsh
# 後戻りできないのでテストを必ずやってからね
cp -a ln.sh ~/.config/
cd ~/.config
./ln.sh
```

# 注意
見たとおりなんせ適当なんで、失敗しても責任は負えません。
テスト環境でテストした上で、注意深く注意深く使用してください。
何なら使わない方がいいです。

