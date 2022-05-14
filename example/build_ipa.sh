flutter clean

flutter packages get

flutter build ipa --export-method ad-hoc --dart-define=app-debug-flag=true --obfuscate --split-debug-info=symbols

open build/ios/ipa
