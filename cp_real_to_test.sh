#!/bin/zsh
# テスト用のドットファイルを実環境からテスト環境へコピー

arr_dir=(
   ".composer" ".ctags.d" ".cups" ".prettierd"
   ".rsyncosx" ".sdl" ".ssh" ".terminal" ".terminfo" ".w3m" ".zsh_sessions"
)
# ファイル名を列挙
arr_file=(
   ".editorconfig" ".cflocale"
   ".com.apple.timemachine.donotpresent" ".com.greenworldsoft.syncfolderspro"
   ".gitconfig" ".gitignore_global"
   ".zprofile" ".zshrc"
)

# arr_source=(".test" ".test2" ".myapprc" ".testrc" "aaa") # テスト
arr_source=(${arr_dir} ${arr_file}) # 配列を結合

for source in $arr_source; do
   echo "~/${source}"
   cp -a ~/${source} ./
done
