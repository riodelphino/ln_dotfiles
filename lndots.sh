#!/bin/zsh

# ~/.config 内に以下の2つのファイルを設置して実行します。
# lndots.sh
# lndots.conf

# 引数
# -c / --convert
#    $parent_dir から $config_dir へファイルやフォルダを移動し、移動元のパスへ symlink を貼ります。
#
# -r / --revert
#    上記操作を元に戻します。(ほぼUNDO)
#
# -t / --test
#    上記 --convert / --revert と組み合わせることで、本番環境に影響を与えずに、テスト環境でテスト実行を行います。
#
# -g / --generate-test-env
#    単体で使用。テスト環境を生成します。
#

# -- Color
w="\e[37m"
b="\e[34m"
g="\e[32m"
y="\e[33m"
r="\e[31m"

# Start
echo "------- lndots.sh -------"

# 設定を読み込み
source ./lndots.conf

# arr_source=(".test" ".test2" ".myapprc" ".testrc" "aaa") # テスト
arr_source=(${arr_dir} ${arr_file}) # 本番用の配列を結合
test_arr_source=(${test_arr_dir} ${test_arr_file}) # テスト用の配列を結合


# コマンドライン引数を取得
while (($# > 0))
do
   case $1 in
      -t | --test )
         echo "test"
         # arr_source を arr_test_source で置き換える
         arr_source=($test_arr_source)
         # target_dir を test_dir で置き換える
         parent_dir=$test_parent_dir
         # # テスト実行のフラグを立てる
         # flag_test=true
      ;;
      -g | --generate-test-env )
         # テスト環境構築のフラグを立てる
         flag_exec="GENERATE_TEST_ENV"
      ;;
      -c | --convert )
         flag_exec="CONVERT"
      ;;
      -r | --revert )
         flag_exec="REVERT"
      ;;
   esac
   shift
done


# 以下は、コマンド引数で --test が与えられていれば、すでに $arr_source や $parent_dir がテスト用に置換された状態で実行される。

# 引数に応じて処理を変える
case $flag_exec in
   "CONVERT")
      # -----------------------------------------------
      # 通常の処理
      # -----------------------------------------------
      echo "CONVERT !!"
      echo $arr_source
      echo $parent_dir

      # 全てのディレクトリに対するループ
      for source in $arr_source; do
         echo "-----------------------------------------------"
         if ! [ -e "${parent_dir}/${source}" ]; then # 移動元ディレクトリやファイルが存在しなかった場合
            echo " ${r}x error  ${w}: '${source}' does not exist."

         else # 移動元ディレクトリが存在した場合
            if [ -L "${parent_dir}/${source}" ]; then type="link"; fi
            if [ -d "${parent_dir}/${source}" ]; then type="dir"; fi
            if [ -f "${parent_dir}/${source}" ]; then type="file"; fi

            first_letter=${source:0:1} # 1文字目を取り出し
            if [ "${first_letter}" = "." ]; then
               target="${parent_dir}/${config_dir}/${source:1}" # 移動先では "." を除いた名前にする
            else
               target="${parent_dir}/${config_dir}/${source}"
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
                     echo "${r}x error  ${w}: '${parent_dir}/${target}' is already exist."
                  else  # 移動先ディレクトリがまだ存在しない
                     mv "${parent_dir}/${source}" "${target}"     # .config 内へ移動させる
                     echo " ${b}o moved  ${w}: ${parent_dir}/${source} --> ${target}"
                     ln -s "${target}" "${parent_dir}/${source}"  # シンボリックリンクを張る
                     echo " ${b}o linked ${w}: ${target} --> ${parent_dir}/${source}"
                  fi
                  ;;
            esac
         fi
      done
      ;;

   "REVERT")
      # -----------------------------------------------
      # 元に戻す処理
      # -----------------------------------------------
      echo "REVERT !!"
      echo $arr_source
      echo $parent_dir

      # 全てのディレクトリに対するループ
      for source in $arr_source; do
         echo "-----------------------------------------------"
         first_letter=${source:0:1} # 1文字目を取り出し
         if [ "${first_letter}" = "." ]; then
            target="${parent_dir}/${config_dir}/${source:1}" # 移動先では "." を除いた名前にする
         else
            target="${parent_dir}/${config_dir}/${source}"
         fi

         if ! [ -e "${target}" ]; then # 移動元ディレクトリやファイルが存在しなかった場合
            echo " ${r}x error  ${w}: '${target}' does not exist."

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
                  if [ -L "${parent_dir}/${source}" ]; then # 移動先ディレクトリまたはファイルがシンボリックリンクとして存在
                     unlink "${parent_dir}/${source}" # リンクを削除
                     echo " ${g}o unlink ${w}: ${parent_dir}/${source}"
                     mv "${target}" "${parent_dir}/${source}"     # .config から戻す
                     echo " ${b}o moved  ${w}: ${target} --> ${parent_dir}/${source}"
                  elif [ -e "../${source}" ]; then # 移動先ディレクトリまたはファイルが存在している(非リンク)
                     echo " ${r}x error  ${w}: '${parent_dir}/${source}' is not a symbolic link."
                  fi
                  ;;
            esac
         fi
      done
      ;;

   "GENERATE_TEST_ENV")
      # テスト環境を作成します。
      # テストフォルダを作成
      echo "mkdir: ${test_parent_dir}"
      mkdir -p "${test_parent_dir}"

      echo "mkdir: ${test_parent_dir}/${config_dir}"
      mkdir -p "${test_parent_dir}/${config_dir}"

      # 本体と設定ファイルをコピー
      pwd
      cp ./lndots.sh "${test_parent_dir}/${config_dir}/"
      cp ./lndots.conf "${test_parent_dir}/${config_dir}/"

      # ディレクトリをコピー (シンボリックリンクの場合はリンク先をコピー)
      for source in $test_arr_dir; do
         src_path="${parent_dir}/${source}"
         echo "Copying dir : ${src_path}  -->  ${test_parent_dir}/"
         cp -RL "${src_path}" "${test_parent_dir}/"
      done

      # ファイルをコピー (シンボリックリンクの場合はリンク先をコピー)
      for source in $test_arr_file; do
         src_path="${parent_dir}/${source}"
         echo "Copying file: ${src_path}  -->  ${test_parent_dir}/"
         cp -L "${src_path}" "${test_parent_dir}/"
      done
      ;;
esac

# なんだこれ？
# cd "${config_dir}"
