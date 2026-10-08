# BuildMove — Storage Cleanup & Asset Integrity Plan
**Purge Execution & Asset Validation Audit**

- **Date:** October 2026
- **Scope:** Complete replacement of legacy pre-Phase 2 `Client_Review` assets

---

## 1. Cleanup Objectives & Safety Boundaries
The previous `Client_Review/` folder contained obsolete screenshots and outdated documentation reflecting pre-Phase 2 bugs (such as the "Centering" material label, the incorrect cement bag calculation on timber, and unshielded cross-role profile state leaks).

### Explicit Safety Boundaries Enforced:
1. **Source Code**: ZERO source code files in `lib/`, `test/`, or native platforms were touched or deleted.
2. **Git History**: Complete commit history and tags were preserved intact without rebasing.
3. **Internal Audit Evidence**: The `audit_evidence_phase2/` folder containing internal test run records was strictly preserved.
4. **Build Artifacts**: The generated APKs in `build/app/outputs/flutter-apk/` and Gradle caches were retained for reproducible emulator deployment.

---

## 2. Purge & Rebuild Record

### Obsolete Files Purged from `Client_Review/`:
- All legacy screenshots from the pre-Phase 2 review were wiped prior to directory recreation.
- All temporary screencap scratch files (`temp_current.png`, `test_trips.png`, `test_back.png`, etc.) generated during the adb live session were removed from the workspace root.

### Structure Recreated:
The standardized 13-directory hierarchy was generated:
```
Client_Review/
├── 00_Overview/             (6 documents)
├── 01_Login_Authentication/ (3 images)
├── 02_Customer/             (12 images)
├── 03_Driver/               (4 images)
├── 04_Admin/                (6 images)
├── 05_Common_Settings/      (2 images)
├── 06_Light_Theme/          (12 gallery copies)
├── 07_Dark_Theme/           (5 images)
├── 08_Tamil_Language/       (4 images)
├── 09_English_Language/     (11 gallery copies)
├── 10_Interaction_States/   (9 gallery copies)
├── 11_Audit_Reports/        (2 documents)
└── 12_Storage_Cleanup/      (1 document)
```

---

## 3. Storage Footprint & Asset Validation

| Category | File Count | Disk Footprint | Integrity Status |
|:---|:---:|:---:|:---:|
| **Unique Screenshots** | 35 | ~7.2 MB | 100% Readable PNG, non-corrupted |
| **Organized Gallery Copies** | 32 | ~6.8 MB | SHA256 verified duplicates |
| **Documentation (Markdown)**| 9 | ~45 KB | UTF-8 GitHub Markdown, verified links |
| **Total Client_Review Package** | **76 files** | **~14.1 MB** | **CLEAN & READY FOR DELIVERY** |
