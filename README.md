# Deputado Transparente

A Flutter mobile application for public transparency that allows Brazilian citizens to browse all active members of Congress and inspect their publicly declared expenses — including itemized receipts accessible directly in the app.

## Play Store

https://play.google.com/store/apps/details?id=com.peixototechnologies.deputadotransparente

Built as the **Final Degree Thesis** for a Systems Analysis and Development degree, this project demonstrates production-grade Clean Architecture applied to a real-world civic accountability use case.

> Data sourced from the official Brazilian Chamber of Deputies Open API:
> [dadosabertos.camara.leg.br](https://dadosabertos.camara.leg.br)

---

## Screenshots

> _Add screenshots here_

---

## Features

- **Browse all active congresspeople** — full list loaded from the official open API
- **Search by name** — real-time search field filters results by congressman name
- **Filter by state (UF)** — bottom sheet with all 26 states + Federal District, each with their official SVG flag
- **Expense detail screen** — view the last 6 months of itemized expenses per congressman, with the total period sum formatted in Brazilian Real (R$)
- **Inline document viewer** — expense receipts open as a PDF viewer or external web view depending on the document type
- **Local caching** — Hive persists API responses locally, reducing redundant network requests
- **Hero animations** — smooth shared-element transitions between the list and detail screens
- **Localization** — English and Portuguese UI via Flutter gen-l10n ([`lib/l10n/app_en.arb`](lib/l10n/app_en.arb), [`lib/l10n/app_pt.arb`](lib/l10n/app_pt.arb)); **Portuguese** when the **primary** device language is Portuguese, **English** otherwise

---

## Architecture

This project follows **Clean Architecture** with strict layer separation and dependency inversion throughout.

```
lib/
├── domain/          # Entities and abstract use case interfaces (no external dependencies)
├── data/            # Use case implementations, HTTP/cache contracts, models, mapping
├── infra/           # Concrete adapters: DioAdapter (HTTP), HiveAdapter (local cache)
├── presentation/    # GetX presenters implementing abstract UI interfaces
├── ui/              # Pages, reusable components, theme, SVG and image assets
└── main/            # App entry point, dependency factories, route definitions
```

### Key design decisions

**Dependency Inversion**
The UI layer depends only on abstract presenter interfaces, not on GetX or any state management library directly. The data layer depends on abstract `HttpClient` and `CacheTransactions` interfaces — not on Dio or Hive. Concrete implementations are injected at the `main/factories` layer.

**Factory Pattern**
All dependency wiring lives exclusively in `main/factories/`. Every page, presenter, use case, and adapter is assembled there, keeping every other layer fully decoupled and independently testable.

**Adapter Pattern**
`DioAdapter` and `HiveAdapter` wrap third-party libraries behind internal contracts defined in the `data` layer. Swapping either library requires changing only the adapter, with zero impact on business logic.

**Stream-driven UI**
Presenters expose `Stream`s consumed by `StreamBuilder` widgets. The UI reacts to data changes without polling or manual `setState` calls beyond local widget state.

---

## Tech Stack

| Concern              | Library                                 |
| -------------------- | --------------------------------------- |
| Framework            | Flutter 3.35.5 (pinned via FVM)         |
| State Management     | GetX                                    |
| HTTP Client          | Dio                                     |
| Local Cache          | Hive + Hive Flutter                     |
| Navigation           | GetX Navigation                         |
| PDF Viewer           | pdfx                                    |
| Web Viewer           | webview_flutter + url_launcher          |
| SVG Rendering        | flutter_svg                             |
| Fonts                | Google Fonts (Poppins)                  |
| Value Equality       | Equatable                               |
| Brazilian Formatting | brasil_fields                           |
| Localization         | flutter_localizations + intl (gen-l10n) |

---

## Localization

- ARB templates live in [`lib/l10n/`](lib/l10n/). After editing strings, run `fvm flutter gen-l10n` (or `fvm flutter pub get`, which triggers code generation).
- Supported locales: **en**, **pt**. **Locale policy:** **Portuguese** only when the **primary** system language is Portuguese (`pt`, `pt_BR`, …). Otherwise **English** — including when Portuguese is only a secondary preferred language on iOS.

---

## Getting Started

### Prerequisites

- [FVM](https://fvm.app/) installed globally
- Flutter **3.35.5** (managed automatically by FVM)

### Run

```bash
fvm install              # installs the pinned Flutter version
fvm flutter pub get      # fetch dependencies
fvm flutter run          # run on a connected device or emulator
```

---

## Project Structure in Detail

```
lib/
├── domain/
│   ├── entities/                  # CongressPersonEntity, CongressPersonExpenseEntity
│   └── usecases/
│       ├── fetch_congress_persons/
│       └── fetch_congress_person_expense/
├── data/
│   ├── http/                      # HttpClient interface + RequestMethod
│   ├── cache/                     # CacheTransactions interface (save/load/delete)
│   ├── models/                    # JSON mapping: Model → Entity
│   └── usecases/                  # RemoteFetchCongressPersons, RemoteFetchCongressPersonExpense
├── infra/
│   ├── http/                      # DioAdapter implements HttpClient
│   └── cache/                     # HiveAdapter implements CacheTransactions
├── presentation/
│   ├── getx_home_presenter.dart
│   └── getx_congress_person_expense_presenter.dart
├── ui/
│   ├── pages/
│   │   ├── home/                  # Search, filter by state, congressman list
│   │   └── congress_person_expense/ # Expense list, PDF viewer, URL viewer
│   ├── assets/
│   │   ├── logo/
│   │   └── states/                # SVG flags for all 27 Brazilian states
│   ├── theme/                     # App colors and text styles
│   └── helpers/                   # BrazilianState model, UIHelper utilities
└── main/
    ├── factories/                 # Dependency wiring for pages, presenters, use cases, HTTP
    ├── routes/                    # AppRoutes constants
    └── main.dart                  # App entry point
```

---

## Author

**Gabriel Campos Peixoto** — Flutter Developer

5+ years building mobile applications for Fortune 500 companies and consumer apps with 1M+ downloads and 99.99% crash-free sessions.

[LinkedIn](https://www.linkedin.com/in/gabriel-peixoto-b4b134200/) · gabriel.cpeixoto1@gmail.com
