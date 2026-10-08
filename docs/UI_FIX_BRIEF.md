# BuildMove UI Fix Brief

**Antigravity guide and agent-ready task list**

_For any AI coding agent (Google Antigravity, Claude Code, Cursor, Copilot and others) • Baseline: Phase 2 Step 1 build • October 2026_

## 1. How to use this document

This is a self-contained brief. A human or an AI agent can read it top to bottom and make the UI changes without any other context. It has three jobs: explain the tool (Antigravity), explain the app (BuildMove) and its current state, and give a numbered list of UI tasks with testable acceptance criteria.

- Save this file in the project as docs/UI_FIX_BRIEF.md (a Markdown copy is provided). Agents read Markdown more reliably than Word files.
- Give an agent ONE task at a time (for example “Do T02”). Do not ask for the whole list in one conversation.
- Every task ends with acceptance criteria. A task is not done until each criterion is shown to be true with evidence (a test result or a correctly named screenshot).
- Section 9 contains copy-paste prompts, a rule file and a workflow file for Antigravity.

> **Note:** Scope: this brief changes presentation, layout, wording and the data that feeds the UI. It must not change business logic, pricing rules, routing or the backend contract unless a task says so explicitly.

## 2. What Antigravity is

Google Antigravity is an agent-first IDE. Instead of only completing code as you type, it lets AI agents plan, write, run and verify software tasks across the code editor, the terminal and a built-in browser. A Manager view lets you run several agents in parallel, and agents report back with Artifacts (plans, screenshots, recordings) so you can check their work without reading raw logs.

| Concept | What it is | How to use it here |
|---|---|---|
| Editor View | A familiar code editor with tab completion, inline commands and an agent side panel. | Small manual edits and reading diffs. |
| Agent Manager | A central dashboard to start, monitor and review many agent conversations at once. | Run one agent per task. Review artifacts before approving. |
| Agent | A multi-step reasoning system that reads your code, uses tools (editor, terminal, browser) and communicates through tasks and artifacts. | The worker that implements each task. |
| Artifacts | Tangible outputs such as task lists, implementation plans, screenshots, recordings and walkthroughs. You can comment on them like a document and the agent folds your feedback in. | Require a plan before coding and before/after screenshots after coding. |
| Browser sub-agent | An agent that can drive the built-in browser to run and check an app. | Useful if you run the Flutter web build (flutter run -d chrome). For the Android emulator, capture with adb instead. |
| Planning vs Fast mode | Planning: the agent thinks, writes a step-by-step plan and produces artifacts first. Fast: it executes immediately. | Use Planning for every UI task. Fast only for one-line text fixes. |
| Review policy | How much the agent asks before acting: agent-driven (most autonomy), agent-assisted (balanced, recommended) or custom. | Use agent-assisted. |
| Rules | Always-on, system-level instructions that guide code generation. Global rules live in ~/.gemini/GEMINI.md; workspace rules live in .agent/rules/. | Put the hard constraints from Section 5 in a workspace rule file. |
| Workflows | Saved prompts that you trigger on demand with a slash command. Workspace workflows live in .agent/workflows/. | A /ui-fix workflow runs the same safe procedure for every task. |
| MCP | A standard way to connect external tools and data sources to the agent. | Optional. Not required for this brief. |

> **Note:** Antigravity is changing quickly. Folder names (.agent), setting names and the default model may differ in your installed version. Confirm against the official docs at antigravity.google/docs. If a path does not exist, create it or place the same content wherever your version loads rules from.

### Using this brief with other agents

Nothing in this document depends on Antigravity. In Claude Code, Cursor or Copilot, put the file in the repo and start your prompt with: “Read docs/UI_FIX_BRIEF.md, then do task T02 only.” The rules in Section 5 and the evidence protocol in Section 8 apply to every tool.

## 3. Recommended Antigravity setup

