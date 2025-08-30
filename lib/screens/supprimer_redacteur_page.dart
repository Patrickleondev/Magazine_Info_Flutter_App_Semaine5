import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class SupprimerRedacteurPage extends StatelessWidget {
  final String redacteurId;
  final String nomRedacteur;

  const SupprimerRedacteurPage({
    super.key,
    required this.redacteurId,
    required this.nomRedacteur,
  });

  Future<void> _supprimerRedacteur(BuildContext context) async {
    try {
      final FirebaseService firebaseService = FirebaseService();
      await firebaseService.supprimerRedacteur(redacteurId);

      if (context.mounted) {
        // Afficher une boîte de dialogue de confirmation de suppression
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Suppression Réussie'),
              content: const Text('Le rédacteur a été supprimé avec succès !'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer la boîte de dialogue
                    Navigator.of(context).pop(); // Revenir à la page précédente
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 183, 58, 106),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Supprimer le Rédacteur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 58, 106),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône d'avertissement
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.red,
              ),
              
              const SizedBox(height: 30),
              
              // Message de confirmation
              const Text(
                'Êtes-vous sûr de vouloir supprimer ce rédacteur ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Nom du rédacteur à supprimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  nomRedacteur,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Bouton Annuler
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Revenir à la page précédente
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Annuler'),
                  ),
                  
                  // Bouton Supprimer le rédacteur
                  ElevatedButton(
                    onPressed: () => _supprimerRedacteur(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Supprimer le rédacteur'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
