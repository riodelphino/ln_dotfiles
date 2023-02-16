# Concepts
ドットファイル群を git 管理する。
そのために、ドットファイルを .config へ移動させた上で、もとあった場所へシンボリックリンクを張る。  
その操作を元に戻す UNDO 機能付き。  
  
git での管理方法は別途調べてください。 

あと、新PCで git clone で ~/.config を落としてきた場合に、シンボリックリンクだけを貼ってくれると良いのですが、たぶん ./lndots.sh でそのままイケる (mv がエラー吐くだけでその次の ln は動作するはず)

# Screen Shots
 (画像では旧名の ln.sh となってますが、現在のファイル名は lndots.sh です)
#### `lndots.sh` 実行結果
<img width="389" alt="ln sh_01" src="https://user-images.githubusercontent.com/29378271/213618440-423df05a-275d-4b87-8e79-bcedbdb9aa4f.png">
<img width="773" alt="ln sh_02" src="https://user-images.githubusercontent.com/29378271/213619022-401d7681-4017-45e9-830c-692c5270d65a.png">

#### `lndots.sh --revert` 実行結果
<img width="389" alt="ln sh_revert_01" src="https://user-images.githubusercontent.com/29378271/213619277-5779107d-062a-4b48-80b8-38b9433dbb44.png">
<img width="773" alt="ln sh_revert_02" src="https://user-images.githubusercontent.com/29378271/213619312-0b75d0b7-bbc1-45a6-beaa-0344ca7da496.png">

# Capability
- 対象ファイル/フォルダをリスト管理する  
- 自動的に Dotfiles を ~/.config へ移動させ、元あった位置へシンボリックリンクを貼る  
- それを UNDO する  
- あと、新PCで git clone で ~/.config を落としてきた場合に、シンボリックリンクだけを貼ってくれると良い(たぶんイケる)  

# Summary
## フォルダ
#### test0/  
テスト環境の元々の構成を保存。renew_test_env.sh がこれを test へコピーする。  

#### test/  
テスト環境。何やってもいい。  

## 実行ファイル
#### lndots.sh  
ドットファイルを .config へ移動し、元の場所へシンボリックリンクを張る。  
どのドットファイルを操作するかは、中に書いてあるんで適宜編集してね。  
*オプション : *  
-r / --revert ... 上記の操作を元に戻す。  

#### renew_test_env.sh  
テスト環境 test フォルダ を元に戻す。  

#### cp_real_to_test.sh  
.pyenv .zshrc を始めとする実環境のドットファイル群を、一つ上の階層 ../ にコピーする。これなら何やってもいい。  
どのドットファイルを操作するかは、中に書いてあるんで適宜編集してね。  

#### README.md  
このファイル  

# Usage
## Test
なにはともあれ、テストは必ず行うこと。  
大事なファイルを失わないために。  

### テスト環境を構築
```zsh
./renew_test_env.sh
```
### ドットファイルを.config へ移動し、元あった場所へシンボリックリンクを張る
```zsh
cd .config
./lndots.sh
```
### 上記の操作を元に戻す
```zsh
./lndots.sh -r
# または
./lndots.sh --revert
```
### Warning
lndots.sh は、test/.config ディレクトリ内に配置して、そこから実行すること。  
ディレクトリを相対指定してるのと、これ自身も git 管理するためです。  

cp_real_to_test.sh は実環境のドットファイルの一部をカレントディレクトリにコピーしてきます。  
なので、コピーしたい先のディレクトリで実行してください。

### 実環境のドットファイル群をテスト環境へコピー
```zsh
cd test/.config
../../cp_real_to_test.sh
```
## 本番実行
```zsh
# 後戻りできないのでテストを必ずやってからね
cp -a lndots.sh ~/.config/
cd ~/.config
./ln_dotifiles.sh
```

# Warning
ご覧のとおりなんせ適当なんで、失敗しても責任は負えません。  
テスト環境でテストした上で、注意深く注意深く使用してください。  
何なら使わない方がいいです。  

