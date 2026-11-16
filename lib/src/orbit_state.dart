class OrbitState {
  bool isListening = false;
  bool isLoading = false;
  String status = 'Modèle vocal local à préparer';
  String transcript = '';
  String detectedLanguage = 'auto';
  String sourceLanguage = 'fr';
  String targetLanguage = 'auto';
}
