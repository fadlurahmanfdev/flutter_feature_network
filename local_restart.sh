fvm use 3.41.6 && fvm global 3.41.6  \
  && fvm flutter clean && fvm flutter pub get \
  && cd example && fvm use 3.41.6 && fvm global 3.41.6 \
  && fvm flutter clean && fvm flutter pub get \
  && fvm dart run build_runner build --delete-conflicting-outputs \
  && cd ..