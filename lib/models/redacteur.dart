class Redacteur {
  final String? id;
  final String nom;
  final String specialite;

  Redacteur({
    this.id,
    required this.nom,
    required this.specialite,
  });

  // Constructeur sans l'attribut id
  Redacteur.sansId({
    required this.nom,
    required this.specialite,
  }) : id = null;

  // Convertir un Redacteur en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'specialite': specialite,
    };
  }

  // Créer un Redacteur à partir d'un Map Firestore
  factory Redacteur.fromMap(Map<String, dynamic> map, String documentId) {
    return Redacteur(
      id: documentId,
      nom: map['nom'] ?? '',
      specialite: map['specialite'] ?? '',
    );
  }

  // Créer un Redacteur à partir d'un DocumentSnapshot
  factory Redacteur.fromFirestore(Map<String, dynamic> data, String id) {
    return Redacteur(
      id: id,
      nom: data['nom'] ?? '',
      specialite: data['specialite'] ?? '',
    );
  }
}
