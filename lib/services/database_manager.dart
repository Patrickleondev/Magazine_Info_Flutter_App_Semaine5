import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/redacteur.dart';

class DatabaseManager {
  static Database? _database;

  // Obtenir l'instance de la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initialisation();
    return _database!;
  }

  // Initialiser la base de données
  Future<Database> initialisation() async {
    String path = join(await getDatabasesPath(), 'magazine_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE redacteurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Insérer un rédacteur
  Future<void> insertRedacteur(Redacteur redacteur) async {
    final Database db = await database;
    await db.insert(
      'redacteurs',
      redacteur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer tous les rédacteurs
  Future<List<Redacteur>> getAllRedacteurs() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('redacteurs');
    return List.generate(maps.length, (i) => Redacteur.fromMap(maps[i]));
  }

  // Mettre à jour un rédacteur
  Future<void> updateRedacteur(Redacteur redacteur) async {
    final Database db = await database;
    await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // Supprimer un rédacteur
  Future<void> deleteRedacteur(int id) async {
    final Database db = await database;
    await db.delete('redacteurs', where: 'id = ?', whereArgs: [id]);
  }
}
