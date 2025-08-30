import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModifierRedacteurPage extends StatefulWidget {
  final String redacteurId;
  final Map<String, dynamic> redacteurData;

  const ModifierRedacteurPage({
    super.key,
    required this.redacteurId,
    required this.redacteurData,
  });

  @override
  State<ModifierRedacteurPage> createState() => _ModifierRedacteurPageState();
}

class _ModifierRedacteurPageState extends State<ModifierRedacteurPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _specialiteController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les données actuelles du rédacteur
    _nomController.text = widget.redacteurData['nom'] ?? '';
    _specialiteController.text = widget.redacteurData['specialite'] ?? '';
  }

  Future<void> _enregistrerModifications() async {
    if (_nomController.text.trim().isEmpty || _specialiteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Créer le dictionnaire des modifications
      final Map<String, dynamic> modifications = {
        'nom': _nomController.text.trim(),
        'specialite': _specialiteController.text.trim(),
      };

      // Mettre à jour les données dans Firestore
      await _firestore
          .collection('redacteurs')
          .doc(widget.redacteurId)
          .update(modifications);

      if (mounted) {
        // Afficher une boîte de dialogue de confirmation
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Modification Réussie'),
              content: const Text('Les informations du rédacteur ont été mises à jour avec succès !'),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la modification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          'Modifier le Rédacteur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 58, 106),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            ),
            
            const SizedBox(height: 40),
            
            // Bouton Enregistrer les modifications
            ElevatedButton(
              onPressed: _enregistrerModifications,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 183, 58, 106),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
