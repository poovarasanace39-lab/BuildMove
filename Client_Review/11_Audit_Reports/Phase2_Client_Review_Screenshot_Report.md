# BuildMove — Client Review Screenshot Audit Report
**Phase 2 Baseline Visual Evidence Certification (Integrity Audited)**

- **Date of Capture / Verification:** October 2026
- **Device Target:** Android Emulator `emulator-5554` (Android 14 / API 34)
- **Screen Resolution:** 1080 x 2400 pixels
- **APK Target:** `build/app/outputs/flutter-apk/app-debug.apk`
- **Total Image Artifacts in Client_Review:** **44 PNG files**
- **Unique Fresh Screenshots:** **21 unique captures**
- **Organized Gallery Copies:** **23 duplicate copies**
- **Screenshots Removed (Audit Overlap):** **23 files**
- **Screenshots Retained from Old Evidence:** **0 files**

---

## 1. Breakdown by Directory Category

| Directory | Unique Fresh Captures | Organized Gallery Copies | Total Files | Scope Covered |
|:---|:---:|:---:|:---:|:---|
| `01_Login_Authentication/` | 2 | 1 | 3 | Phone login, OTP verification, demo persona selector |
| `02_Customer/` | 12 | 0 | 12 | Full customer journey: catalog, 5.5T sizing, fitment, review, tracking, profile |
| `03_Driver/` | 2 | 0 | 2 | Driver dashboard (Murugan K., Duty ON and Duty OFF) |
| `04_Admin/` | 0 | 0 | 0 | Marked NOT CAPTURED (unreachable without modifying code) |
| `05_Common_Settings/` | 2 | 0 | 2 | Multi-language picker, session logout dialog |
| `06_Light_Theme/` | 0 | 8 | 8 | Curated Light Theme gallery |
| `07_Dark_Theme/` | 2 | 0 | 2 | Verified Dark Theme captures (Customer Profile, Live Tracking) |
| `08_Tamil_Language/` | 1 | 0 | 1 | Verified Tamil localization (Customer Home) |
| `09_English_Language/` | 0 | 8 | 8 | Curated English reference gallery |
| `10_Interaction_States/` | 0 | 6 | 6 | Micro-states: best-match, disabled capacity, stepper, modals |
| **Totals** | **21** | **23** | **44** | **100% Verified Android 14 Execution** |

---

## 2. Inventory of Unique Fresh Screenshots (21 Total)

### Authentication (2)
1. `01_Login_Authentication/customer_phone_login.png`: Clean phone login screen with persona options.
2. `01_Login_Authentication/otp_verification.png`: 6-digit OTP verification screen with dev hint banner.

### Customer Journey (12)
3. `02_Customer/customer_home_light.png`: Customer home with Ramesh Sundaram greeting and location inputs.
4. `02_Customer/customer_home_materials_scrolled.png`: Scrolled catalog displaying Timber & Plywood.
5. `02_Customer/material_quantity_timber.png`: Step 1 Material selection for Timber & Plywood.
6. `02_Customer/material_quantity_timber_5_5t.png`: Step 1 Sizing configured to 5.5 Metric Tons.
7. `02_Customer/vehicle_selection_5_5t_best_match.png`: Step 2 showing 6-Wheeler Tipper (10T) as "Best match".
8. `02_Customer/vehicle_selection_5_5t_under_capacity.png`: Step 2 showing 2T Tata Ace disabled as "Under capacity".
9. `02_Customer/booking_confirmation.png`: Step 3 Booking receipt (#BM-8492, ₹1,850, Murugan K., TN-02-AL-8921).
10. `02_Customer/booking_confirmation_bottom.png`: Step 3 Payment options (Cash, UPI, Credit) & sticky CTA.
11. `02_Customer/live_tracking.png`: Real-time tracking screen with simulated radar and ETA banner.
12. `02_Customer/customer_bookings_active.png`: Active bookings list showing haulage order card.
13. `02_Customer/customer_alerts.png`: In-app notification center showing dispatch updates.
14. `02_Customer/customer_profile.png`: Clean customer profile showing GST details and zero driver leak.

### Driver Console (2)
15. `03_Driver/driver_dashboard_duty_on.png`: Driver dashboard with Murugan K., ON DUTY switch, and active load.
16. `03_Driver/driver_dashboard_duty_off.png`: Driver dashboard with duty paused.

### Common Settings (2)
17. `05_Common_Settings/language_selection.png`: Language bottom sheet (English vs Tamil).
18. `05_Common_Settings/logout_confirmation_dialog.png`: Account logout confirmation modal.

### Dark Theme Captures (2)
19. `07_Dark_Theme/dark_customer_profile.png`: Customer profile in Dark Theme.
20. `07_Dark_Theme/dark_live_tracking.png`: Live tracking in Dark Theme.

### Tamil Language Captures (1)
21. `08_Tamil_Language/tamil_customer_home.png`: Customer home rendered in Tamil (முகப்பு).

---

## 3. Cryptographic Verification & Deduplication
- Cryptographic hash algorithm: SHA256.
- All 23 files previously copied from `audit_evidence_phase2/` were removed.
- SHA256 comparison confirms **0 hash collisions** between active `Client_Review/` files and `audit_evidence_phase2/`.
- Complete file-by-file provenance table is recorded in [`Screenshot_Provenance_Report.md`](file:///c:/Users/sithe/Documents/App%20development/flutter_application_1/Client_Review/11_Audit_Reports/Screenshot_Provenance_Report.md).
