# BuildMove — Screenshot Provenance & Evidence Integrity Report
**Cryptographic Integrity Audit & Provenance Verification**

- **Date of Audit:** October 2026
- **Auditor:** BuildMove QA & Integrity Agent
- **Target Platform:** Android Emulator `emulator-5554` (Android 14 / API 34)
- **Hash Algorithm:** SHA256
- **Total PNG Files Currently in `Client_Review/`:** **44**
- **Unique Fresh Current Captures:** **21**
- **Organized Gallery Copies (Duplicates):** **23**
- **Previous Screenshots Removed from `Client_Review/`:** **23**
- **Screenshots Retained from Previous Evidence:** **0**

---

## 1. Evidence Integrity Certification
In strict adherence to client review guidelines:
1. **Zero Reused Evidence**: No screenshots from `audit_evidence_phase2/`, previous review archives, or external mockups are presented as freshly captured screenshots.
2. **Cryptographic Deduplication**: Every image file was analyzed using SHA256 hashing. All 23 files that were previously copied from `audit_evidence_phase2/` have been **completely removed** from `Client_Review/`.
3. **No Code Workarounds**: No source code (`lib/`, `test/`, routing, auth providers) was modified to bypass navigation or accessibility constraints. Screens that could not be reached naturally in the unmodified app are honestly designated **NOT CAPTURED**.

---

## 2. Verified Active Files in `Client_Review/` (44 Total)

### Table 1: Current Fresh Captures & Gallery Copies

