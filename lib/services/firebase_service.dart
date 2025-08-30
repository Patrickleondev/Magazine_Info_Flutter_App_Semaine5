import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/redacteur.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'redacteurs';

  // Ajouter un rédacteur
  Future<void> ajouterRedacteur(Redacteur redacteur) async {
    try {
      await _firestore.collection(collection).add(redacteur.toMap());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du rédacteur: $e');
    }
  }

  // Obtenir tous les rédacteurs en temps réel
  Stream<List<Redacteur>> obtenirRedacteurs() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Redacteur.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Modifier un rédacteur
  Future<void> modifierRedacteur(String id, Map<String, dynamic> modifications) async {
    try {
      await _firestore.collection(collection).doc(id).update(modifications);
    } catch (e) {
      throw Exception('Erreur lors de la modification du rédacteur: $e');
    }
  }

  // Supprimer un rédacteur
  Future<void> supprimerRedacteur(String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du rédacteur: $e');
    }
  }

  // Obtenir un rédacteur par ID
  Future<Redacteur?> obtenirRedacteurParId(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        return Redacteur.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du rédacteur: $e');
    }
  }
}
