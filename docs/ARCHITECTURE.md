# Architecture ORBIT 0.2

## Pipeline actuel
Microphone -> whisper.cpp local -> transcription avec détection automatique.

## Pipeline cible
Microphone -> VAD/segmentation -> ASR multilingue -> détection langue ->
traduction locale -> TTS local -> sortie audio.

## ASR retenu pour alpha
`whisper_cpp_flutter_plus` 0.5.1, runtime whisper.cpp 1.9.2, MIT.
Modèle multilingue GGML Tiny embarqué dans les assets après préparation sur PC.
Le modèle est chargé depuis le stockage privé de l'application et le moteur est
forcé sur CPU pour éviter une dépendance à un backend GPU non validé sur le
Dimensity 700.

## Mémoire et batterie
- Modèle Tiny pour le premier test sur 4 Go RAM.
- Preset `efficient` (2 threads, greedy best-of 1, sans timestamps).
- Un seul moteur chargé.
- Pas de caméra, GPS, analytics ou historique audio.
- L'application ne démarre pas l'écoute tant que l'utilisateur n'appuie pas.

## Limites à résoudre
Whisper fournit de la transcription, pas la traduction vers le français. La
traduction et la synthèse vocale doivent être ajoutées séparément avec des modèles
mobiles compatibles, leurs licences vérifiées et leurs performances mesurées.
