Map<int, String> errorMessages = {
  0: "Unser Backend untergeht gerade eine Wartung. Bitte versuche es später nochmals",
  1: "Es existiert kein Pack mit dieser ID",
  2: "Es existiert kein Pack mit dieser ID",
  3: "Es existiert kein User mit dieser ID",
  4: "Dein Passwort oder deine Email scheint falsch zu sein",
  5: "Löschen fehlgeschlagen. Bitte kontaktiere uns schnellstmöglich",
  6: "Dein altes Passwort scheint inkorrekt zu sein. Wenn du dein Password zurücksetzen willst, dann mache dies im Login Screen",
  7: "Um dies zu machen, musst du dich als Creator bewerben",
  8: "Um dies zu machen, musst du ein Account erstellen",
  9: "Ein Unbekannter Fehler ist aufgetreten",
  10: "Benutzer ist schon blockiert",
  11: "Du hast diesen Benutzer nicht blockiert",
  12: "Du kannst dich selber nicht blockieren",
  100: "Deine Email Adresse scheint ein ungültiges format zu haben",
  101: "Dein Passwort scheint ein ungültiges format zu haben.",
  102: "Bitte gib deinen Vor- und Nachnamen an",
  103: "Der Titel des Shorts muss zwischen 10 und 100 Charaktere haben",
  104: "Der Inhalt des Shorts muss zwischen 10 und 500 Charaktere haben",
  105: "Der Titel des Packs muss zwischen 10 und 100 Charaktere haben",
  106: "Die Beschreibung des Packs muss zwischen 10 und 500 Charaktere haben",
  110: "Die ID ist ungültig",
  111: "Die Biografie ist ungültig",
  112: "Bitte wähle mindestens eine Kategorie",
  113: "Überprüfe deine Initiative",
  114: "Stelle sicher dass das Pack eine Lesezeit von mindestens 1 Minute hat",
  115: "Du musst einen Grund angeben, warum du den Nutzer blockierst",
  116: "Du musst einen Grund angeben, warum du das Pack meldest",
  117: "Ein Benutzer mit dieser Email Adresse existiert bereits",
};

class ApiError {
  final int id;
  final String message;
  const ApiError({required this.id, required this.message});

  factory ApiError.fromJson(Map json) => ApiError(
        id: json["id"],
        message: errorMessages[json["id"]] ??
            "Ein Unbekannter Fehler ist aufgetreten",
      );

  factory ApiError.forUnknown() => ApiError(id: 9, message: errorMessages[9]!);

  Map<String, String> toJson() => {
        "id": id.toString(),
        "message": message.toString(),
      };
}

class CustomError {
  final String error;
  const CustomError({required this.error});
}