1. Open the BuildMove Flutter project as the workspace.
2. Create docs/UI_FIX_BRIEF.md and paste this brief into it.
3. Create .agent/rules/buildmove-ui-rules.md using the content in Section 9.2.
4. Create .agent/workflows/ui-fix.md using the content in Section 9.3. You can then type /ui-fix T02 in the agent panel.
5. Set the mode to Planning and the review policy to agent-assisted.
6. Start the Android emulator at 1080 x 2400 (Android 14, API 34) so screenshots match the baseline.
7. Run one agent per task. Run two agents in parallel only when their tasks touch different files.
8. After each task, open the Walkthrough artifact, check every acceptance criterion against the screenshots, then approve.

## 4. The app and its current state

### 4.1 What BuildMove is

BuildMove is a Flutter mobile app for booking construction-material haulage in Tamil Nadu. It has three roles inside one app. English and Tamil are supported, with light and dark themes. State is managed with Riverpod. Login uses a mobile number and a 6-digit OTP, with a development shortcut called Quick Demo Role Login.

| Role | What they do |
|---|---|
| Customer / Site Engineer | Home, then a 3-step booking wizard (Material & Quantity, Vehicle, Review & Confirm), live tracking, Bookings, Alerts and Profile. Demo user: Ramesh Sundaram, BuildCon Infra Pvt Ltd. |
| Driver / Fleet Owner | Dashboard with duty toggle, earnings, rating and the current assigned load, plus Trips and Profile. Demo user: Murugan K., 6-Wheeler Tipper (10T), plate TN-02-AL-8921. |
| Operations Admin | Control-tower dashboard, Verifications queue (approve or reject driver documents) and Fleet (toggle vehicles online). Demo user: Priya Sharma. |

Paths named in the team’s own reports (verify them in the repo before editing): lib/core/constants/app_constants.dart, lib/features/auth/providers/auth_provider.dart, lib/features/booking/ (including screens/vehicle_selection_screen.dart), lib/features/driver/, lib/features/admin/.

### 4.2 What has already been fixed (do not redo)

- Customer name and company are consistent (Ramesh, BuildCon Infra).
- Material is “Timber & Plywood”, not “Centering”, and no cement-bag text appears for timber.
- Home and wizard catalogs list the same 8 materials.
- Fare lines add up (1,200 + 450 + 200 = 1,850) and plate/vehicle are consistent on review, tracking and driver screens.
- Customer profile no longer leaks driver data. Logout confirmation dialog exists.

### 4.3 What is still wrong

Visual design, layout and UX polish were essentially unchanged (key screens differ from the original by 0.0 to 0.7 percent of pixels). There is also one new data bug: the driver dashboard says “5.0 Tons • Cement” while the booking is Timber & Plywood. Tasks T01 to T16 below fix these items.

## 5. Rules every agent must follow

1. One task per conversation. Do not fix things that are not in the task, even if you notice them. List them in the final report instead.
2. Do not change business logic, fare calculation, capacity rules, routing, authentication or API contracts. If a task seems to require it, stop and ask.
3. Single source of truth: any value shown on more than one screen (material, tonnage, vehicle, plate, fare, booking ID, driver) must be read from the same booking or user record. Never hard-code a display string that duplicates data.
4. Use design tokens from Section 6. Do not introduce new hex colors, radii or font sizes inline.
5. Every tappable element is at least 48 x 48 dp. Text is never below 12 sp. Body text meets 4.5:1 contrast in both light and dark themes.
6. Every new string goes through localization with an English and a Tamil entry. Layouts must survive Tamil text (longer, taller glyphs): allow two lines instead of truncating critical information.
7. Do not remove or hide the demo/role-switch tools by deleting code. Put them behind a debug or build flag so they can be turned off for client builds.
8. Run flutter analyze (must report no issues) and flutter test (the baseline is 48 of 48 passing) before saying a task is done. Add or update a test when you change data flow.
9. Provide evidence as described in Section 8. Never claim a screen was verified unless you captured it and checked that the image shows what its filename says.
10. Never invent data, metrics or guarantees in the UI. If wording makes a promise (for example about dispatch), mark it for product-owner approval.

