# Create a new directory and enter it
function mk () {
  mkdir -p "$@" && cd "$@"
}

# Open man page as PDF
function manpdf () {
  man -t "${1}" | open -f -a /Applications/Preview.app/
}

# Extra many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract () {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2) tar -jxvf $1 ;;
      *.tar.gz) tar -zxvf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.dmg) hdiutil mount $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar -xvf $1 ;;
      *.tbz2) tar -jxvf $1 ;;
      *.tgz) tar -zxvf $1 ;;
      *.zip) unzip $1 ;;
      *.ZIP) unzip $1 ;;
      *.pax) cat $1 | pax -r ;;
      *.pax.Z) uncompress $1 —stdout | pax -r ;;
      *.Z) uncompress $1 ;;
      *) echo "'$1' cannot be extracted/mounted via extract()";;
    esac
  else
    echo "'$1' is not a valid file to extract"
  fi
}

# Add spaces to dock
dockspacer () {
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
}

# join array
# example use:
# join , a "b c" d      -> a,b c,d
# join / var local tmp  -> var/local/tmp
# join , "${FOO[@]}"    -> a,b,c
join () {local IFS="$1"; shift; echo "$*"; }

# show download history
dlhistory () {
  if [ $1 ]; then
    case $1 in

      show)
        sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineDataURLString from LSQuarantineEvent'
      ;;

      delete)
        sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
        echo "Pooof, download history is all gone…"
      ;;

      --help)
        echo "Usage: dlhistory <subcommand>"
        echo ""
        echo "Available subcommands:"
        echo "   show"
        echo "   delete"
      ;;

      *)
        echo "dlhistory: '$1' is not a dlhistory command. See 'dlhistory --help'."
      ;;

    esac
  else
    dlhistory --help
  fi
}

# MAC address
# mac current - get current mac address
# mac generate - random address
# openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'
# mac spoof
# change mac address to random address
# mac spoof xxxxxx
# change mac address to custom, with error checking

#mac () {
#  if [ $1 ]; then
#    case $1 in
#
#      show)
#    ;;
#}

# Appify - turns shell script into app
appify () {
  APPNAME=${2:-$(basename "$1" ".sh")}
  DIR="$APPNAME.app/Contents/MacOS"

  if [ -a "$APPNAME.app" ]; then
    echo "$PWD/$APPNAME.app already exists :("
    exit 1
  fi

  mkdir -p "$DIR"
  cp "$1" "$DIR/$APPNAME"
  chmod +x "$DIR/$APPNAME"

  echo "$PWD/$APPNAME.app"
}