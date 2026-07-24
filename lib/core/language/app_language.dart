enum AppLanguage {

  english,

  persian,

  arabic,

  japanese,

  french,

  german,

  russian,

}


extension AppLanguageExtension on AppLanguage {


  String get code {

    switch (this) {

      case AppLanguage.english:
        return "en";

      case AppLanguage.persian:
        return "fa";

      case AppLanguage.arabic:
        return "ar";

      case AppLanguage.japanese:
        return "ja";

      case AppLanguage.french:
        return "fr";

      case AppLanguage.german:
        return "de";

      case AppLanguage.russian:
        return "ru";

    }

  }


  String get name {

    switch (this) {

      case AppLanguage.english:
        return "English";

      case AppLanguage.persian:
        return "فارسی";

      case AppLanguage.arabic:
        return "العربية";

      case AppLanguage.japanese:
        return "日本語";

      case AppLanguage.french:
        return "Français";

      case AppLanguage.german:
        return "Deutsch";

      case AppLanguage.russian:
        return "Русский";

    }

  }

}