# Architecture

Evendly uses a pragmatic feature-first Flutter structure.

```text
Pages and widgets
        ↓
Feature repositories and services
        ↓
Firebase and platform APIs
```

The home feature keeps `home_page.dart` as its navigation and lifecycle shell. Its feed, filter sheet, filter logic, category model, and bottom bar live in focused modules. Firebase streams remain in repositories; the home filter is intentionally applied client-side after the stream so category, price, location, and ticket filters do not require extra Firestore composite indexes.

The orders feature retains its existing data/domain/presentation layout because it already has meaningful separation. This is not presented as strict Clean Architecture.
