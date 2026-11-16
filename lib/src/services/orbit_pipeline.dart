/// Contrat du pipeline local.
/// Cette implémentation est volontairement une maquette : aucun faux résultat
/// de traduction n'est affiché et aucun micro n'est activé à ce stade.
class OrbitPipeline {
  OrbitPipeline.placeholder();

  Future<String> startDemoSession() async {
    return 'Prototype interface : moteurs vocaux locaux à intégrer.';
  }
}

/// Contrats prévus pour les composants natifs :
///
/// AudioCapture:
///   - capture PCM mono 16 kHz
///   - tampon circulaire court
///   - aucune écriture audio sur disque
///
/// SpeechRecognizer:
///   - reconnaissance multilingue locale
///   - détection de langue avec seuil de confiance
///
/// Translator:
///   - traduction locale source -> français ou français -> source
///   - signalement explicite des langues non prises en charge
///
/// SpeechSynthesizer:
///   - voix locale de destination
///   - génération par segments pour réduire la latence
///
/// Ces contrats seront implémentés après sélection et validation des modèles,
/// licences et performances sur le Dimensity 700 / 4 Go RAM.
