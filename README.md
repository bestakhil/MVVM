# MVVM + Login + Feed List + Scroll

An iOS 26 SwiftUI practice project demonstrating MVVM architecture with a login flow, paginated feed list, and image caching.

## Features

- Login screen with "Remember Me" persistence via `@AppStorage`
- Paginated feed list with cursor-based infinite scroll
- Avatar image loading with in-memory `NSCache` caching
- Mock mode toggle — bypasses login and loads local JSON for offline development

## Architecture

**MVVM** with `@Observable` ViewModels (Swift Observation framework, not `ObservableObject`).

```
App Entry
└── ContentView
    └── LoginView  ──(LoginViewModel)
        └── FeedView ──(FeedsViewModel)
            └── FeedRow / CachedImage
```

**Dependency injection** is handled via `AppDependencies`, injected into the SwiftUI environment at the root. Services are protocol-backed so they can be swapped for mocks in tests or previews.

```
AppDependencies
├── NetworkClient       (shared API layer)
├── LoginService        : LoginServiceProtocol
├── FeedsService        : FeedsServiceProtocol
└── PaymentService      : PaymentServiceProtocol
```

## Project Structure

```
FeedList_Scrolling/
├── Models/
│   ├── Feed.swift          Feed, Author, FeedPage, UpdateFeed, DeleteFeed
│   └── LoginModels.swift   LoginRequest, LoginResponse
├── ViewModels/
│   ├── FeedsViewModel.swift
│   └── LoginViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── LoginView.swift
│   └── FeedView.swift      FeedView, FeedRow, CachedImage
├── Services/
│   ├── NetworkClient.swift
│   ├── FeedsService.swift
│   ├── LoginService.swift
│   └── PaymentService.swift
├── Utilities/
│   └── ImageLoader.swift   ImageLoader, ImageCache
├── PreviewMocks/
│   └── PreviewMocks.swift
├── AppDependencies.swift
├── FeedList_ScrollingApp.swift
└── feed.json               Mock feed data (20 items)
```

## Mock Mode

Toggle `mockMode` in `@AppStorage` to switch between live API and local data:

| `mockMode` | Login | Feed data |
|---|---|---|
| `true` | Skipped — navigates directly to feed | Loaded from `feed.json` |
| `false` | Required — navigates on successful `LoginResponse` | Fetched from live API |

## Navigation

Uses `NavigationStack` with two `navigationDestination` modifiers that are mutually exclusive at runtime:

```swift
// Fires immediately when mockMode = true
.navigationDestination(isPresented: $mockMode) { FeedView(...) }

// Fires after successful login when mockMode = false
.navigationDestination(item: $viewModel.loginResponse) { FeedView(...) }
```

## Infinite Scroll

`FeedsViewModel` tracks a `nextCursor` from each API page. `FeedView` triggers `fetchFeeds()` via `.onAppear` when the user is within 2 rows of the end. Loading stops when `nextCursor` is `nil`.

## Requirements

- Xcode 26+
- iOS 26+ deployment target
- Swift 6 strict concurrency

## Build

Open `MVVM+Login+Feed List+Scroll.xcodeproj` and run the `FeedList_Scrolling` scheme on any iOS 26 simulator or device.
