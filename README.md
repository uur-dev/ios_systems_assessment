# System Task: Post Explorer

A clean, offline first iOS app that fetches posts from the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) and stores them locally using **Realm** - so your data is always there, internet or not. Built with **RxSwift** for a fully reactive UI experience.

---

## Features

- **Live Feed** - Fetches all posts from the API on launch.
- **Offline Support** - Posts are saved to Realm on first load. No internet? No problem.
- **Favourite System** - Tap any post to mark it as a favourite.
- **Reactive UI** - Thanks to RxSwift, toggling a favourite only refreshes that cell — no full table reload.
- **Favourites Screen** - A dedicated screen showing only your saved favourites.
- **Swipe to Remove** - Swipe left on any favourite to delete it from the list.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift |
| UI Framework | UIKit (Storyboards & NIBs) |
| Reactive Programming | RxSwift & RxCocoa |
| Local Database | RealmSwift |
| Networking | Alamofire |

---

## Getting Started

### Prerequisites
- Xcode 15+
- CocoaPods installed

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/uur-dev/ios_systems_assessment.git
cd system-task

# 2. Install dependencies
pod install

# 3. Open the workspace (not .xcodeproj)
open system-task.xcworkspace
```

Then hit **Run** (`⌘R`) in Xcode.

---

## Architecture

The app follows the **MVVM** pattern with a reactive data flow:

```
API / Realm  ->  ViewModel (BehaviorRelay<PostState>)  ->  ViewController (RxBindings)  ->  UI
```

- `PostState` is an enum with four cases: `.loading`, `.loaded([Post])`, `.empty`, `.error(String)`
- The ViewController never holds business logic - it only reacts to state changes
- `PostRealmStore` keeps all database interactions isolated and thread-safe

---

## Performance Notes

- **`BehaviorRelay`** is used to emit state, ensuring only the affected cell is reconfigured on favourite toggle - not the entire table.
- **Realm instances** are scoped per thread to avoid cross-thread access crashes.
- **Empty states** are handled explicitly so users never see a blank screen.

---

## Dependencies (Podfile)

```ruby
pod 'RxSwift'
pod 'RxCocoa'
pod 'RealmSwift'
pod 'Alamofire'
```

---

## Author

**Ubaid ur Rahman**  [UuR](http://uur-dev.com/)
Built with 🤍 - 8th May, 2026
