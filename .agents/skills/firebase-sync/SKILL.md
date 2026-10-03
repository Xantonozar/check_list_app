---
name: firebase-sync
description: >-
  Use this skill when interacting with Firebase Auth (Email/Password, Google Sign-In) 
  and Firebase Realtime Database paths, data serialization, and daily record sync.
---

# Firebase Realtime Database & Auth Skill

This skill documents the schema, data serialization, and synchronization for Muhasabat.

## Database Path Structure

```
muhasabat/
└── users/
    └── {uid}/
        ├── profile/
        │   ├── name: String
        │   ├── email: String
        │   ├── googleSheetId: String?
        │   ├── nightDhikrTime: String  (e.g., "22:30")
        │   ├── notificationToggles: { "fajr": true, "dhuhr": true, ... }
        │   └── createdAt: int (epoch ms)
        ├── tasks/
        │   └── {taskId}/
        │       ├── title: String
        │       ├── description: String
        │       ├── priority: "mandatory" | "high" | "medium" | "low"
        │       ├── isMandatory: bool
        │       ├── hadithRef: String?
        │       ├── quranRef: String?
        │       └── createdAt: int (epoch ms)
        └── records/
            └── {YYYY-MM-DD}/
                ├── completedTasks/
                │   └── {taskId}: bool
                └── score: double
```

## Security & Immutability Rules

1. **Mandatory Tasks**: Tasks where `isMandatory == true` must never be modified or deleted by client calls.
2. **Date Keying**: Store daily records strictly by ISO 8601 date string `YYYY-MM-DD` (e.g., `2026-10-03`) to ensure clean history aggregation.
