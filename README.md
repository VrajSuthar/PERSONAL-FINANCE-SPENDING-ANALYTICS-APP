# finance_app

Personal finance & spending analytics app built with Flutter.

## Requirements

| Tool    | Version                |
| ------- | ---------------------- |
| Flutter | 3.41.8 (stable)        |
| Dart    | 3.11.5 (`sdk: ^3.11.5`) |

Check yours with `flutter --version`.

## Getting started

```bash
flutter pub get
flutter run
```

The API base URL comes from `ApiRoutes.baseUrl` and can be overridden with `--dart-define`.

## Tech stack

- **State management:** `flutter_riverpod` (+ `riverpod_annotation` / `riverpod_generator`)
- **Routing:** `go_router`
- **Networking:** `dio` (single `ApiClient` with auth/refresh interceptor)
- **Local storage:** `hive` / `hive_flutter`
- **UI:** `flutter_screenutil`, `google_fonts`, `shimmer`, `animations`, `amazing_icons`

## Folder structure

```
lib/
├── main.dart                 # Entry point: bootstrap(() => MyApp())
├── app/                      # App-level widget/config
├── core/                     # App-wide infrastructure (no feature logic)
│   ├── bootstrap/            # Startup: error handling, Hive, ProviderContainer, initial data
│   ├── constants/            # Static values (e.g. app_images.dart)
│   ├── error/                # Failure, Result, guard() error mapping
│   ├── network/              # ApiClient, routes, envelope, exceptions, AuthInterceptor
│   ├── router/               # GoRouter config and route names
│   ├── theme/                # Colors, text styles, ThemeData
│   ├── utils/                # Helpers
│   └── widgets/              # Core reusable widgets
├── shared/                   # Cross-feature code
│   ├── extensions/
│   └── widgets/
└── features/                 # One folder per feature
    ├── auth/
    ├── dashboard/
    ├── transactions/
    ├── accounts/
    ├── budgets/
    ├── analytics/
    └── settings/
        ├── model/            # Data models
        ├── repository/       # Data access (API / local)
        ├── presentation/     # Screens and state/providers
        └── widgets/          # Feature-specific widgets
```

Each feature uses the same four sub-folders (`model`, `repository`, `presentation`, `widgets`), shown above under `settings/`.

## Startup flow

`main()` calls `bootstrap()` in `lib/core/bootstrap/bootstrap.dart`, which:

1. Sets up error handling (Flutter, platform, and zone errors)
2. Locks orientation to portrait
3. Initialises Hive and opens `auth_box`
4. Creates the `ProviderContainer` and wires `ApiClient.onSessionExpired`
5. Preloads initial app data (`_loadInitialData`)
6. Calls `runApp` inside an `UncontrolledProviderScope`

## Assets

`assets/` contains `icons/`, `jpg/`, `json/`, `png/`, `svg/` and `video/`. Declare new folders under `flutter: assets:` in `pubspec.yaml`.
