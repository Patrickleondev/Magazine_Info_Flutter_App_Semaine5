import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/redacteur.dart';
import 'modifier_redacteur_page.dart';
import 'supprimer_redacteur_page.dart';

class RedacteurInfoPage extends StatelessWidget {
  const RedacteurInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informations des Rédacteurs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 58, 106),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('redacteurs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Une erreur s\'est produite',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 183, 58, 106),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Aucun rédacteur trouvé',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final redacteurs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: redacteurs.length,
            itemBuilder: (context, index) {
              final doc = redacteurs[index];
              final redacteurData = doc.data() as Map<String, dynamic>;
              final redacteur = Redacteur.fromFirestore(redacteurData, doc.id);

              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 183, 58, 106),
                    child: Text(
                      redacteur.nom.isNotEmpty ? redacteur.nom[0].toUpperCase() : 'R',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    redacteur.nom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Spécialité: ${redacteur.specialite}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton Modifier
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 183, 58, 106),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierRedacteurPage(
                                redacteurId: redacteur.id!,
                                redacteurData: redacteurData,
                              ),
                            ),
                          );
                        },
                      ),
                      // Bouton Supprimer
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupprimerRedacteurPage(
                                redacteurId: redacteur.id!,
                                nomRedacteur: redacteur.nom,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
