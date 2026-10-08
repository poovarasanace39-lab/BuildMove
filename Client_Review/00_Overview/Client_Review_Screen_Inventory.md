# BuildMove — Screen Inventory & Verification Matrix
**Phase 2 Baseline Screen Audit (Fresh Captures Only)**

This document catalogues all screens and interaction states in BuildMove, clearly identifying those captured freshly from the running application on Android emulator (`emulator-5554`, Android 14 / API 34) and those marked NOT CAPTURED in this pass.

---

## 1. Authentication & Onboarding

| Screen Name | Role | Route / Path | Theme | Language | Interaction State | Screenshot Filename | Status |
|:---|:---:|:---:|:---:|:---:|:---|:---|:---:|
| Phone Login Screen | Any | `/login` | Light | English | Initial clean phone input with role selector chips | `01_Login_Authentication/customer_phone_login.png` | **CURRENT CAPTURE** |
| OTP Verification Screen | Any | `/otp` | Light | English | 6-digit PIN input with dev hint banner | `01_Login_Authentication/otp_verification.png` | **CURRENT CAPTURE** |
| Quick Persona Selector | Any | Modal | Light | English | Persona selection chips on login screen | `01_Login_Authentication/persona_selector_dialog.png` | **ORGANIZED COPY** |

---

## 2. Customer Experience

| Screen Name | Role | Route / Path | Theme | Language | Interaction State | Screenshot Filename | Status |
|:---|:---:|:---:|:---:|:---:|:---|:---|:---:|
| Customer Home | Customer | `/home` | Light | English | Initial hero view with Ramesh Sundaram identity | `02_Customer/customer_home_light.png` | **CURRENT CAPTURE** |
| Customer Home (Materials) | Customer | `/home` | Light | English | Scrolled view showing Timber & Plywood (no Centering) | `02_Customer/customer_home_materials_scrolled.png` | **CURRENT CAPTURE** |
| Material & Quantity (Initial) | Customer | `/booking/step1` | Light | English | Step 1 with Timber & Plywood selected | `02_Customer/material_quantity_timber.png` | **CURRENT CAPTURE** |
| Material & Quantity (5.5T) | Customer | `/booking/step1` | Light | English | Step 1 configured to 5.5 Metric Tons | `02_Customer/material_quantity_timber_5_5t.png` | **CURRENT CAPTURE** |
| Available Vehicles (Best Match)| Customer | `/booking/step2` | Light | English | 6-Wheeler Tipper (10T) tagged "Best match" | `02_Customer/vehicle_selection_5_5t_best_match.png` | **CURRENT CAPTURE** |
| Available Vehicles (Disabled) | Customer | `/booking/step2` | Light | English | Tata Ace Mega (2T) disabled as "Under capacity" | `02_Customer/vehicle_selection_5_5t_under_capacity.png` | **CURRENT CAPTURE** |
| Booking Confirmation (Top) | Customer | `/booking/step3` | Light | English | Verified Trip #BM-8492, ₹1,850 fare, Murugan K. | `02_Customer/booking_confirmation.png` | **CURRENT CAPTURE** |
| Booking Confirmation (Bottom) | Customer | `/booking/step3` | Light | English | Settlement options & sticky Confirm Booking CTA | `02_Customer/booking_confirmation_bottom.png` | **CURRENT CAPTURE** |
| Live Tracking | Customer | `/tracking` | Light | English | Live telemetry radar, driver card, ETA banner | `02_Customer/live_tracking.png` | **CURRENT CAPTURE** |
| Customer Active Bookings | Customer | `/bookings` | Light | English | Active haulage order card with status badge | `02_Customer/customer_bookings_active.png` | **CURRENT CAPTURE** |
| Customer Notification Alerts | Customer | `/alerts` | Light | English | Dispatch updates and weigh-slip notifications | `02_Customer/customer_alerts.png` | **CURRENT CAPTURE** |
| Customer Profile | Customer | `/profile` | Light | English | Clean user profile; zero vehicle/driver leak | `02_Customer/customer_profile.png` | **CURRENT CAPTURE** |

---

## 3. Driver Experience

