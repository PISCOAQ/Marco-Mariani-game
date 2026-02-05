import 'package:gioco_demo/class/models/Domanda.dart';


abstract class Pagina{
  final List<Domanda> lista_domande;

  Pagina({required this.lista_domande});
}

//Ogni classe sottostante è una pagina specilizzata in...
class AttribuzioneEmozioni extends Pagina {
  final String narrazione;

  AttribuzioneEmozioni({
    required super.lista_domande,
    required this.narrazione,
  });
}


class EyesTask extends Pagina {
  final String imagePath;

  EyesTask({
    required super.lista_domande,
    required this.imagePath,
  });
}


class TeoriaDellaMente extends Pagina {
  final String narrazione;

  TeoriaDellaMente({
    required super.lista_domande,
    required this.narrazione,
  });
}


class SituazioniSociali extends Pagina {
  final String? narrazione_before;
  final String bold;
  final String? narrazione_after;

  SituazioniSociali({
    required super.lista_domande,
    required this.narrazione_before,
    required this.bold,
    required this.narrazione_after,
  });
}

class PassoFalso extends Pagina {
  final String narrazione;

  PassoFalso({
    required super.lista_domande,
    required this.narrazione,
  });
}




//Definizione di Quiz/Esercitazione come un insieme di pagine

class Quiz {
  final String id;
  final String titolo;
  final List<Pagina> pagine;

  Quiz({
    required this.id,
    required this.titolo,
    required this.pagine,
  });
}

class Esercitazione {
  final String id;
  final String titolo;
  final List<Pagina> pagine;

  Esercitazione({
    required this.id,
    required this.titolo,
    required this.pagine,
  });
}