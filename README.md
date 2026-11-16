# ORBIT 0.2 — Alpha reconnaissance vocale locale

## Ce que contient cette livraison

- Interface Flutter sobre avec orbe.
- Service de reconnaissance vocale locale basé sur whisper.cpp via
  `whisper_cpp_flutter_plus`.
- Détection automatique de la langue par Whisper.
- Capture micro et transcription en direct.
- Mode de performance `efficient` pour limiter la concurrence CPU.
- Modèle multilingue Whisper Tiny préparé depuis Windows puis embarqué dans l'APK.
- Aucun accès Internet déclaré dans le manifeste Android principal.

## Limites de cette alpha

Cette version réalise la **reconnaissance vocale locale**, pas encore la traduction
vers le français ni la synthèse vocale. Il ne faut pas la présenter comme un
interprète complet.

Le modèle Whisper Tiny est un choix de démarrage pour le Redmi Note 10 5G
(4 Go RAM, Dimensity 700). La qualité et la vitesse doivent être mesurées sur
l'appareil réel. Si le résultat est insuffisant, on comparera Base quantifié.

## Préparer et compiler sous Windows 11

1. Installer Flutter stable et Android Studio + SDK Android.
2. Ouvrir ce dossier dans VS Code.
3. Exécuter `scripts\\build_android_debug.bat`.
4. Le script télécharge le modèle sur le PC, le place dans les assets, puis compile
   un APK qui embarque le modèle. L'application installée n'a pas besoin de réseau.
5. APK : `build\\app\\outputs\\flutter-apk\\app-debug.apk`.

Le téléchargement du modèle sur le PC est requis lors de la première compilation.
Il ne s'agit pas d'un téléchargement par ORBIT sur le téléphone.

## Confidentialité

- Le service ASR ne fait aucun appel HTTP.
- Le manifeste Android principal ne déclare pas INTERNET.
- Pas d'analytics ni de télémétrie ajoutés.
- L'audio n'est pas écrit sur disque par le code de l'application.

La version finale doit encore faire l'objet d'un audit de toutes les dépendances
natives et de tests en mode avion. L'absence de permission INTERNET dans le
manifeste principal est une bonne barrière, mais ne remplace pas un audit.

## Langues

Whisper est multilingue et peut transcrire notamment le français, l'espagnol,
l'italien, l'allemand, le thaï et l'arabe. La reconnaissance des dialectes arabes
doit être évaluée par dialecte. La transcription ne fait pas la traduction.

## Étapes suivantes

1. Tester reconnaissance et latence sur Redmi Note 10 5G.
2. Intégrer un moteur de traduction locale adapté aux 4 Go RAM et à la licence.
3. Ajouter TTS local pour chaque langue.
4. Étendre les packs de langue et tester la conversation bidirectionnelle.
5. Porter et valider iOS sur macOS/Xcode.


## Installation simplifiée des outils Windows

Pour automatiser l'installation des outils gratuits, double-cliquer sur
`INSTALLER_ORBIT_WINDOWS.bat`. Le script utilise winget pour installer Git et
Android Studio, télécharge Flutter stable, puis vérifie l'environnement.
L'assistant initial Android Studio doit être terminé manuellement une seule fois.
