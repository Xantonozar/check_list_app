---
name: google-sheets-exporter
description: >-
  Use this skill when implementing Google Sign-In OAuth for Sheets/Drive scopes, 
  creating the master 'মুহাসাবাত — রিপোর্ট' Google Spreadsheet, and appending weekly 
  evaluation reports and tabs using the googleapis package.
---

# Google Sheets Exporter Skill

This skill outlines the single-master-sheet export procedure for Muhasabat.

## OAuth Scopes Required

```dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis/drive/v3.dart' as drive;

final googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    sheets.SheetsApi.spreadsheetsScope,
    drive.DriveApi.driveFileScope,
  ],
);
```

## Master Spreadsheet Logic

1. **Check for Existing Spreadsheet ID**:
   - Query user profile in Firebase or `SharedPreferences` for `google_sheet_id`.
2. **First-time Creation**:
   - If no ID exists, create a new spreadsheet in user Drive titled: `মুহাসাবাত — রিপোর্ট`.
   - Save the returned `spreadsheetId` to the user's database profile.
3. **Subsequent Weekly Exports**:
   - Reuse the existing `spreadsheetId`.
   - Add a new worksheet (sheet tab) titled with the week's Bangla date range (e.g., `২৭ সেপ্ট - ৩ অক্টো`).
   - Write headers and rows:
     - **Header Row**: `[ 'তারিখ', 'মোট টাস্ক', 'সম্পন্ন', 'স্কোর (%)' ]`
     - **Daily Rows (7 Days)**: `[ 'YYYY-MM-DD', totalTasks, completedCount, score ]`
     - **Summary Row**: `[ 'সাপ্তাহিক গড়', '-', '-', weeklyAverageScore ]`
