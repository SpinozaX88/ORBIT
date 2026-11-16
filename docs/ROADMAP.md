# Roadmap ORBIT

## 0.2 — Alpha ASR
- Interface sobre.
- Reconnaissance vocale multilingue hors ligne.
- Modèle embarqué dans l'APK.
- Pas encore de traduction ni TTS.

## 0.3 — Traduction
- Choisir un moteur mobile local compatible avec 4 Go RAM.
- Vérifier licence, poids, latence et couverture FR/ES/IT/DE/TH/AR.
- Ne pas adopter NLLB-200 600M sans étude mémoire/licence : sa licence CC-BY-NC
  exclut un usage commercial et son déploiement mobile est lourd.

## 0.4 — Synthèse vocale
- Voix naturelles locales.
- Couverture de chaque langue vérifiée.
- Voix dialectales annoncées uniquement si elles existent réellement.

## 0.5 — Conversation
- Alternance automatique des interlocuteurs.
- Détection de changement de langue avec seuil de confiance.
- Gestion des interruptions et du bruit.

## 1.0
- Audit réseau et dépendances.
- Tests de batterie, RAM et latence sur appareils physiques.
- APK release signé.
- Portage iOS via macOS/Xcode.