| Screen Name | Role | Route / Path | Theme | Language | Interaction State | Screenshot Filename | Status |
|:---|:---:|:---:|:---:|:---:|:---|:---|:---:|
| Driver Dashboard (Duty ON) | Driver | `/driver` | Light | English | Murugan K., ON DUTY switch, assigned Job #BM-8492 | `03_Driver/driver_dashboard_duty_on.png` | **CURRENT CAPTURE** |
| Driver Dashboard (Duty OFF) | Driver | `/driver` | Light | English | Driver dashboard with duty paused | `03_Driver/driver_dashboard_duty_off.png` | **CURRENT CAPTURE** |
| Driver Profile & Compliance | Driver | Tab 2 | Light | English | Registered vehicle TN-02-AL-8921, RTO docs | None | **NOT CAPTURED** |
| Driver Logout Confirmation | Driver | Modal | Light | English | Logout safety prompt with warning dialog | None | **NOT CAPTURED** |
| Driver Trip History | Driver | Tab 1 | Light | English | Completed trips ledger | None | **NOT CAPTURED** |

---

## 4. Admin Operations & Control Tower

| Screen Name | Role | Route / Path | Theme | Language | Interaction State | Screenshot Filename | Status |
|:---|:---:|:---:|:---:|:---:|:---|:---|:---:|
| Admin Operations Dashboard | Admin | `/admin` | Light | English | Priya Sharma console, live dispatch & platform KPIs | None | **NOT CAPTURED** |
| Admin Verifications Queue | Admin | Tab 1 | Light | English | Pending KYC documents | None | **NOT CAPTURED** |
| Fleet Pre-Approval (Locked) | Admin | Tab 2 | Light | English | Vehicle locked with "KYC Required" | None | **NOT CAPTURED** |
| Verifications After Approval | Admin | Tab 1 | Light | English | Queue after approving DOC-9021 | None | **NOT CAPTURED** |
| Fleet Post-Approval (Online) | Admin | Tab 2 | Light | English | Unlocked to "Available Online" | None | **NOT CAPTURED** |
| Admin Dashboard Post-Approve | Admin | Tab 0 | Light | English | Decremented metrics | None | **NOT CAPTURED** |

---

## 5. Common Settings & Modals

| Screen Name | Role | Route / Path | Theme | Language | Interaction State | Screenshot Filename | Status |
|:---|:---:|:---:|:---:|:---:|:---|:---|:---:|
| Language Selection Sheet | All | Modal | Light | Multi | English vs Tamil (தமிழ்) switcher radio group | `05_Common_Settings/language_selection.png` | **CURRENT CAPTURE** |
| Logout Confirmation Modal | All | Modal | Light | English | Standard account sign-out confirmation dialog | `05_Common_Settings/logout_confirmation_dialog.png` | **CURRENT CAPTURE** |

---

## 6. Theme & Language Variations

| Category | Screen | Theme / Lang | Screenshot Filename | Status |
|:---|:---|:---:|:---|:---:|
| **Dark Theme** | Customer Profile | Dark / EN | `07_Dark_Theme/dark_customer_profile.png` | **CURRENT CAPTURE** |
| **Dark Theme** | Live Telemetry Tracking | Dark / EN | `07_Dark_Theme/dark_live_tracking.png` | **CURRENT CAPTURE** |
| **Dark Theme** | Material & Quantity | Dark / EN | None | **NOT CAPTURED** |
| **Dark Theme** | Vehicle Selection | Dark / EN | None | **NOT CAPTURED** |
| **Dark Theme** | Booking Confirmation | Dark / EN | None | **NOT CAPTURED** |
| **Tamil Language** | Customer Home (முகப்பு) | Light / TA | `08_Tamil_Language/tamil_customer_home.png` | **CURRENT CAPTURE** |
| **Tamil Language** | Material Selection (பொருட்கள்) | Light / TA | None | **NOT CAPTURED** |
| **Tamil Language** | Live Tracking (நேரடி கண்காணிப்பு) | Light / TA | None | **NOT CAPTURED** |
| **Tamil Language** | Customer Profile (சுயவிவரம்) | Light / TA | None | **NOT CAPTURED** |
