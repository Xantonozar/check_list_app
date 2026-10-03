---
name: muhasabat-architecture-theme
description: >-
  Use this skill when building or styling UI components, implementing Clean Architecture layers, 
  applying the Muhasabat Material 3 theme (Light/Dark mode), Glassmorphism, Neumorphism, 
  and enforcing strict Bangla UI language and Noto Sans Bengali typography.
---

# Muhasabat Architecture & Theme Skill

This skill provides direct guidelines, folder hierarchy, and UI design standards for the Muhasabat app.

## Architecture Pattern

Follow **Clean Architecture** with a **Feature-First** structure:
```
Presentation → Domain ← Data
```

- **Domain Layer (`features/<feature>/domain`)**: Pure Dart only. Zero Flutter/Riverpod/Firebase dependencies.
- **Data Layer (`features/<feature>/data`)**: Implements domain interfaces, communicates with Firebase Realtime Database and local storage.
- **Presentation Layer (`features/<feature>/presentation`)**: Riverpod state management (`AsyncNotifier`), Pages, Widgets, and Glassmorphic/Neumorphic UI components.

## Exact Color Tokens

### Light Mode
- Primary: `#0F733D`
- Primary Container: `#E8F5EE`
- On Primary: `#FFFFFF`
- Background: `#FAFBFA`
- Surface: `#FFFFFF`
- On Surface: `#1A1C1A`
- On Surface Variant: `#5C6B5F`
- Outline: `#C5D1C8`
- Error: `#BA1A1A`

### Dark Mode
- Primary: `#4CAF7A`
- Primary Container: `#0A4A28`
- On Primary: `#003918`
- Background: `#0F1411`
- Surface: `#1A211D`
- On Surface: `#E2E8E3`
- On Surface Variant: `#A8B5AC`
- Outline: `#3A4540`
- Error: `#FFB4AB`

## Typography & Localization Rules

1. **Font**: Use **Noto Sans Bengali** (`GoogleFonts.notoSansBengaliTextTheme`).
2. **Language**: 100% of user-facing strings must be in **Bangla**. No English in the UI.
3. **Arabic**: Allowed only in Quranic ayat or Hadith reference quotations.
4. **Emoji**: Never use emojis in UI text or buttons.

## Glassmorphic Card & Bottom Navigation Bar

Use backdrop filter blur + semi-transparent surface with subtle borders:

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

Widget buildGlassmorphicCard({
  required BuildContext context,
  required Widget child,
  double blur = 10.0,
  double opacity = 0.7,
  BorderRadius? borderRadius,
}) {
  final theme = Theme.of(context);
  final radius = borderRadius ?? BorderRadius.circular(16);

  return Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.surface.withValues(alpha: opacity),
      borderRadius: radius,
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.2),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: child,
      ),
    ),
  );
}
```
