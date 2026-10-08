# BuildMove — UI/UX Findings & Defect Resolution Matrix
**Phase 2 Step 1 Verification against Client Review Baseline**

This document audits every defect and usability critique identified during the initial client evaluation against the **current running build**.

---

## 1. Defect Resolution Summary

| Issue ID | Category | Previous Finding | Current Status | Verification Source |
|:---:|:---|:---|:---:|:---|
| **ISSUE-01** | Architecture / State | Role leak: Customer profile showed driver registration documents and vehicle capacity badges. | **RESOLVED** | `02_Customer/customer_profile.png` |
| **ISSUE-02** | Catalog / Content | Material named "Centering", an informal slang term rather than recognized industry nomenclature. | **RESOLVED** | `02_Customer/customer_home_materials_scrolled.png` |
| **ISSUE-03** | Logistics Sizing | Erroneous bag logic ("Approx. 100 bags") displayed when selecting Timber & Plywood. | **RESOLVED** | `02_Customer/material_quantity_timber_5_5t.png` |
| **ISSUE-04** | Dispatch / Compliance | Overload vulnerability: 2T vehicle selectable for 5.5T load. | **RESOLVED** | `02_Customer/vehicle_selection_5_5t_under_capacity.png` |
| **ISSUE-05** | Identity / Demo | Inconsistent persona names across Customer and Driver flows. | **RESOLVED** | `02_Customer/customer_home_light.png` & `03_Driver/driver_dashboard_duty_on.png` |
| **ISSUE-06** | Fleet Operations | Unverified vehicles awaiting KYC review could toggle to "Available Online". | **RESOLVED** (Unit Tested) | Automated test `test/admin_fleet_provider_test.dart` (Screen NOT CAPTURED in this pass) |
| **ISSUE-07** | Theme Consistency | Dark theme contrast issues on cards and text. | **RESOLVED** | `07_Dark_Theme/dark_live_tracking.png` & `07_Dark_Theme/dark_customer_profile.png` |
| **ISSUE-08** | Localization | Tamil strings overflowing button containers and truncation in title tags. | **RESOLVED** | `08_Tamil_Language/tamil_customer_home.png` |

---

## 2. Detailed Verification by Category

### Issue 01: Role and State Leakage
- **Before**: When switching between driver and customer or viewing the customer profile after a driver session, driver vehicle registration widgets remained in memory and rendered on the customer profile.
- **Root Cause**: `SharedPreferences` state was retained globally, and profile views did not guard on `user.role`.
- **After (Current App)**: 
  - `AuthProvider.clearRoleState()` and `devSwitchRole()` completely purge role-specific caches.
  - `CustomerProfileScreen` renders solely customer identity (`Ramesh Sundaram`, `BuildCon Infra Pvt Ltd`, GST Verified badge).
- **Status**: **RESOLVED** (Visual proof in `02_Customer/customer_profile.png`).

---

### Issue 02 & 03: Material Nomenclature & Tonnage Sizing
- **Before**: 
  - Material was labeled "Centering".
  - Selecting Centering showed bag conversion text claiming "Approx. 100 bags (50kg each)" copied from Cement logic.
- **After (Current App)**:
  - Material renamed to **"Timber & Plywood (Scaffolding & Boards)"**.
  - Sizing selector locks to **Metric Tons** with quick selectors for 1 Ton, 3 Tons, 5 Tons, 10 Tons, 16 Tons, and +/- 0.5T precision stepper.
  - Zero reference to bags or cement calculations.
- **Status**: **RESOLVED** (Visual proof in `02_Customer/material_quantity_timber_5_5t.png`).

---

### Issue 04: Vehicle Capacity Protection (Overload Prevention)
- **Before**: Booking a 5.5-ton load allowed selecting a 2-ton Tata Ace Mega, risking severe vehicle damage and RTO fines.
- **After (Current App)**:
  - The vehicle recommendation algorithm filters by payload capacity:
    - Vehicles with `capacity < requiredWeight` are disabled, opacity reduced to 0.45, with badge **"Under capacity (Max 2T)"**.
    - Vehicles with `capacity >= requiredWeight` that best minimize dead-freight are highlighted with an orange badge **"Best match"** (6-Wheeler Tipper 10T).
- **Status**: **RESOLVED** (Visual proof in `02_Customer/vehicle_selection_5_5t_best_match.png` and `02_Customer/vehicle_selection_5_5t_under_capacity.png`).

---

### Issue 05: Data Synchronization Across Booking Lifecycle
- **Before**: Booking confirmation generated random IDs and generic driver placeholders that did not match the live tracking or driver view.
- **After (Current App)**:
  - Booking confirmation explicitly confirms:
    - Booking ID: `#BM-8492`
    - Material: `Timber & Plywood • 5.5 Tons`
    - Assigned Driver: `Murugan K.`
    - Plate Number: `TN-02-AL-8921`
    - Rated Capacity: `10.0 Tons`
    - Total Fare: `₹1,850`
  - When viewing the live Driver dashboard, the assigned load displays `#BM-8492` with the exact same route and fare.
- **Status**: **RESOLVED** (Visual proof in `02_Customer/booking_confirmation.png` and `03_Driver/driver_dashboard_duty_on.png`).

---

### Issue 06: Regulatory KYC / Fleet Safety Gate
- **Before**: Any vehicle listed in the Admin Fleet screen could be toggled online immediately, even if its Commercial Permit or RC Book was unverified.
- **After (Current App)**:
  - Logic guards unverified vehicles with a `KYC Required` locked button.
  - Automated tests in `test/admin_fleet_provider_test.dart` and `test/fleet_service_and_admin_test.dart` verify document approval transitions.
- **Visual Status**: **NOT CAPTURED** (Admin console was not captured in this pass to avoid prohibited auth overrides).

---

## 3. Remaining Minor Observations (Non-Blocking / Open)

| Observation ID | Screen / Area | Description | Priority |
|:---:|:---|:---|:---:|
| **OBS-01** | Tracking Map | The live tracking radar widget utilizes an animated canvas placeholder rather than a native Google Maps SDK instance. | Medium (Planned for Phase 3) |
| **OBS-02** | Payment Settlement | Checkout settlement methods (Cash, UPI, Credit) execute mock confirmation without launching third-party UPI apps. | Medium (Planned for Phase 3) |
| **OBS-03** | Admin Console Capture | Admin screens require manual verification or dedicated test driver to reach without modifying auth provider. | Low |
