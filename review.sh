echo_pos() { echo && echo "\033[34m[$1]\033[0m" && echo; }

echo_pos "root"
flutter pub get || exit 1
dart format --output=none --set-exit-if-changed . || exit 1
flutter analyze --fatal-infos || exit 1
flutter test || exit 1

process_example() {
  name=$1
  echo_pos "example/$name"
  cd example/$name || exit 1
  flutter pub get || exit 1
  flutter build web || exit 1
  cd ../..
}

process_example before || exit 1
process_example after || exit 1
process_example common || exit 1

echo_pos "root"
flutter pub publish --dry-run || exit 1
