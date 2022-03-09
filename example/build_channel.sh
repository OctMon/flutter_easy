flutter build apk --dart-define=app-channel=$1 --obfuscate --split-debug-info=symbols
cd build/app/outputs/apk/release
mv app-release.apk app-$1.apk
