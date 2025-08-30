# Magazine Info - Application de Gestion des Rédacteurs

Application mobile Flutter pour la gestion des rédacteurs d'un magazine numérique avec intégration Firebase.

## Fonctionnalités

- Page d'accueil avec présentation du magazine
- Ajout de nouveaux rédacteurs
- Affichage de la liste des rédacteurs en temps réel
- Modification des informations des rédacteurs
- Suppression de rédacteurs avec confirmation
- Synchronisation automatique avec Firebase Firestore

## Technologies utilisées

- Flutter 3.35.2
- Firebase Core 2.32.0
- Cloud Firestore 4.17.5
- Material Design 3

## Installation

1. Cloner le repository
2. Installer les dépendances : `flutter pub get`
3. Configurer Firebase (voir section Configuration)
4. Lancer l'application : `flutter run`

## Configuration Firebase

1. Créer un projet Firebase
2. Activer Firestore Database
3. Créer la collection "redacteurs"
4. Télécharger google-services.json dans android/app/
5. Configurer les règles de sécurité Firestore

## Structure du projet

```
lib/
├── main.dart                    # Point d'entrée
├── models/
│   └── redacteur.dart          # Modèle de données
├── services/
│   └── firebase_service.dart   # Service Firebase
└── screens/
    ├── ajout_redacteur_page.dart
    ├── redacteur_info_page.dart
    ├── modifier_redacteur_page.dart
    └── supprimer_redacteur_page.dart
```

## Branches

- `main` : Version SQLite (ancienne)
- `firebase-integration` : Version Firebase (actuelle)

## Téléchargement

APK disponible : [Magazine_Info_v1.0.0.apk](releases/Magazine_Info_v1.0.0.apk)

Voir [RELEASE.md](RELEASE.md) pour plus de détails.

## Captures d'écran

Les captures d'écran seront ajoutées après les tests sur appareil mobile.