| # | Current Path in `Client_Review/` | Classification | File Size | SHA256 Checksum (Prefix) | Provenance Notes |
|:---:|:---|:---:|:---:|:---:|:---|
| 1 | `01_Login_Authentication/customer_phone_login.png` | **CURRENT APP CAPTURE** (Unique) | 190,041 B | `F026521ED1AB...` | Fresh capture from running app on emulator-5554 |
| 2 | `01_Login_Authentication/otp_verification.png` | **CURRENT APP CAPTURE** (Unique) | 96,295 B | `AEEC41E8C841...` | Fresh capture from running app on emulator-5554 |
| 3 | `01_Login_Authentication/persona_selector_dialog.png` | **ORGANIZED COPY** | 190,041 B | `F026521ED1AB...` | Copy of #1 (captures persona chips on login) |
| 4 | `02_Customer/customer_home_light.png` | **CURRENT APP CAPTURE** (Unique) | 190,954 B | `83A8E9CD964F...` | Fresh capture of customer home (Ramesh Sundaram) |
| 5 | `02_Customer/customer_home_materials_scrolled.png` | **CURRENT APP CAPTURE** (Unique) | 171,188 B | `29AC6A0FCDC0...` | Fresh capture of catalog showing Timber & Plywood |
| 6 | `02_Customer/material_quantity_timber.png` | **CURRENT APP CAPTURE** (Unique) | 158,737 B | `412033DB9088...` | Fresh capture of Step 1 Timber selection |
| 7 | `02_Customer/material_quantity_timber_5_5t.png` | **CURRENT APP CAPTURE** (Unique) | 190,678 B | `8EAB8B406107...` | Fresh capture of Step 1 5.5 Metric Tons |
| 8 | `02_Customer/vehicle_selection_5_5t_best_match.png` | **CURRENT APP CAPTURE** (Unique) | 190,821 B | `DB460DC022C1...` | Fresh capture of Step 2 Best Match (10T Tipper) |
| 9 | `02_Customer/vehicle_selection_5_5t_under_capacity.png`| **CURRENT APP CAPTURE** (Unique) | 208,896 B | `8A87EE642F05...` | Fresh capture of Step 2 Disabled (2T Tata Ace) |
| 10 | `02_Customer/booking_confirmation.png` | **CURRENT APP CAPTURE** (Unique) | 242,583 B | `254EC70FCD9F...` | Fresh capture of Step 3 Booking #BM-8492 |
| 11 | `02_Customer/booking_confirmation_bottom.png` | **CURRENT APP CAPTURE** (Unique) | 232,687 B | `5FB035B980C5...` | Fresh capture of Step 3 Payment options & CTA |
| 12 | `02_Customer/live_tracking.png` | **CURRENT APP CAPTURE** (Unique) | 191,414 B | `851BACCDABC9...` | Fresh capture of Live Tracking radar & ETA |
| 13 | `02_Customer/customer_bookings_active.png` | **CURRENT APP CAPTURE** (Unique) | 194,644 B | `82122DD99AF9...` | Fresh capture of Bookings tab |
| 14 | `02_Customer/customer_alerts.png` | **CURRENT APP CAPTURE** (Unique) | 194,436 B | `BC30B3EDE250...` | Fresh capture of Alerts notification center |
| 15 | `02_Customer/customer_profile.png` | **CURRENT APP CAPTURE** (Unique) | 180,514 B | `0370C7A35D6C...` | Fresh capture of clean Customer Profile |
| 16 | `03_Driver/driver_dashboard_duty_on.png` | **CURRENT APP CAPTURE** (Unique) | 97,057 B | `0375B708BEB8...` | Fresh capture of Driver Dashboard (Murugan K., ON DUTY)|
| 17 | `03_Driver/driver_dashboard_duty_off.png` | **CURRENT APP CAPTURE** (Unique) | 272,436 B | `F1722E2BD48C...` | Fresh capture of Driver Dashboard state |
| 18 | `05_Common_Settings/language_selection.png` | **CURRENT APP CAPTURE** (Unique) | 169,797 B | `1B58FFE36E43...` | Fresh capture of Language selection sheet |
| 19 | `05_Common_Settings/logout_confirmation_dialog.png`| **CURRENT APP CAPTURE** (Unique) | 129,202 B | `CFA141A9A277...` | Fresh capture of Customer logout modal |
| 20 | `06_Light_Theme/light_customer_home.png` | **ORGANIZED COPY** | 190,954 B | `83A8E9CD964F...` | Duplicate of #4 |
| 21 | `06_Light_Theme/light_material_selection.png` | **ORGANIZED COPY** | 158,737 B | `412033DB9088...` | Duplicate of #6 |
| 22 | `06_Light_Theme/light_vehicle_selection.png` | **ORGANIZED COPY** | 190,821 B | `DB460DC022C1...` | Duplicate of #8 |
| 23 | `06_Light_Theme/light_booking_confirmation.png` | **ORGANIZED COPY** | 242,583 B | `254EC70FCD9F...` | Duplicate of #10 |
| 24 | `06_Light_Theme/light_live_tracking.png` | **ORGANIZED COPY** | 191,414 B | `851BACCDABC9...` | Duplicate of #12 |
| 25 | `06_Light_Theme/light_customer_bookings.png` | **ORGANIZED COPY** | 194,644 B | `82122DD99AF9...` | Duplicate of #13 |
| 26 | `06_Light_Theme/light_customer_profile.png` | **ORGANIZED COPY** | 180,514 B | `0370C7A35D6C...` | Duplicate of #15 |
| 27 | `06_Light_Theme/light_driver_dashboard.png` | **ORGANIZED COPY** | 97,057 B | `0375B708BEB8...` | Duplicate of #16 |
| 28 | `07_Dark_Theme/dark_customer_profile.png` | **CURRENT APP CAPTURE** (Unique) | 180,721 B | `8CF772154B25...` | Fresh capture of Customer Profile in Dark Theme |
| 29 | `07_Dark_Theme/dark_live_tracking.png` | **CURRENT APP CAPTURE** (Unique) | 191,243 B | `D55169A38201...` | Fresh capture of Live Tracking in Dark Theme |
| 30 | `08_Tamil_Language/tamil_customer_home.png` | **CURRENT APP CAPTURE** (Unique) | 243,973 B | `A8F3553E9A63...` | Fresh capture of Customer Home in Tamil |
| 31 | `09_English_Language/english_customer_home.png` | **ORGANIZED COPY** | 190,954 B | `83A8E9CD964F...` | Duplicate of #4 |
| 32 | `09_English_Language/english_otp_verification.png`| **ORGANIZED COPY** | 96,295 B | `AEEC41E8C841...` | Duplicate of #2 |
| 33 | `09_English_Language/english_material_quantity.png`| **ORGANIZED COPY** | 158,737 B | `412033DB9088...` | Duplicate of #6 |
| 34 | `09_English_Language/english_booking_confirmation.png`| **ORGANIZED COPY** | 242,583 B | `254EC70FCD9F...` | Duplicate of #10 |
| 35 | `09_English_Language/english_live_tracking.png` | **ORGANIZED COPY** | 191,414 B | `851BACCDABC9...` | Duplicate of #12 |
| 36 | `09_English_Language/english_customer_bookings.png`| **ORGANIZED COPY** | 194,644 B | `82122DD99AF9...` | Duplicate of #13 |
| 37 | `09_English_Language/english_customer_profile.png`| **ORGANIZED COPY** | 180,514 B | `0370C7A35D6C...` | Duplicate of #15 |
| 38 | `09_English_Language/english_driver_dashboard.png`| **ORGANIZED COPY** | 97,057 B | `0375B708BEB8...` | Duplicate of #16 |
| 39 | `10_Interaction_States/state_best_match_selected.png`| **ORGANIZED COPY** | 190,821 B | `DB460DC022C1...` | Duplicate of #8 |
| 40 | `10_Interaction_States/state_under_capacity_disabled.png`| **ORGANIZED COPY** | 208,896 B | `8A87EE642F05...` | Duplicate of #9 |
| 41 | `10_Interaction_States/state_quantity_stepper.png`| **ORGANIZED COPY** | 190,678 B | `8EAB8B406107...` | Duplicate of #7 |
| 42 | `10_Interaction_States/state_role_switcher.png` | **ORGANIZED COPY** | 190,041 B | `F026521ED1AB...` | Duplicate of #1 |
| 43 | `10_Interaction_States/state_language_selection.png`| **ORGANIZED COPY** | 169,797 B | `1B58FFE36E43...` | Duplicate of #18 |
| 44 | `10_Interaction_States/state_logout_modal.png` | **ORGANIZED COPY** | 129,202 B | `CFA141A9A277...` | Duplicate of #19 |

