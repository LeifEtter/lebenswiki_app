import 'package:flutter/material.dart';

class ExampleData {
  List<Map> get pageData1 => [
        {
          "type": "TITLE",
          "title": "Warum sollst du investieren",
        },
        {
          "type": "LIST",
          "title": "1. Um Wohlstand aufzubauen - Altersvorsorge",
          "listItems": [
            "Der Markt erzielte in der Vergangenheit durschnittlichen jährlichen ROI von 10%",
          ],
        },
        {
          "type": "LIST",
          "title": "2. Sparer sind Verlierer (Battle Inflation)",
          "listItems": [
            "Vermögen > Bargeld",
            "Sie verlieren Kaufkraft, indem Sie nicht investieren",
            "Niedrige Kostenquoten für solide Investitionen (Vanguard, usw.)",
          ],
        },
        {
          "type": "LIST",
          "title": "3. Es war nie günstiger zu investieren",
          "listItems": [
            "0€  Trades/Gebühren sind die Norm",
            "Niedrige Kostenquoten für solide Investitionen (Vanguard, usw.)"
          ],
        },
        {
          "type": "LIST",
          "title": "4. Du musst kein Genie sein",
          "listItems": [
            "Es gibt Strategien, die Ihnen helfen, Ihr Vermögen im Laufe der Zeit zu steigern",
          ],
        },
      ];

  List<Map> get pageData2 => [
        {
          "type": "TITLE",
          "title": "ETF's  - Aktienbündel",
        },
        {
          "type": "LIST",
          "title": "Vorteile:",
          "listItems": [
            "Zugriff auf viele Aktien",
            "Geringer Aufwand Verhältnisse",
            "Einfach zu besitzen / zu verwalten / zu investieren / Ziele zu erreichen",
          ],
        },
        {
          "type": "LIST",
          "title": "Nachteile:",
          "listItems": [
            "Aktiv gemanagte ETFs sind höher Honorare",
            "Fehlender Schutz vor Verlusten (KEIN Hedgefonds)",
            "Die Diversifikation wird durch die Konzentration auf eine Branche begrenzt"
          ],
        },
      ];
  List<Map> get pageData3 => [
        {
          "type": "TITLE",
          "title": "Zinseszinseffekt",
        },
        {
          "type": "TEXT",
          "text":
              "Früherer gab es noch hohe Zinsen - Geld auf dem Konto wurde mehr. Heute geht das nicht mehr. Für mehr Geld müssen wir heute investieren. Doch wie geht das jetzt? Früh anzufangen macht einen großen Unterschied. Der Grund dafür: der Zinseszinseffekt. Einstein nannte es auch das achte Weltwunder. ",
        },
        {
          "type": "IMAGE",
          "src": "assets/images/zins_graph.png",
        },
      ];

  List get packData => [pageData1, pageData2, pageData3];
}
