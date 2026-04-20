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
  final List<SezioneSociale> sezioni;

  SituazioniSociali({
    required this.sezioni,
    required List<Domanda> lista_domande,
  }) : super(lista_domande: lista_domande);
}

class SezioneSociale {
  final String? before;
  final String bold;
  final String? after;
  final Domanda domanda;

  SezioneSociale({this.before, required this.bold, this.after, required this.domanda});
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
  final String condizione;
  final int valore;
  final String idCondizioneSoddisfatta;

  Quiz({
    required this.id,
    required this.titolo,
    required this.pagine,
    required this.condizione,
    required this.valore,
    required this.idCondizioneSoddisfatta
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