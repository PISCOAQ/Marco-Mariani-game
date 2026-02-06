class EsitoPagina {
  final List<bool> esitiDomande;
  final bool paginaSuperata;
  final int? punteggioCanonicoPagina; //Solo per situazioni sociali

  EsitoPagina({
    required this.esitiDomande, 
    required this.paginaSuperata,
    this.punteggioCanonicoPagina,
    });
}