---

## 3. Audit Trail of Purged Files (23 Total)

All 23 files listed below were confirmed to have identical SHA256 checksums to files in `audit_evidence_phase2/` and were **permanently removed** from `Client_Review/` to preserve evidence integrity.

### Table 2: Purged Files Previously Reused from Audit Evidence

| # | Purged Item Name | Matched Source in `audit_evidence_phase2/` | SHA256 Checksum | Removal Action |
|:---:|:---|:---|:---:|:---:|
| 1 | `[PURGED] driver_profile.png` (in 03_Driver) | `06_driver_profile.png` | `11608682F929...` | **DELETED** from Client_Review |
| 2 | `[PURGED] driver_logout_confirmation.png` (in 03_Driver) | `07_driver_logout_dialog.png` | `4859EC133129...` | **DELETED** from Client_Review |
| 3 | `[PURGED] admin_dashboard.png` (in 04_Admin) | `08_admin_dashboard.png` | `4F5CE98357FE...` | **DELETED** from Client_Review |
| 4 | `[PURGED] admin_verifications_queue.png` (in 04_Admin) | `09_admin_verifications.png` | `C7221A37BCE4...` | **DELETED** from Client_Review |
| 5 | `[PURGED] admin_fleet_pending_kyc_locked.png` (in 04_Admin) | `10_fleet_before_verification.png` | `C56D7A5886F4...` | **DELETED** from Client_Review |
| 6 | `[PURGED] admin_verifications_approved.png` (in 04_Admin) | `11_verifications_after_approve.png` | `1B16F3EBCDE0...` | **DELETED** from Client_Review |
| 7 | `[PURGED] admin_fleet_approved_online.png` (in 04_Admin) | `12_fleet_after_approve.png` | `1EB2ED2F9E58...` | **DELETED** from Client_Review |
| 8 | `[PURGED] admin_dashboard_metrics_updated.png` (in 04_Admin) | `13_admin_dashboard_after_approve.png` | `88A83BC4688F...` | **DELETED** from Client_Review |
| 9 | `[PURGED] light_driver_profile.png` (in 06_Light_Theme) | `06_driver_profile.png` | `11608682F929...` | **DELETED** from Client_Review |
| 10 | `[PURGED] light_admin_dashboard.png` (in 06_Light_Theme) | `08_admin_dashboard.png` | `4F5CE98357FE...` | **DELETED** from Client_Review |
| 11 | `[PURGED] light_admin_verifications.png` (in 06_Light_Theme) | `09_admin_verifications.png` | `C7221A37BCE4...` | **DELETED** from Client_Review |
| 12 | `[PURGED] light_admin_fleet.png` (in 06_Light_Theme) | `10_fleet_before_verification.png` | `C56D7A5886F4...` | **DELETED** from Client_Review |
| 13 | `[PURGED] dark_material_quantity_timber_5_5t.png` (in 07_Dark_Theme) | `28_timber_5_5T_dark.png` | `21FFFC13F1DF...` | **DELETED** from Client_Review |
| 14 | `[PURGED] dark_vehicle_selection.png` (in 07_Dark_Theme) | `29_vehicle_selection_dark.png` | `0BD7C73A66EE...` | **DELETED** from Client_Review |
| 15 | `[PURGED] dark_booking_confirmation.png` (in 07_Dark_Theme) | `30_booking_confirmation_dark.png` | `FBFEE8C5FEF6...` | **DELETED** from Client_Review |
| 16 | `[PURGED] tamil_material_selection.png` (in 08_Tamil_Language) | `34_tamil_materials.png` | `4920E3F30C66...` | **DELETED** from Client_Review |
| 17 | `[PURGED] tamil_live_tracking.png` (in 08_Tamil_Language) | `33_tamil_tracking.png` | `549E347209DF...` | **DELETED** from Client_Review |
| 18 | `[PURGED] tamil_customer_profile.png` (in 08_Tamil_Language) | `35_tamil_customer_profile.png` | `5614917B9426...` | **DELETED** from Client_Review |
| 19 | `[PURGED] english_driver_profile.png` (in 09_English_Language) | `06_driver_profile.png` | `11608682F929...` | **DELETED** from Client_Review |
| 20 | `[PURGED] english_admin_dashboard.png` (in 09_English_Language) | `08_admin_dashboard.png` | `4F5CE98357FE...` | **DELETED** from Client_Review |
| 21 | `[PURGED] state_verification_queue.png` (in 10_Interaction_States) | `09_admin_verifications.png` | `C7221A37BCE4...` | **DELETED** from Client_Review |
| 22 | `[PURGED] state_pending_kyc_locked.png` (in 10_Interaction_States) | `10_fleet_before_verification.png` | `C56D7A5886F4...` | **DELETED** from Client_Review |
| 23 | `[PURGED] state_approved_kyc_online.png` (in 10_Interaction_States) | `12_fleet_after_approve.png` | `1EB2ED2F9E58...` | **DELETED** from Client_Review |

