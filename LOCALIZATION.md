# Localization Guide

This guide explains how to use and extend the localization (l10n) system in OtoLog.

## Overview

OtoLog uses Flutter's built-in localization system with ARB (Application Resource Bundle) files. The system is designed to support multiple languages easily.

## Current Setup

- **Default Language**: English (en)
- **Localization Files**: Located in `lib/l10n/`
- **Configuration**: `l10n.yaml` in the project root
- **Helper Class**: `lib/shared/localization/l10n_helper.dart`

## File Structure

```
lib/l10n/
├── app_en.arb              # English translations (template)
├── app_localizations.dart  # Generated localization class
└── app_localizations_en.dart # Generated English localization
```

## How to Use Localization in Your Code

### Option 1: Using the L10n Helper Class

```dart
import 'package:flutter/material.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    
    return Text(l10n.home);
  }
}
```

### Option 2: Using the Extension Method (Recommended)

```dart
import 'package:flutter/material.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.home);
  }
}
```

### Option 3: Direct Access

```dart
import 'package:flutter/material.dart';
import 'package:otolog/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.home);
  }
}
```

## Adding New Languages

To add a new language to your app, follow these steps:

### Step 1: Create a New ARB File

Create a new ARB file in `lib/l10n/` with the language code. For example, for Indonesian:

```bash
lib/l10n/app_id.arb
```

### Step 2: Copy and Translate the Content

Copy the content from `app_en.arb` to your new file and translate all the values:

```json
{
  "@@locale": "id",
  "appTitle": "OtoLog",
  "home": "Beranda",
  "garage": "Garasi",
  "serviceLogs": "Log Layanan",
  "settings": "Pengaturan",
  // ... translate all other keys
}
```

**Important**: Keep all keys (including `@key` metadata) exactly the same as in the English file. Only translate the values.

### Step 3: Update main.dart

Add the new locale to the `supportedLocales` list in `lib/main.dart`:

```dart
supportedLocales: const [
  Locale('en'), // English
  Locale('id'), // Indonesian
],
```

### Step 4: Update the Helper Class (Optional)

Update the `AppLocales` class in `lib/shared/localization/l10n_helper.dart` to include the new locale:

```dart
static const List<Locale> supportedLocales = [
  Locale('en'), // English
  Locale('id'), // Indonesian
];

static String getLocaleDisplayName(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return 'English';
    case 'id':
      return 'Bahasa Indonesia';
    default:
      return locale.languageCode.toUpperCase();
  }
}
```

### Step 5: Regenerate Localization Files

Run the following command to regenerate the localization files:

```bash
flutter pub get
```

This will automatically generate `app_localizations_id.dart` and update `app_localizations.dart`.

## Adding New Translation Keys

To add a new translation key:

### Step 1: Add to app_en.arb

```json
{
  "newKey": "New Translation",
  "@newKey": {
    "description": "Description of what this translation is for"
  }
}
```

### Step 2: Add to All Other ARB Files

Add the same key to all other language ARB files with translations:

```json
// app_id.arb
{
  "newKey": "Terjemahan Baru",
  "@newKey": {
    "description": "Description of what this translation is for"
  }
}
```

### Step 3: Regenerate

```bash
flutter pub get
```

### Step 4: Use in Code

```dart
Text(context.l10n.newKey)
```

## Implementing Language Switching

To allow users to change the app language, you can create a language selector:

```dart
import 'package:flutter/material.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';

class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.locale,
      items: AppLocales.supportedLocales.map((locale) {
        return DropdownMenuItem<Locale>(
          value: locale,
          child: Text(AppLocales.getLocaleDisplayName(locale)),
        );
      }).toList(),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          // You'll need to implement locale switching logic
          // This typically requires a state management solution
          // or using a package like easy_localization
        }
      },
    );
  }
}
```

## Best Practices

1. **Use Descriptive Keys**: Make your translation keys descriptive and meaningful
2. **Add Context**: Always add `@key` metadata with descriptions for translators
3. **Keep Keys Consistent**: Use the same keys across all language files
4. **Test Thoroughly**: Test your app in all supported languages
5. **Handle Missing Translations**: The app will fall back to English if a translation is missing
6. **Use Parameters**: For dynamic content, use parameterized strings:

```json
{
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

Usage:

```dart
Text(context.l10n.welcomeMessage('John'))
```

## Troubleshooting

### Localization files not generating

- Ensure `generate: true` is set in `pubspec.yaml`
- Ensure `l10n.yaml` exists and is properly configured
- Run `flutter clean` and then `flutter pub get`

### Translations not showing

- Ensure the locale is in the `supportedLocales` list
- Check that the ARB file has the correct `@@locale` value
- Regenerate localization files with `flutter pub get`

### Missing translations

- The app will fall back to English if a translation is missing
- Ensure all keys exist in all ARB files
- Check for typos in key names

## Resources

- [Flutter Internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB Format Specification](https://github.com/google/app-resource-bundle)
- [intl package](https://pub.dev/packages/intl)

## Future Enhancements

Consider these enhancements for the future:

1. **Persistent Language Selection**: Save user's language preference using `shared_preferences`
2. **Auto-detect System Language**: Automatically use the device's language if supported
3. **RTL Support**: Add support for right-to-left languages (Arabic, Hebrew, etc.)
4. **Number/Date Formatting**: Use locale-specific formatting for numbers and dates
5. **Translation Management**: Use a translation management service for larger projects
