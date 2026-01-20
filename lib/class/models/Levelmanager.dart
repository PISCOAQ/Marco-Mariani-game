class LevelManager {
  // Teniamo traccia del livello massimo sbloccato
  static int currentLevel = 1;
  
  // Usiamo un Set per evitare duplicati
  static final Set<String> _unlockedLevels = {'1'};

  // Metodo per sbloccare: restituisce TRUE se il livello è stato appena sbloccato
  static bool unlock(String levelId) {
    if (!_unlockedLevels.contains(levelId)) {
      _unlockedLevels.add(levelId);
      
      // Aggiorna il livello numerico se possibile
      int? levelNum = int.tryParse(levelId);
      if (levelNum != null && levelNum > currentLevel) {
        currentLevel = levelNum;
      }
      return true; // Sblocco avvenuto con successo
    }
    return false; // Era già sbloccato, non fare nulla
  }

  static bool isUnlocked(String levelId) => _unlockedLevels.contains(levelId);
}