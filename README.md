# Optix - Person Tracker for Homes (iOS)

Optix is a production-ready iOS application built with Swift and SwiftUI that delivers local-first, privacy-focused person tracking and event monitoring for smart home environments. The application integrates with a dedicated analytics backend to provide live camera streams, event alerts, historical logs, and investigation workflows, while leveraging SwiftData for responsive local caching and limited offline access.

---

## Table of Contents

- [Project Status](#project-status)
- [Key Features](#key-features)
- [Architecture and Folder Structure](#architecture-and-folder-structure)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Configuration and Secrets](#configuration-and-secrets)
- [Backend Repository](#backend-repository)
- [Development Notes and Troubleshooting](#development-notes-and-troubleshooting)
- [Contributing](#contributing)
- [Privacy](#privacy)
- [Contact](#contact)

---

## Project Status

**Stable — Production Ready**

The application is fully functional and suitable for deployment in home monitoring environments. Core features including live streaming, event alerting, family management, and investigation workflows are stable and tested.

---

## Key Features

- **Live Camera Streaming** — View real-time RTSP/HLS streams from home cameras with full playback controls and smooth player integration.
- **Event Alerts and Notifications** — Receive push and local notifications immediately when the backend detects activity, with configurable alert preferences per camera.
- **User and Family Management** — Configure household member accounts, roles, and access permissions directly from the app.
- **Floor Plan and Camera Placement** — Visualize camera coverage across floor plans and manage camera assignments per room or zone.
- **Investigation Workflows** — Mark, filter, and review event logs and associated media to audit activity over time.
- **Local Caching with SwiftData** — Persist camera lists, logs, floor data, and user state locally for faster UI responsiveness and offline access to cached content.

---

## Architecture and Folder Structure

The project follows a modular layered architecture that separates networking, business logic, local persistence, and presentation concerns. This structure makes it straightforward to test services and view models independently from UI code.

```
Optix_Person_Tracker_for_Homes-iOS/
├── Core/
│   ├── Networking/         # NetworkManager: HTTP requests, auth, response parsing, base URL config
│   ├── SwiftData/          # Local cache models and SwiftData store configuration
│   └── Utilities/          # Shared helpers — formatters, validators, media players, KeychainHelper
├── Managers/               # Long-lived app-lifecycle managers (e.g., SessionManager)
├── Models/                 # Data models mapping to backend DTOs and local storage structures
│   ├── CCTV.swift
│   ├── User.swift
│   ├── Logs.swift
│   └── ...
├── Services/               # API wrappers per domain — encapsulate networking and response mapping
│   ├── AuthService.swift
│   ├── CCTVService.swift
│   ├── FamilyService.swift
│   └── ...
└── Views/                  # SwiftUI views and view models grouped by feature
    ├── CCTV/
    ├── Home/
    ├── Family/
    ├── Settings/
    └── ...
```

Each feature is implemented as a combination of a SwiftUI view, a dedicated view model, and one or more service calls under `Services/`.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 5.9 |
| UI Framework | SwiftUI |
| Local Persistence | SwiftData |
| Networking | URLSession, NetworkManager (custom) |
| Secure Storage | Keychain via KeychainHelper |
| Camera Streaming | AVFoundation, HLS / RTSP |
| Minimum iOS Version | iOS 17.0 |
| Development Environment | Xcode 15 or later |

---

## Prerequisites

Before setting up the project, ensure the following are in place:

- macOS with Xcode 15 or later installed
- iOS 17.0 or later on the target device or simulator (required for SwiftData and latest SwiftUI APIs)
- A running instance of the Optix backend API (see [Backend Repository](#backend-repository)) with valid credentials
- An Apple Developer account for device builds and code signing

---

## Getting Started

**1. Clone the iOS repository**

```bash
git clone https://github.com/muhammadhussnainsaeed/Optix-Person_Tracker_for_Homes-iOS.git
cd Optix-Person_Tracker_for_Homes-iOS
```

**2. Open the workspace in Xcode**

```bash
open Optix-Person_Tracker_for_Homes-iOS.xcworkspace
```

If only a `.xcodeproj` is present:

```bash
open Optix-Person_Tracker_for_Homes-iOS.xcodeproj
```

**3. Configure the backend API endpoint**

Open `Core/Networking/NetworkManager.swift` and update the `baseURL` property to point to your deployed backend instance:

```swift
let baseURL = "https://your-backend-host.example.com/api/v1"
```

For authentication tokens or API keys, use the provided `KeychainHelper` rather than hardcoding values. See [Configuration and Secrets](#configuration-and-secrets) for details.

**4. Select a target and run**

- Select the `Optix_Person_Tracker_for_Homes_iOS` scheme in Xcode.
- Choose a connected device running iOS 17+ or a compatible simulator.
- Press `Cmd + R` to build and run.

> For camera streaming and push notifications, a physical device is strongly recommended as the simulator has limited support for these capabilities.

---

## Configuration and Secrets

All environment-specific configuration is centralized in two locations:

| File | Purpose |
|---|---|
| `Core/Networking/NetworkManager.swift` | Base URL, timeouts, request/response logging, token injection |
| `Core/Utilities/KeychainHelper.swift` | Secure storage access for tokens and sensitive credentials |

**Do not commit secrets or API keys to source control.** The recommended approaches are:

- **Local development** — Use Xcode `.xcconfig` files or scheme environment variables to inject configuration at build time.
- **CI / Production** — Store credentials in your CI provider (e.g., GitHub Actions Secrets, Fastlane Match) and inject them at build time.

Document all required environment variables in a `.env.example` file at the root of the repository for onboarding new contributors.

---

## Backend Repository

The Optix backend provides the CCTV analytics API, event processing, and stream management services that this iOS application depends on.

**Backend Repository:** [https://github.com/muhammadhussnainsaeed/Optix-Person_Tracker_for_Homes-Backend](https://github.com/muhammadhussnainsaeed/Optix-Person_Tracker_for_Homes-Backend)

Refer to the backend README for setup instructions, API documentation, environment configuration, and deployment guidance. Ensure the backend is running and accessible from your development device before running the iOS application.

---

## Development Notes and Troubleshooting

**SwiftData schema changes**
If you modify any persistent model, the local store may become inconsistent with the new schema during development. To resolve this, delete the app from the simulator or manually clear the SwiftData store file from the app container. Do not modify the schema in production without a migration strategy.

**Networking errors**
Enable verbose logging in `NetworkManager.swift` during development. Use `curl` or Postman to verify endpoint availability and authentication before debugging within the app. Confirm that TLS certificates are valid and that the backend accepts connections from your device's network (check CORS configuration and firewall rules).

**Media playback issues**
RTSP/HLS streams may require specific transport protocols or authentication headers. Confirm stream URLs, codec compatibility, and credential handling with the backend team before investigating playback issues on the client side.

**Common development commands**

```bash
# Open the workspace
open Optix-Person_Tracker_for_Homes-iOS.xcworkspace

# Clean the build folder
# Xcode shortcut: Shift + Cmd + K

# Reset simulator content
# Simulator app → Device → Erase All Content and Settings
```

---

## Contributing

Contributions are welcome. Please follow the workflow below to keep the codebase consistent and review cycles efficient.

**Workflow**

1. Fork the repository.
2. Create a branch using a descriptive naming convention:
   ```bash
   git checkout -b feat/add-camera-filter
   # or
   git checkout -b fix/network-timeout-handling
   ```
3. Make focused, well-documented changes. Move business logic into view models or `Services` rather than embedding it in SwiftUI views.
4. Add unit tests for new or modified business logic where practical.
5. Open a pull request with a clear title, a description of the change, and screenshots where the UI is affected.

**Code Standards**

- Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- Keep view code declarative. Business logic belongs in view models and services.
- Use `KeychainHelper` for any credentials — never hardcode secrets.
- Avoid committing compiled artifacts, secrets, or large binary assets.

**Reporting Issues**

When opening a bug report, include the following:

- Device model and iOS version
- Steps to reproduce the issue
- Expected behavior versus actual behavior
- Relevant console logs or screenshots

---

## Privacy

Optix is designed with a local-first, privacy-conscious approach. All camera stream processing and event analysis is performed server-side within the user's own infrastructure via the self-hosted backend. The iOS application does not transmit raw video or images to any third-party service. Credentials are stored securely in the device Keychain and are never written to disk in plaintext.

---

## Contact

**Muhammad Hussnain Saeed**
GitHub: [@muhammadhussnainsaeed](https://github.com/muhammadhussnainsaeed)

For backend integration questions or deployment support, refer to the [backend repository](https://github.com/muhammadhussnainsaeed/Optix-Person_Tracker_for_Homes-Backend) or open an issue in the relevant repository.
