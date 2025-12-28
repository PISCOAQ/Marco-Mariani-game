import 'package:gioco_demo/class/models/Domanda.dart';

abstract class Attivita {
  final String id;
  final String titolo;
  Attivita({required this.id, required this.titolo});
}

class Quiz extends Attivita {
  final List<Domanda> domande;
  Quiz({required super.id, required super.titolo, required this.domande});
}

class Esercitazione extends Attivita {
  final String descrizione;
  Esercitazione({required super.id, required super.titolo, required this.descrizione});
}