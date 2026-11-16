# Compilation ORBIT sur Windows 11

Prérequis :
- Flutter stable.
- Android Studio avec Android SDK et Platform-Tools.
- VS Code facultatif.
- Connexion Internet sur le PC uniquement pour récupérer les dépendances et le modèle pendant la préparation.

Étapes :
1. Extraire l'archive.
2. Ouvrir le dossier ORBIT dans VS Code ou l'Explorateur.
3. Double-cliquer sur `scripts\\build_android_debug.bat`.
4. Le script télécharge le modèle Whisper Tiny sur le PC, génère la plateforme Android,
   enlève la permission INTERNET des manifestes, règle minSdk à 24 et compile l'APK.
5. L'APK sera dans `build\\app\\outputs\\flutter-apk\\app-debug.apk`.

Le modèle est intégré dans l'APK. ORBIT ne télécharge pas le modèle sur le téléphone
et son manifeste Android ne demande pas l'accès Internet.

Cette alpha assure la reconnaissance vocale locale. La traduction et la synthèse
vocale ne sont pas encore intégrées.
