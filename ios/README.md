# PepTracker (iOS)

Native SwiftUI peptide tracking app — log doses, manage protocols, track vials, and calculate reconstitution math.

## Requirements

- **Xcode 15.3+**
- **iOS 17.0+** (uses SwiftData, the new `@Observable` macro, Charts, and `onChange(of:_:)`)
- macOS 13.5+ to build

## Generating the Xcode project

The repo ships source files plus a `project.yml` for [XcodeGen](https://github.com/yonaskolb/XcodeGen). XcodeGen is the recommended way to keep the `.xcodeproj` reproducible and out of git.

```bash
brew install xcodegen
cd ios
xcodegen generate
open PepTracker.xcodeproj
```

If you'd rather not use XcodeGen, create a new "App" project in Xcode (SwiftUI + SwiftData), then drag the `PepTracker/` folder into the project and remove the auto-generated `ContentView.swift` / `*App.swift` files Xcode creates.

## Architecture

```
PepTracker/
├── App/                          @main entry, ModelContainer setup
├── Models/                       SwiftData @Model types
│   ├── Peptide.swift
│   ├── DosingProtocol.swift
│   ├── DoseLog.swift
│   └── InjectionSite.swift       enums for sites & administration routes
├── Services/                     Pure logic, easy to unit-test
│   ├── ReconstitutionCalculator  vial mg + BAC water → units / mL
│   ├── ScheduleEngine            "is this protocol due on date X?"
│   ├── NotificationManager       UNUserNotifications integration
│   ├── Formatters                centralized dose/date formatting
│   └── SampleData                seed data for previews & tests
├── Views/
│   ├── ContentView               TabView root
│   ├── Today/                    dashboard + log dose sheet
│   ├── Library/                  peptide list, detail, editor, protocol editor
│   ├── Calculator/               reconstitution calculator
│   ├── Stats/                    Charts: daily activity + site rotation
│   ├── Settings/                 notifications, units, data reset
│   └── Components/               shared UI (badges, cards, empty state)
└── Resources/                    Info.plist, asset catalogs

PepTrackerTests/                  XCTest unit tests
```

### Design choices

- **SwiftData over Core Data.** Lightweight, Swift-native, fast to iterate. The store is local-only; no network calls, no third-party SDKs.
- **Pure-function services.** `ReconstitutionCalculator` and `ScheduleEngine` take all inputs explicitly — no SwiftData dependency, no time injection from `Date.now` inside the math — so they are deterministic and unit-testable.
- **Apple HIG-compliant UI.** `.insetGrouped` lists, native `Form` for editors, segmented controls for ranges, system colors and SF Symbols throughout. The accent color is the only brand color and is defined once in the asset catalog.
- **Accessibility.** Every icon-only button has an `.accessibilityLabel`. Progress and status badges read meaningful values to VoiceOver. Dynamic Type is preserved by using semantic font styles.
- **Empty states with clear actions** instead of blank screens.
- **Notifications are reschedulable, not perpetual.** We schedule the next 30 days of `UNCalendarNotificationTrigger`s per protocol and refresh whenever the protocol changes — easier to reason about than recurring triggers and avoids drifting reminders when a schedule changes.
- **Health & safety guardrails.** A disclaimer in Settings makes clear this is a record-keeping tool, not medical advice.

## Math

Reconstitution uses the standard pharmacy formula. Given a `vialMg` peptide reconstituted with `bacWaterMl` of bacteriostatic water:

```
concentration_mcg_per_ml = (vialMg × 1000) / bacWaterMl
volume_ml                = dose_mcg / concentration_mcg_per_ml
units_on_U100_syringe    = volume_ml × 100
```

Worked example: a 5 mg BPC-157 vial reconstituted with 2 mL BAC water gives 2500 mcg/mL. A 250 mcg dose is 0.1 mL — **10 units** on a U-100 insulin syringe.

## Running tests

```bash
xcodebuild test \
  -project PepTracker.xcodeproj \
  -scheme PepTracker \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Privacy

PepTracker stores all data on-device using SwiftData. No analytics, no remote sync, no third-party SDKs.
