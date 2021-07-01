_cd_() {
  cd $1
  PS1="PS C:${PWD////\\\\}> "
}

_back_() {
  cd - &>/dev/null
}

_pwd_() {
  if [ $1 ]; then
    cd $1
    pwd | sed 's/\//\\/g'
    _back_
  else
    pwd | sed 's/\//\\/g'
  fi
}

_list_() {
  ls $1 -lA --time-style=+"%m/%d/%Y %r" | sed '/total/d'
}

_mode_() {
  _list_ $1           |
  awk '{print $1"\t"$6,$7,$8,$5,$9}'  |
    sed 's/wxrwx\t/ /g' |
    sed 's/-----\t/ /g' |
    sed 's/-xr-x\t/ /g' |
    sed 's/-x---\t/ /g' |
    sed 's/--r--\t/ /g' |
    sed 's/wx---\t/ /g' |
    sed 's/wx--x\t/ /g' |
    sed 's/:/ /g'
}

_last_() {
  _list_ | awk '{print $6}'
}

_dir_() {
  echo
  echo -ne "    Directory: C:"
  _pwd_ $1
  echo

  echo -e "Mode\t\tLastWriteTime  \tLength  Name"
  echo -e "----\t\t-------------  \t------  ----"
  printf "%s\t\n" "$(_mode_ $1 | awk '{print $1"\t "$2"  "$3":"$4" "$6"  \t"$7"\t"$8}' | sed 's/4096//g')"

  echo
}

_ppwd_() {
  echo -ne "\nPath\n----\nC:"
  _pwd_
  echo
}

_whoami_() {
  echo "$(uname -n)\\$USER"
}

command_not_found_handle() {
  echo -e "\e[1;91mThe term '$1' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
at line:1 char:9
+ $1 <<<< 
    + CategoryInfo         : ObjectNotFound ($1:String) [], CommandNotFoundException
    + FullQualifiedErrorId : CommandNotFoundException
" "\e[0m"
}

USER=$(whoami)
export HOME=/Users/$USER

alias dir=_dir_
alias ls=_dir_
alias cd=_cd_
alias neofetch='neofetch --ascii_distro windows'
alias pwd=_ppwd_
alias cls=clear~
alias whoami=_whoami_
