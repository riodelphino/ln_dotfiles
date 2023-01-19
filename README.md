# 目的
ドットファイル群を git 管理するため、.config へ移動させた上でもとあった場所へシンボリックリンクを張る。
またその操作を元に戻す。
git での管理方法は別途調べてください。

# 概要
## フォルダ
### test0 ... テスト環境の元々の構成を保存。renew_test_env.sh がこれを test へコピーする。
### test ... テスト環境。何やってもいい。

## 実行ファイル
### ln.sh
    ドットファイルを .config へ移動し、元の場所へシンボリックリンクを張る。
#### オプション : 
    -r / --revert ... 上記の操作を元に戻す。
### renew_test_env
    テスト環境 test フォルダ を元に戻す。
### cp_real_to_test.sh
    .pyenv .zshrc を始めとする実環境のドットファイル群を、一つ上の階層 ../ にコピーする。何やってもいい。
### README.md
    このファイル

# Usage
## テスト
### テスト環境を構築
    cd test
    ../renew_test_env # テスト環境を構築
### ドットファイルを.config へ移動し、元あった場所へシンボリックリンクを張る
    cd .config
    ./ln.sh
### 上記の操作を元に戻す
    ./ln.sh -r
    または
    ./ln.sh --revert
### 注意
    ln.sh / cp_real_to_test.sh は、test/.config ディレクトリ内から実行すること。ディレクトリを相対指定してるので。
### 実環境のドットファイルをテスト環境へコピー
    cd test/.config
    ../../cp_real_to_test.sh
    たぶん。
## 本番実行
    // 後戻りできないのでテストを必ずやってね
    cp -a ln.sh ~/.config/
    cd ~/.config
    ./ln.sh
