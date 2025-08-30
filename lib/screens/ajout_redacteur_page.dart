import 'package:flutter/material.dart';
import '../models/redacteur.dart';
import '../services/firebase_service.dart';

class AjoutRedacteurPage extends StatefulWidget {
  const AjoutRedacteurPage({super.key});

  @override
  State<AjoutRedacteurPage> createState() => _AjoutRedacteurPageState();
}

class _AjoutRedacteurPageState extends State<AjoutRedacteurPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _specialiteController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  final ButtonStyle styleBouton = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 183, 58, 106),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  Future<void> _ajouterRedacteur() async {
    if (_formKey.currentState!.validate()) {
      try {
        final redacteur = Redacteur.sansId(
          nom: _nomController.text.trim(),
          specialite: _specialiteController.text.trim(),
        );

        await _firebaseService.ajouterRedacteur(redacteur);
        
        // Vider les champs
        _nomController.clear();
        _specialiteController.clear();
        
        if (mounted) {
          _afficherSuccesDialog();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'ajout: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _afficherSuccesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajout Réussi'),
          content: const Text('Le rédacteur a été ajouté avec succès !'),
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

  @override
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajout d\'un Rédacteur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 58, 106),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Champ Nom du Rédacteur
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom du Rédacteur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir le nom du rédacteur';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Champ Spécialité du Rédacteur
              TextFormField(
                controller: _specialiteController,
                decoration: const InputDecoration(
                  labelText: 'Spécialité du Rédacteur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir la spécialité du rédacteur';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 40),
              
              // Bouton Ajouter Rédacteur
              ElevatedButton(
                onPressed: _ajouterRedacteur,
                style: styleBouton,
                child: const Text('Ajouter Rédacteur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
