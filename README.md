# Atlas

A mobile-first iOS concept for a small travel studio. Built in SwiftUI.

White page. Black type. A stack of destination prints you can tap through. No clutter. No cursor trails.

## What it does

- **SplitReveal preloader** — covers the screen, loads images, shows progress on the center line, then opens
- **Card stack** — 4:5 destination prints with press, throw-out, and stack promote
- **Autoplay** — starts after the preloader finishes
- **Caption** — season, trip length, and vibe for the active place
- **Hero intro** — short studio copy + contact CTA under the stack

## Destinations

Santorini · Kyoto · Amalfi · Bali · Alps · Marrakech

Photos are free Unsplash images bundled in the app (works offline).

## Run

```bash
xcodegen generate
open Vows.xcodeproj
```

Requires Xcode and iOS 17+.

## Stack

SwiftUI · Instrument Sans · XcodeGen
