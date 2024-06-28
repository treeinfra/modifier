# Which example to run.
aim=$1

# Ensure input parameter is valid (only two examples: before and after).
if [ "$aim" != "before" ] && [ "$aim" != "after" ]; then
  echo "Usage: $0 <before|after>"
  exit 1
fi

# Use Edge on Windows, while use Chrome on other platforms.
browser=""
if [ "$(uname -s)" == "Windows_NT" ]; then
  browser="edge"
else
  browser="chrome"
fi

# Launch flutter app, only web is supported.
cd example/$aim
flutter run -d $browser || exit 1
cd ../..
