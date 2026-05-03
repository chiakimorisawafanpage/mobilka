# Retro Energy Shop — Flutter

Порт учебного магазина с **SQLite** на устройстве (каталог → товар → корзина → оформление → заказы). Ориентир — **Android** (эмулятор Android Studio или устройство).

## Требования

- [Flutter](https://docs.flutter.dev/get-started/install) (stable, Dart **≥ 3.3**)
- Android Studio + Android SDK + запущенный **AVD** (или физический телефон с USB‑отладкой)

`minSdk` задаётся через `flutter.minSdkVersion` в [`android/app/build.gradle`](android/app/build.gradle) (обычно **21** и выше — достаточно для `sqflite`).

## Первый запуск

Из каталога `flutter_app/`:

```bash
flutter doctor
flutter pub get
flutter devices
flutter run
```

Если Gradle/Android‑обвязка не собирается (редко, при несовпадении версий Flutter и шаблона), в **той же папке** можно пересоздать платформенные файлы, не трогая `lib/`:

```bash
flutter create . --project-name retro_energy_shop --org com.example
```

После этого снова `flutter pub get` и `flutter run`.

## Сборка APK (проверка без эмулятора)

```bash
flutter build apk --debug
```

## Структура `lib/`

- `main.dart` — инициализация БД + `Provider` + `MaterialApp`
- `db/` — схема, сид, репозитории (SQL как в RN‑версии)
- `screens/` — экраны
- `navigation/` — табы + вложенные `Navigator`, `RouteObserver`
- `widgets/` — «ретро» UI (`RetroPanel`, `RetroButton`, …)
