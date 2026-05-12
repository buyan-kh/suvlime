# SuppsAI iOS

Native SwiftUI implementation of the **BOLD 2026** SuppsAI design handoff. The app replaces the old PepTracker build with a bright, high-contrast supplement and peptide coach: plain copy, chunky sticker UI, obvious full-width actions, seeded data, and a complete shallow app surface.

## Requirements

- Xcode 15.3+
- iOS 17.0+
- XcodeGen

## Setup

```bash
cd ios
xcodegen generate
open SuppsAI.xcodeproj
```

Then build the `SuppsAI` scheme for any iOS 17+ simulator.

## API Key Placeholders

The current app is local and preview-safe. When live services are added, replace the placeholders in `SuppsAI/Core/Services/APIPlaceholders.swift`:

```swift
SUPPSAI_COACH_API_KEY
SUPPSAI_RESEARCH_API_KEY
SUPPSAI_ANALYTICS_KEY
```

Do not commit real API keys. Use `.xcconfig`, environment injection, or a secrets provider before shipping.

## Architecture

```text
SuppsAI/
├── App/                    App entry, root routing, shared AppViewModel
├── Core/
│   ├── DesignSystem/       BOLD palette, slab buttons, stickers, cards
│   ├── MockData/           Seeded data for instant previews
│   ├── Models/             Value models for stack, doses, chat, research, progress
│   └── Services/           Reconstitution math and API key placeholders
├── Features/
│   ├── Onboarding/         3-second pitch, plain-language questions, reveal
│   ├── Paywall/            Trial conversion screen
│   ├── Today/              Dose schedule, streak, AI tip
│   ├── Stack/              Current stack, filters, reconstitution result
│   ├── Library/            Compound research browser
│   ├── Coach/              Stack-aware AI chat surface
│   └── Progress/           SuppsAI score, recap, metrics
└── Resources/              Info.plist and asset catalogs
```

The app uses MVVM with `@Observable` view models. `AppViewModel` owns the seeded app state and feature-specific view models expose only the data/actions each screen needs.

## Design Translation

The handoff target was `SuppsAI.html`, specifically the BOLD version:

- Massive value prop: “Take your stuff. Get gains.”
- Third-grade copy: direct questions and short labels.
- Obvious actions: full-width slab buttons, 64pt+ tap targets.
- One loud color per major moment with black borders and hard shadows.
- Complete app surface: onboarding, paywall, Today, Stack, Library, Coach, Progress.

## Previews

Every major view has a SwiftUI preview:

- `ContentView`
- `OnboardingView`
- `PaywallView`
- `TodayView`
- `StackView`
- `LibraryView`
- `CoachView`
- `ProgressView`

All previews use `MockSuppsData.seed`, so they render without accounts, network calls, or setup.

## Deep Links

The app registers the `suppsai` URL scheme for local routing:

- `suppsai://goal` or `suppsai:///goal` reopens onboarding at the goal step.
- `suppsai://today`, `suppsai://stack`, `suppsai://coach`, `suppsai://library`, and `suppsai://progress` open the main app on that tab.

## Tests

```bash
cd ios
xcodegen generate
xcodebuild test \
  -project SuppsAI.xcodeproj \
  -scheme SuppsAI \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

The test target covers core reconstitution math and seeded view-model behavior.

## Privacy and Safety

SuppsAI is a tracking and education prototype, not medical advice. The app should keep the safety line visible in production copy: users should talk to a licensed clinician before starting or changing peptides, GLP-1s, hormones, or supplements.