*(Note: Original files in `audit_evidence_phase2/` were strictly preserved as internal audit history and were NOT deleted).*

---

## 4. Screens Marked NOT CAPTURED (Honest Disclosure)

In compliance with Rule 6 ("Do not claim more than verified") and Rule 7 ("Do not alter authentication merely to obtain a screenshot"):

| Screen Name | Target Role | Reason Not Captured in Current Pass | Status |
|:---|:---:|:---|:---:|
| **Driver Profile & Document Compliance** | Driver | Screen tab unreachable via automated virtio touch input on emulator without source code routing override. | **NOT CAPTURED** |
| **Driver Trip History** | Driver | Screen tab unreachable via automated virtio touch input on emulator without source code routing override. | **NOT CAPTURED** |
| **Admin Operations Dashboard** | Admin | Admin role login unreachable via automated virtio touch input on emulator without source code routing override. | **NOT CAPTURED** |
| **Admin Verifications Queue** | Admin | Admin sub-tab unreachable without Admin role access. | **NOT CAPTURED** |
| **Admin Fleet Management (Pre/Post KYC)** | Admin | Admin sub-tab unreachable without Admin role access. | **NOT CAPTURED** |
| **Dark Theme Booking Confirmation** | Customer | Dark theme mode toggling was verified for Profile and Live Tracking; checkout sequence was not recaptured in dark mode. | **NOT CAPTURED** |
| **Dark Theme Vehicle Selection** | Customer | Dark theme mode toggling was verified for Profile and Live Tracking; vehicle selection was not recaptured in dark mode. | **NOT CAPTURED** |
| **Tamil Material Selection & Live Tracking** | Customer | Tamil mode was verified for Customer Home; secondary screens were not recaptured in Tamil. | **NOT CAPTURED** |

---

## 5. Recalculated Metric Summary

```
Total PNG files currently in Client_Review:       44
Unique fresh screenshots:                        21
Organized gallery duplicates:                    23
Old / previous screenshots removed:              23
Screenshots retained from previous evidence:      0
Verified zero hash collision with audit_evidence: PASS
```
