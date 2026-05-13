---
name: testing-retro-energy-shop
description: Test the Retro Energy Shop Flutter app end-to-end on Linux desktop. Use when verifying UI changes, navigation fixes, or visual design updates.
---

# Testing Retro Energy Shop

## Prerequisites

### System Dependencies (Linux)
```bash
sudo apt-get install -y cmake ninja-build pkg-config libgtk-3-dev clang lld wmctrl
```

### Flutter SDK
Flutter SDK should be available at `/home/ubuntu/flutter`. Add to PATH:
```bash
export PATH="/home/ubuntu/flutter/bin:$PATH"
```

### Linux Platform Support
If the project doesn't have a `linux/` directory, add it:
```bash
flutter create --platforms=linux .
```

## Build & Run

```bash
export PATH="/home/ubuntu/flutter/bin:$PATH"
export DISPLAY=:0
flutter pub get
flutter analyze  # should show 0 issues
flutter run -d linux
```

The app runs as a native Linux desktop window. Use `wmctrl` to maximize it before recording:
```bash
wmctrl -r "retro_energy_shop" -b add,maximized_vert,maximized_horz
```

## Key Architecture Notes

- **Navigation**: Multi-stack Navigator with `IndexedStack` — each tab (Shop, Cart, Orders, Profile) has its own Navigator
- **State management**: Provider with `AppShellController` for tab switching
- **Database**: SQLite via `sqflite` (mobile) / `sqflite_common_ffi` (desktop). FFI init required in `main.dart` for Linux/Windows
- **Route observers**: Each tab Navigator MUST have its own `RouteObserver` — sharing one observer across multiple Navigators causes assertion errors
- **BorderRadius constraint**: Flutter does not allow `borderRadius` on `BoxDecoration` with non-uniform `Border` colors (e.g., 3D bevel effects with different colors per side)

## E2E Test Flow

Recommended sequence to test all screens and critical navigation paths:

1. **Catalog (Shop tab)**: Verify product list renders, search/filter panel visible, blue marquee scrolling
2. **Product Detail**: Tap "DETAILS" on any product → should open ProductScreen (NOT duplicate catalog). This tests `onGenerateRoute` for `/product` route
3. **Add to Cart + Tab Switch**: Click "ADD TO CART" then "GO TO CART" → should switch to Cart tab. This tests `AppShellController.setTab()`
4. **Checkout**: Click "CHECKOUT" → fill address → "CONFIRM ORDER" → should show success screen with "THANK YOU!"
5. **Orders Tab Switch**: Click "GO TO ORDERS" on success screen → should switch to Orders tab. This tests `goToTabAndPopToRoot()`
6. **Order Detail**: Tap an order in the list → should open OrderDetailScreen. This tests `onGenerateRoute` for `/order` route
7. **Profile**: Switch to Profile tab → verify name/phone inputs and badges render
8. **Error Check**: Navigate all tabs, verify no red error screens or Flutter exceptions

### Known Issue
Orders list may not auto-refresh when switching tabs via "GO TO ORDERS" button. The order IS saved in SQLite — it appears after hot restart (`R` in flutter console). This is a pre-existing UX issue, not a bug.

## Hot Restart
In the Flutter console, press `R` (capital) for hot restart or `r` for hot reload. Hot restart re-runs `initState` on all widgets and reloads data from SQLite.

## Lint Check
```bash
export PATH="/home/ubuntu/flutter/bin:$PATH"
flutter analyze
```

## Devin Secrets Needed
None — this app runs fully locally with SQLite, no external APIs or credentials required.
