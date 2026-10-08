# BuildMove — Missing, Deferred & Non-Captured Screens
**Phase 2 Scope Boundaries & Honest Evidence Disclosure**

To maintain absolute credibility and transparency with client stakeholders, this document explicitly lists screens and features that are **not captured in the current screenshot pass**, **deferred to future phases**, or **unreachable without modifying application code**.

---

## 1. Screens Not Captured in Current Pass

In accordance with client review rules prohibiting workaround code edits to simulate accessibility, the following screens are honestly documented as **NOT CAPTURED**:

| Screen Name | Intended Role | Accessibility Limitation |
|:---|:---:|:---|
| **Driver Profile Screen** | Driver | Bottom navigation tab could not be triggered via virtio input on Android 14 emulator without code overrides. |
| **Driver Trip History** | Driver | Bottom navigation tab could not be triggered via virtio input on Android 14 emulator without code overrides. |
| **Driver Logout Confirmation Modal** | Driver | Initiated from Driver Profile screen; unreachable without profile access. |
| **Admin Operations Dashboard** | Admin | Switching into the Admin role requires either persona picker navigation or auth state override, which was disallowed by integrity rules. |
| **Admin Verifications Queue** | Admin | Sub-tab of Admin console; unreachable without Admin role access. |
| **Admin Fleet Management (Pre/Post KYC)** | Admin | Sub-tab of Admin console; unreachable without Admin role access. |
| **Dark Theme Booking Confirmation & Vehicles** | Customer | Dark theme mode was verified on Customer Profile and Live Tracking; full booking journey was not recaptured in dark mode. |
| **Tamil Material Selection & Live Tracking** | Customer | Tamil localization was verified on Customer Home; subsequent booking steps were not recaptured in Tamil. |

---

## 2. Explicitly Deferred Features (Not Implemented by Design)

| Feature / Screen | Intended Role | Rationale / Target Phase |
|:---|:---:|:---|
| **Live Native GPS Map (Google Maps SDK)** | Customer / Driver | Phase 2 focuses on data contracts, vehicle capacity logic, and role isolation. The app currently renders an animated vector telemetry radar with simulated coordinates. Production map tiles and Google Directions API are scheduled for Phase 3. |
| **Native Document Camera Scanner** | Driver / Admin | Driver registration currently provides mock pre-verified documents (RC Book, Commercial DL, Fitness Certificate). Native camera capture, edge detection, and OCR extraction are deferred to Phase 3. |
| **Production Payment Gateway SDK (Razorpay / Cashfree)** | Customer | Payment settlement displays working UI options (Cash on Unloading, Instant UPI, Contractor Credit Line) and verifies escrow transaction flows via Riverpod state. Native payment gateway integration is deferred to Phase 3. |
| **Push Notification Receiver (FCM)** | Customer / Driver | Active alerts are displayed in the in-app `/alerts` screen. Firebase Cloud Messaging background receivers are deferred until production backend deployment. |

---

## 3. Summary
By declining to backfill these gaps with old screenshots from `audit_evidence_phase2/`, the `Client_Review` package preserves 100% evidence integrity. Every screenshot delivered represents verified truth from the live running application.
