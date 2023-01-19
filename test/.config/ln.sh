#!/bin/zsh
# カレントディレクトリが ~/.config である必要があります。

# -- Color
w="\e[37m"
b="\e[34m"
g="\e[32m"
y="\e[33m"
r="\e[31m"

config_dir=".config"

# ディレクトリ名を列挙
arr_dir=(\
   ".anydesk" ".cargo" ".composer" ".ctags.d" ".cups" ".docker" ".dvdcss" ".gem" ".ncftp" ".phpbrew" ".prettierd" ".pyenv"  \
   ".rsyncosx" ".sdl" ".ssh" ".terminal" ".terminfo" ".vscode" ".w3m" ".wine" ".zsh_sessions"
)
# ファイル名を列挙
arr_file=(\
   ".editorconfig" ".cflocale" \
   ".com.apple.timemachine.donotpresent" ".com.greenworldsoft.syncfolderspro" \
   ".gitconfig" ".gitignore_global" \
   ".lesshst" \
   ".vim-bookmarks" \
   ".vim-info" \
   ".yarnrc" \
   ".zprofile" ".zshrc"
)

# arr_source=(".test" ".test2" ".myapprc" ".testrc" "aaa") # テスト
arr_source=(${arr_dir} ${arr_file}) # 配列を結合

cd .. # ln で相対指定するために上の階層へ移動

cmd_type=$1 # 引数を取得

# 引数に応じて処理を変える
case $cmd_type in
   "")
      # -----------------------------------------------
      # 通常の処理
      # -----------------------------------------------

      # 全てのディレクトリに対するループ
      for source in $arr_source; do
         echo "-----------------------------------------------"
         if ! [ -e "${source}" ]; then # 移動元ディレクトリやファイルが存在しなかった場合
            echo " ${r}x error  ${w}: '${source}' does not exit."

         else # 移動元ディレクトリが存在した場合
            if [ -L "${source}" ]; then type="link"; fi
            if [ -d "${source}" ]; then type="dir"; fi
            if [ -f "${source}" ]; then type="file"; fi

            first_letter=${source:0:1} # 1文字目を取り出し
            if [ "${first_letter}" = "." ]; then
               target="${config_dir}/${source:1}" # 移動先では "." を除いた名前にする
            else
               target="${config_dir}/${source}"
            fi

            # echo "first_letter: ${first_letter}"
            # echo "source: ${source}"
            # echo "target: ${target}"

            case "${type}" in
               "link")
                  # 移動はしない
                  echo " ${r}x error  ${w}:'${source}' is a linked file or directory."
                  ;;
               "dir" | "file")
                  echo " ${g}  type   : ${type}${w}"
                  if [ -e $target ]; then # 移動先ディレクトリが存在
                     echo "${r}x error  ${w}: '${target}' is already exist."
                  else  # 移動先ディレクトリがまだ存在しない
                     mv "${source}" "${target}"     # .config 内へ移動させる
                     echo " ${b}o moved  ${w}: ${source} --> $${target}"
                     ln -s "${target}" "${source}"  # シンボリックリンクを張る
                     echo " ${b}o linked ${w}: ${target} --> ${source}"
                  fi
                  ;;
            esac
         fi
      done
      ;;

   "-r" | "--revert")
      # -----------------------------------------------
      # 元に戻す処理
      # -----------------------------------------------

      # 全てのディレクトリに対するループ
      for source in $arr_source; do
         echo "-----------------------------------------------"
         first_letter=${source:0:1} # 1文字目を取り出し
         if [ "${first_letter}" = "." ]; then
            target="${config_dir}/${source:1}" # 移動先では "." を除いた名前にする
         else
            target="${config_dir}/${source}"
         fi

         if ! [ -e "${target}" ]; then # 移動元ディレクトリやファイルが存在しなかった場合
            echo " ${r}x error  ${w}: '${target}' does not exit."

         else # 移動元ディレクトリが存在した場合
            if [ -L ${target} ]; then type="link"; fi
            if [ -d ${target} ]; then type="dir"; fi
            if [ -f ${target} ]; then type="file"; fi

            case "${type}" in
               "link")
                  # 移動はしない
                  echo " ${r}x error  ${w}:'${target}' is a linked file or directory."
                  ;;
               "dir" | "file")
                  echo " ${g}  type   : ${type}${w}"
                  if [ -L "${source}" ]; then # 移動先ディレクトリまたはファイルがシンボリックリンクとして存在
                     unlink "${source}" # リンクを削除
                     echo " ${g}o unlink ${w}: ${source}"
                     mv "${target}" "${source}"     # .config から戻す
                     echo " ${b}o moved  ${w}: ${target} --> ${source}"
                  elif [ -e "../${source}" ]; then # 移動先ディレクトリまたはファイルが存在している(非リンク)
                     echo " ${r}x error  ${w}: '${source}' is not a symbolic link."
                  fi
                  ;;
            esac
         fi
      done
      ;;
esac

cd "${config_dir}"
