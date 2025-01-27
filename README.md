# postmethodssegui

## Generate injectable

```console

flutter packages pub run build_runner build
```

## Generate Envied

```console
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Generate JSON Serializables

```console
flutter pub run build_runner build --delete-conflicting-outputs
```

## Generate Localizations

```console
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart -S assets/translations
```

## Generate Launcher Icons

```console
flutter pub run flutter_launcher_icons -f flutter_launcher_icons.yaml
```

## Generate Splash Screen

```console
dart run flutter_native_splash:create --path=flutter_native_splash.yaml
```