## 6. Design tokens and component rules

Values marked “observed” were sampled from the current screenshots. Confirm them against the theme file in the repo and use the existing token names if they exist.

| Token | Value | Rule |
|---|---|---|
| Primary (orange) | #CC4900 (observed) | Primary buttons and active states. White text on it is 4.65:1, which passes. On a dark background it is only 3.71:1, so do not use it for text or icons in dark mode. |
| Primary on dark | #F97316 (6.15:1) or #FF8A50 (7.39:1) | Use for orange text, icons and outlines in dark mode. Keep #CC4900 only as a filled button with white label. |
| Navy | #0F172A (observed) | Neutral text and dark chips. Do NOT use for selected states (see below). |
| Page background | #F7FAFE (observed) | Light theme page. Cards are #FFFFFF. |
| Selected tint | #FCE3D7 (observed) | Background of any selected card, chip or segment. |
| Dark background | #131B2A (observed) | Dark theme page. |
| Success | #E8F5E9 and #E6F8F0 are both in use | Merge into one success background token. Success text must be at least 4.5:1. |
| Warning banner | #FEF3C7 (observed) | Demo banner and warning chips. |
| Destructive | Red (for example #DC2626) | SOS, Logout, Reject, Cancel. Never the same color as primary. |
| Secondary text | #64748B is 4.55:1 on the page background | Passes narrowly. Use #475569 (7.24:1) for small text. |
| Spacing scale | 4, 8, 12, 16, 24 | No other spacing values. |
| Radius | Cards 16 dp, buttons 12 dp | One value per component type, everywhere. |
| Touch target | 48 x 48 dp | Includes toggles, steppers, chips and icon buttons. |

### Component rules

| Component | Rule |
|---|---|
| Selected state | One style for cards, chips and segmented controls: 2 dp orange border, #FCE3D7 fill and a check icon where appropriate. Navy fills are not used to show selection. |
| Buttons | Primary = filled orange. Secondary = outlined. Destructive = red. Positive (Approve) = green. Only one primary button per screen area. |
| Status chips | One color map used everywhere: Assigned = blue, Pending or Locating = amber, Delivered = green, Cancelled = red. |
| Icons | One outlined family with the same stroke weight. A vehicle icon keeps the same style and size when selected; only color may change. |
| Currency and IDs | Always ₹1,850 with a thousands separator. One order-ID format everywhere (for example BM-2026-083). |
| Wizard header | Back arrow, title and step indicator only. No theme, language or profile controls. |
| Empty, loading and error | Every list and form has a designed empty state, a skeleton or spinner state and an error state with a retry action. |

## 7. Task list

Priority: P0 = fix before the next client review. P1 = important polish. P2 = nice to have. Tasks marked “verify first” concern screens that were not visible in the latest screenshots, so check the real behavior before changing anything.

### T01 — Driver console shows the wrong material [P0]

- **Screens:** Driver Dashboard, Driver Trips, Admin dispatch card
- **Likely files:** lib/features/driver/, lib/features/booking/ (verify)
- **Observed problem:** The customer booking is Timber & Plywood, 5.0 tons, but the driver dashboard says “Load: 5.0 Tons • Cement”.

**Required change:**
- Make the driver load card, driver trips list and admin dispatch card read the material name from the same booking record the customer screens use.
- Remove any hard-coded “Cement” display string.

**Acceptance criteria:**
- [ ] The material string is identical on Review & Confirm, Live Tracking, Bookings, Driver Dashboard and Driver Trips for the same booking.
- [ ] A unit or widget test fails if the driver view shows a different material from the booking.
- [ ] Screenshots of customer review and driver dashboard side by side show the same material.

### T02 — Sticky Confirm bar on Review & Confirm [P0]

- **Screens:** Review & Confirm
- **Likely files:** lib/features/booking/ (verify)
- **Observed problem:** The Confirm Booking button only appears after scrolling past the whole page. “Edit Details” is a tiny low-contrast link.

**Required change:**
- Move the primary button into a persistent bottom bar showing the total, for example “Confirm · ₹1,850”. Respect the system navigation inset.
- Give the scroll content bottom padding at least as tall as the bar.
- Make “Edit Details” a visible secondary or text button of 48 dp height.

**Acceptance criteria:**
- [ ] The bar is visible without scrolling on 1080 x 2400 and on a small 360 x 640 viewport.
- [ ] The amount in the bar always equals the Total Fare on the page and updates if the settlement method changes the total.
- [ ] No content is hidden behind the bar at the end of the scroll.

### T03 — Vehicle list: make the capacity guard visible and provable [P0]

- **Screens:** Step 2 Available Vehicles
- **Likely files:** lib/features/booking/screens/vehicle_selection_screen.dart
- **Observed problem:** The team reports that under-capacity vehicles are disabled, but no screenshot shows the vehicle list at all. The header badge also used trade jargon in the original build.

**Required change:**
- Verify under-capacity vehicles cannot be selected for a 5.5 t load. Show a clear reason on the card, such as “Under capacity (max 2 T)”, with reduced opacity and no Select button.
- Make the header chip use the material’s display name, for example “For 5.5 Tons Timber & Plywood”.
- Explain “Best match” in one short line (for example “Fits 5.5 T in one trip”).
- Keep the price guarantee card reachable without scrolling past three vehicle cards, or collapse it.

**Acceptance criteria:**
- [ ] Screenshot vehicle_list_best_match.png shows the 6-Wheeler Tipper selected with the Best match badge.
- [ ] Screenshot vehicle_list_under_capacity.png shows the 2 T vehicle disabled with its reason.
- [ ] Tapping a disabled card does nothing and the Continue button cannot be enabled by it (test included).

### T04 — Declutter app headers [P0]

- **Screens:** Customer Home, all wizard steps, Live Tracking
- **Likely files:** shared app bar widgets (verify)
- **Observed problem:** Home shows theme toggle, language chip, bell and avatar plus an unexplained “TN Fleet” chip. The bell and the Alerts tab both show badges for the same thing. Wizard screens repeat theme, language and profile controls.

**Required change:**
- Move theme and language into Profile (a Settings section).
- Home header: logo, greeting and one notification entry point only. Keep either the bell or the Alerts tab badge, not both.
- Remove the “TN Fleet” chip or replace it with a labelled control that does something.
- Wizard and tracking headers: back arrow, title and step only.
- Remove or wire up the waveform glyphs next to LOADING POINT and UNLOADING SITE. If it is voice input, give it a clear icon and make it work; otherwise delete it.

**Acceptance criteria:**
- [ ] No theme, language or profile control appears on any wizard step or on Live Tracking.
- [ ] Only one unread-count indicator exists for alerts.
- [ ] Theme and language remain reachable from Profile and still work.

### T05 — Driver header must never hide the plate [P1]

- **Screens:** Driver Dashboard (English, Tamil)
- **Likely files:** lib/features/driver/
- **Observed problem:** The vehicle line truncates the plate (“TN-02-AL-89…”) and in Tamil the role chip collides with the name.

**Required change:**
- Use a layout with the name on one line, the vehicle model on a second line and the plate on its own line that never truncates.
- Drop the role chip or move it below the name.

**Acceptance criteria:**
- [ ] The full plate is visible in English and Tamil on a 360 dp wide screen.
- [ ] No overlap between name and role chip in either language.

### T06 — One selected-state style [P1]

- **Screens:** Material cards, unit toggle, quantity presets, settlement options, vehicle cards
- **Likely files:** shared theme and widgets
- **Observed problem:** Selected materials are orange, but the unit toggle and quantity presets use navy fills, so the app looks like it has two design systems.

**Required change:**
- Apply the selected-state rule from Section 6 to every selectable component.

**Acceptance criteria:**
- [ ] No navy fill is used to indicate selection anywhere.
- [ ] Selected components use the same border, tint and check treatment in light and dark themes.

### T07 — Quantity controls [P1]

- **Screens:** Step 1 Material & Quantity
- **Likely files:** lib/features/booking/
- **Observed problem:** The minus button is outlined and the plus button is filled, so decrement looks secondary. It uses a hyphen with spaces. BAGS (50kg) is offered for timber.

**Required change:**
- Style both stepper buttons equally and use a real minus sign (−).
- Let the user type a quantity by tapping the number.
- Offer only the units that make sense for the selected material (for example bags only for cement).
- Show a capacity hint such as “Fits one 6-wheeler (10 T)”.

**Acceptance criteria:**
- [ ] Both stepper buttons have the same visual weight and 48 dp targets.
- [ ] Selecting Timber & Plywood shows no bag unit.
- [ ] Typing 7.5 sets the value and updates the vehicle hint.

### T08 — Compact material grid [P1]

- **Screens:** Customer Home, Step 1
- **Likely files:** lib/features/booking/, lib/core/constants/app_constants.dart
- **Observed problem:** Eight tall icon-only cards push the quantity controls far below the fold. Icons share one color and look generic.

**Required change:**
- Make cards compact (about 88 dp tall) or use a 3-column grid.
- Use a photo or illustration thumbnail per material.
- After a material is selected, scroll the quantity section into view.

**Acceptance criteria:**
- [ ] After selecting a material, the quantity control is visible on screen without manual scrolling on 1080 x 2400.
- [ ] Every material has a distinct thumbnail.

### T09 — Review & Confirm content cleanup [P1]

- **Screens:** Review & Confirm
- **Likely files:** lib/features/booking/
- **Observed problem:** “VERIFIED TRIP #BM-8492” shows before anything is booked. The title appears twice. There is no step indicator. An unlabelled shield icon sits top-right. “Escrow Safe” sits above a Cash option. “100% Guaranteed Dispatch” is an unqualified promise.

**Required change:**
- Show “Draft” (or hide the ID) until the booking is confirmed.
- Keep one title. Add “Step 3 of 3” to match the previous steps.
- Label the shield or remove it.
- Show “Escrow Safe” only for payment methods that use escrow.
- Replace the guarantee text with a factual estimate, and flag the wording for product-owner approval.

**Acceptance criteria:**
- [ ] No “Verified” label appears before confirmation.
- [ ] The heading appears once and the step indicator reads 3 of 3.
- [ ] Escrow wording is absent when Cash after Unloading is selected.

### T10 — Live Tracking clarity [P1]

- **Screens:** Live Tracking (light, dark, Tamil)
- **Likely files:** lib/features/booking/ or tracking feature (verify)
- **Observed problem:** SOS has the same orange as primary actions. “2.4 km away” (top) and “2.4 km left” (bottom) are the same number with different meanings. The stepper says “Arriving” while the truck is mid-route. About 20 percent of the bottom sheet is empty.

**Required change:**
- Make SOS red, at least 48 dp, visually distinct from primary buttons.
- Show one distance chip with context (for example “2.4 km to site”).
- Drive the stepper from trip state so the stage matches the truck position, and keep the ETA consistent with it.
- Use the empty area for the pickup OTP and a link to the weigh-slip, or let the sheet expand.

**Acceptance criteria:**
- [ ] Only one distance indicator appears, and its label says what it measures.
- [ ] The active step matches the trip state in the data.
- [ ] SOS is red in light and dark themes.

### T11 — Login and OTP forms [P1]

- **Screens:** Login, OTP verification
- **Likely files:** lib/features/auth/
- **Observed problem:** The OTP banner says “tap Quick Demo Login below”, but nothing is below. Buttons look enabled while fields are empty. OTP is one plain text field.

**Required change:**
- Show the dev hint only in debug builds and fix its wording so it points to something that exists.
- Disable the primary button until the number has 10 digits (login) or 6 digits (OTP). Show inline validation and an error state for a wrong code.
- Use six separate OTP boxes with SMS auto-fill where the platform supports it.
- Show the phone number with an Edit link, and keep the resend timer.

**Acceptance criteria:**
- [ ] Buttons are visibly disabled until the input is valid.
- [ ] A wrong OTP shows an inline error, not just a toast.
- [ ] A release-style build shows no dev hint.

### T12 — Driver dashboard actions [P1]

- **Screens:** Driver Dashboard (duty on and off, light, dark, Tamil)
- **Likely files:** lib/features/driver/
- **Observed problem:** The map card is tall and pushes the action buttons under the bottom navigation. “Navigate to Pickup” and “Start Trip (Loaded)” look equally important. “Live Telemetry 10Hz” is developer text. The Tamil CTA label shrinks to roughly 8 dp.

**Required change:**
- Limit the map height (about one third of the screen) so the action area is visible without scrolling.
- Show one primary action at a time driven by trip state: Navigate to Pickup, then Arrived, then Start Trip. Keep Start Trip disabled until the driver has arrived.
- Remove the telemetry caption from release builds.
- Let CTA labels wrap to two lines rather than shrink below 14 sp.
- Make the duty toggle target 48 dp.

**Acceptance criteria:**
- [ ] The primary action is fully visible on 1080 x 2400 without scrolling.
- [ ] Only one primary-styled button exists at a time.
- [ ] Tamil CTA text is at least 14 sp.

### T13 — Bookings and Alerts (verify first) [P1]

- **Screens:** Customer Bookings (active and past), Alerts
- **Likely files:** lib/features/booking/ (verify)
- **Observed problem:** These screens were not visible in the latest screenshots. In the earlier build: two order-ID formats, fares without thousands separators, a Pickup OTP on delivered and cancelled orders, a fare on a cancelled order, OTPs shown before a driver exists, and no obvious way to open or track an order.

**Required change:**
- First capture the current screens and confirm which problems still exist.
- Use one order-ID format and the ₹1,850 formatter everywhere.
- Delivered orders show weigh-slip, invoice, rating and Reorder instead of OTP. Cancelled orders show a clear cancelled or no-charge state. Unmatched orders hide the OTP.
- Make cards tappable with a chevron and add a Track button on assigned orders.
- Add empty states for Bookings and Alerts.

**Acceptance criteria:**
- [ ] The same booking has the same ID format on Bookings, Review, Tracking and Driver screens.
- [ ] Delivered and cancelled cards show no pickup OTP.
- [ ] An empty list shows a message and a primary action.

### T14 — Admin console (verify first) [P1]

- **Screens:** Admin Dashboard, Verifications, Fleet
- **Likely files:** lib/features/admin/
- **Observed problem:** Admin screens were not included in the latest screenshots. In the earlier build the profile card wrapped the name to four lines, Approve used the brand orange, documents could not be previewed, and Toggle Off / Toggle On labels were ambiguous. The team’s report says a KYC gate was added; it has not been shown.

**Required change:**
- Make the admin profile a compact one-line header.
- Use green for Approve and red for Reject. Add a document preview, a confirmation on Approve, an undo option and a history of processed items. Show a count badge on the Verifications tab.
- Use a real switch (48 dp) for Fleet duty, and the “KYC Required” pill for vehicles awaiting review.
- Make KPI tiles tappable. Give Pending Match orders Assign and Call actions.

**Acceptance criteria:**
- [ ] The admin name never wraps beyond two lines.
- [ ] Approving DOC-9021 makes vehicle TN-05-BK-4921 available online and the Fleet screen shows it, with a screenshot before and after.
- [ ] The KPI counts agree with the lists they open.

### T15 — Profile and settings polish [P2]

- **Screens:** Customer Profile, Driver Profile
- **Likely files:** lib/features/profile/ or similar (verify)
- **Observed problem:** Row icons use five different colors. Logout looks like any other row. Row typography differs between customer and driver profiles.

**Required change:**
- Use one icon style and one accent color for rows.
- Style Logout as a destructive action and keep the confirmation dialog.
- Share one list-row widget between both profiles.
- On the driver profile, add Renew or Upload next to “PUC expiring in 30 days”.

**Acceptance criteria:**
- [ ] Both profiles use the same row component.
- [ ] Logout is visually distinct and still asks for confirmation.

### T16 — Dark mode and Tamil hardening [P2]

- **Screens:** All screens in dark mode and in Tamil
- **Likely files:** theme files and localization
- **Observed problem:** Orange text on the dark background measures 3.71:1, below the 4.5:1 target. Dark mode and Tamil are only captured on a few screens. Tamil has truncation and shrunken labels, and some English strings remain (for example “ROUTE MAP”, “~18 mins”).

**Required change:**
- Apply the dark-mode primary token from Section 6 to text and icons.
- Translate the remaining English strings and allow two-line labels.
- Capture the full booking journey and the driver and admin screens in dark and in Tamil.

**Acceptance criteria:**
- [ ] Every orange text or icon on dark backgrounds is at least 4.5:1.
- [ ] No Tamil label is truncated on a 360 dp wide screen.
- [ ] The required dark and Tamil captures in Section 8 exist and are genuinely dark or Tamil.

## 8. Evidence and screenshot protocol

The last screenshot package contained files whose names did not match what they showed. That undermines trust in real fixes. Follow this protocol so every claim can be checked.

### Rules

1. Capture on the Android emulator at 1080 x 2400 (Android 14, API 34). Use the same device for every image.
2. The filename must describe exactly what the image shows. After capturing, open each image and check it.
3. No duplicates. Do not copy one image into several folders under different names. If an image belongs in two galleries, list it in a manifest.md instead of copying.
4. Dark-mode files must be truly dark and Tamil files must show Tamil text. Check them visually.
5. Before delivering, run a duplicate check and fix anything it reports: find Client_Review -name "*.png" -exec sha256sum {} + | sort | uniq -w64 -d
6. Include before and after images for every UI task.
7. If a screen cannot be reached, write that in the final report with the reason. Do not substitute a different screen.

### How to reach screens that were previously reported as unreachable

- Admin: on the login screen use Quick Demo Role Login and choose “BuildMove Operations Admin” (Priya, 9999900000), or open the Switch Role sheet in any role. This path existed in the earlier build.
- Driver Trips and Profile: bottom-navigation taps can fail through the emulator input layer. Use adb shell input tap with coordinates from adb shell uiautomator dump, or write a Flutter integration test (flutter drive) that taps the tabs and calls takeScreenshot.
- Alternative: run the Flutter web build (flutter run -d chrome) and let the Antigravity browser sub-agent click through the screens and capture them.

### Required captures

| Filename | Must show |
|---|---|
| customer/vehicle_list_best_match.png | Step 2 list for 5.5 t Timber & Plywood; 6-Wheeler Tipper selected with Best match. |
| customer/vehicle_list_under_capacity.png | Step 2 list with the 2 T vehicle disabled and its reason visible. |
| customer/review_confirm_top.png and review_confirm_sticky_bar.png | Review screen top, and the sticky bar with total. |
| customer/bookings_active.png and bookings_past.png | The real Bookings tab, both sub-tabs. |
| customer/alerts.png | The real Alerts screen. |
| driver/dashboard_duty_on.png and dashboard_duty_off.png | Driver dashboard with the toggle in each state. |
| driver/trips_active.png, trips_past.png, profile.png, logout_dialog.png | The real driver Trips and Profile screens. |
| admin/dashboard.png, verifications_queue.png, verifications_reject.png, fleet_pre_kyc.png, fleet_post_kyc.png | Admin screens, including the vehicle before and after document approval. |
| common/role_switcher_sheet.png, language_sheet.png | The actual bottom sheets (not the login screen). |
| dark/ home, material, vehicle_list, review, tracking, bookings, driver_dashboard, admin_dashboard | True dark theme for the main journey and each role. |
| tamil/ material, vehicle_list, review, tracking, driver_dashboard | Tamil for the same screens. |

## 9. Ready-to-paste prompts and files

### 9.1 Master prompt for the Agent Manager

> **Note:** Replace T02 with the task ID. Use Planning mode.

```text
You are a senior Flutter engineer working on BuildMove.
Read docs/UI_FIX_BRIEF.md completely, then work on task T02 ONLY.

Step 1. Produce an Implementation Plan artifact: files you will change, risks,
        and the acceptance criteria you will verify. Wait for my approval.
Step 2. Implement with the smallest possible diff. Do not touch business logic,
        pricing, routing or screens outside the task.
Step 3. Run flutter analyze and flutter test. Both must pass (baseline 48/48).
Step 4. Capture before and after screenshots on the 1080x2400 Android emulator
        using the exact filenames in Section 8. Open every image and confirm it
        shows what its filename says. Run the duplicate-hash check.
Step 5. Produce a Walkthrough artifact: what changed, files changed, test results,
        screenshots, and anything you could not verify and why.

If anything in the task is ambiguous or seems to require a logic change, stop and ask.
```

### 9.2 Workspace rule: .agent/rules/buildmove-ui-rules.md

```text
# BuildMove UI rules (always on)
- Work on one task from docs/UI_FIX_BRIEF.md at a time.
- Never change fare, capacity, routing, auth or API logic unless the task says so.
- Any value shown on several screens must come from one booking/user record.
- Use theme tokens only. No inline hex colors, radii or font sizes.
- Tap targets >= 48dp. Text >= 12sp. Body contrast >= 4.5:1 in light and dark.
- Every new string needs English and Tamil entries. Allow two-line labels.
- Demo and role-switch tools go behind a debug flag; do not delete them.
- Run flutter analyze and flutter test before claiming completion.
- Screenshot filenames must match content. No duplicate images.
- Never invent data or guarantees in the UI. Flag promise wording for approval.
```

### 9.3 Workflow: .agent/workflows/ui-fix.md (run as /ui-fix T02)

```text
# ui-fix
Implement one BuildMove UI task from docs/UI_FIX_BRIEF.md.

1. Read docs/UI_FIX_BRIEF.md and find the task ID the user gave.
2. Create an Implementation Plan artifact and wait for approval.
3. Implement the minimal change that satisfies the acceptance criteria.
4. Run flutter analyze and flutter test; fix failures caused by your change.
5. Capture before/after screenshots using the names in Section 8.
6. Verify every screenshot shows what its filename says; run the duplicate check.
7. Produce a Walkthrough artifact with results and any unverified items.
```

### 9.4 Suggested order of work

1. T01 (data mismatch) and T03 (vehicle guard evidence), because they affect trust.
2. T02 (sticky Confirm bar) and T04 (header declutter), the biggest visible improvements.
3. T05, T06, T07, T08, T09, T10, T11, T12 (polish), one at a time.
4. T13 and T14 after capturing the real current screens.
5. T15 and T16, then recapture the complete evidence set from Section 8.

## 10. Definition of done

A task is done only when all of the following are true:

- [ ] Every acceptance criterion is demonstrated, not just claimed.
- [ ] flutter analyze reports no issues and flutter test passes.
- [ ] Before and after screenshots exist with correct, unique filenames.
- [ ] English and Tamil both render without truncating critical information.
- [ ] Light and dark themes both meet the contrast rule.
- [ ] No business logic changed, or the change was explicitly approved.
- [ ] The Walkthrough lists what could not be verified.

My estimate (not a guarantee): once T01 to T04 are done and verified, the three scores from the review should move from 6.5 (UI), 6 (layout) and 6 to 6.5 (UX) to roughly 7.5, 7 and 7.5. Completing T05 to T16 and recapturing the evidence should reach about 8 on each.
