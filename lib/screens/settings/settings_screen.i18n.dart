import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "personal_details": "Personal Details",
          "open_dkt": "Open DKT",
          "edit_nickname": "Edit Nickname",
          "edit_profile_picture": "Edit Profile Picture",
          "remove_profile_picture": "Remove Profile Picture",
          "light": "Light",
          "dark": "Dark",
          "system": "System",
          "add_user": "Add User",
          "log_out": "Log Out",
          "update_available": "Update Available",
          "general": "General",
          "language": "Language",
          "startpage": "Startpage",
          "rounding": "Rounding",
          "appearance": "Appearance",
          "theme": "Theme",
          "color": "Color",
          "grade_colors": "Grade Colors",
          "notifications": "Notifications",
          "news": "News",
          "about": "About",
          "supporters": "Supporters",
          "privacy": "Privacy Policy",
          "licenses": "Licenses",
          "vibrate": "Vibration",
          "voff": "Off",
          "vlight": "Light",
          "vmedium": "Medium",
          "vstrong": "Strong",
          "done": "Done",
          "reset": "Reset",
          "open": "Open",
          "data_collected": "Data collected: Platform (eg. Android), App version (eg. 3.0.0), Unique Install Identifier",
          "Analytics": "Analytics",
          "Anonymous Usage Analytics": "Anonymous Usage Analytics",
          "graph_class_avg": "Display class average on graph",
        },
        "hu_hu": {
          "personal_details": "Személyes információk",
          "open_dkt": "DKT megnyitása",
          "edit_nickname": "Becenév szerkesztése",
          "edit_profile_picture": "Profil-kép szerkesztése",
          "remove_profile_picture": "Profil-kép törlése",
          "light": "Világos",
          "dark": "Sötét",
          "system": "Rendszer",
          "add_user": "Felhasználó hozzáadása",
          "log_out": "Kijelentkezés",
          "update_available": "Frissítés elérhető",
          "general": "Általános",
          "language": "Nyelv",
          "startpage": "Kezdőlap",
          "rounding": "Kerekítés",
          "appearance": "Kinézet",
          "theme": "Téma",
          "color": "Színek",
          "grade_colors": "Jegyek színei",
          "notifications": "Értesítések",
          "news": "Hírek",
          "about": "Névjegy",
          "supporters": "Támogatók",
          "privacy": "Adatvédelmi irányelvek",
          "licenses": "Licenszek",
          "vibrate": "Rezgés",
          "voff": "Kikapcsolás",
          "vlight": "Alacsony",
          "vmedium": "Közepes",
          "vstrong": "Erős",
          "done": "Kész",
          "reset": "Visszaállítás",
          "open": "Megnyitás",
          "data_collected": "Gyűjtött adat: Platform (pl. Android), App verzió (pl. 3.0.0), Egyedi telepítési azonosító",
          "Analytics": "Analitika",
          "Anonymous Usage Analytics": "Névtelen használási analitika",
          "graph_class_avg": "Osztályátlag a grafikonon",
        },
        "de_de": {
          "personal_details": "Persönliche Angaben",
          "open_dkt": "Öffnen DKT",
          "edit_nickname": "Spitznamen bearbeiten",
          "edit_profile_picture": "Profilbild bearbeiten",
          "remove_profile_picture": "Profilbild entfernen",
          "light": "Licht",
          "dark": "Dunkel",
          "system": "System",
          "add_user": "Benutzer hinzufügen",
          "log_out": "Abmelden",
          "update_available": "Update verfügbar",
          "general": "Allgemein",
          "language": "Sprache",
          "startpage": "Startseite",
          "rounding": "Rundung",
          "appearance": "Erscheinungsbild",
          "theme": "Thema",
          "color": "Farbe",
          "grade_colors": "Grad Farben",
          "notifications": "Benachrichtigungen",
          "news": "Nachrichten",
          "about": "Informationen",
          "supporters": "Unterstützer",
          "privacy": "Datenschutzbestimmungen",
          "licenses": "Lizenzen",
          "vibrate": "Vibration",
          "voff": "Aus",
          "vlight": "Leicht",
          "vmedium": "Mittel",
          "vstrong": "Stark",
          "done": "Fertig",
          "reset": "Zurücksetzen",
          "open": "Öffnen",
          "data_collected": "Erhobene Daten: Plattform (z.B. Android), App version (z.B. 3.0.0), Eindeutige Installationskennung",
          "Analytics": "Analytik",
          "Anonymous Usage Analytics": "Anonyme Nutzungsanalyse",
          "graph_class_avg": "Klassendurchschnitt in der Grafik",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
