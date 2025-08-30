import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:share_plus/share_plus.dart';
import 'screens/redacteur_info_page.dart';
import 'screens/ajout_redacteur_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine Info',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 183, 58, 106),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 183, 58, 106),
        ),
      ),
      home: const PageAccueil(),
    );
  }
}

//----------------- Deuxième StatelessWidget : pageAccueil--------------------

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Méthode pour gérer la recherche
  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Ici vous pouvez implémenter la logique de recherche
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recherche pour: $query'),
          backgroundColor: const Color.fromARGB(255, 183, 58, 106),
        ),
      );
    }
  }

  // Méthode pour partager l'application
  void _shareApp() {
    Share.share(
      'Découvrez Magazine Info - Votre magazine numérique avec gestion des rédacteurs !',
      subject: 'Magazine Info - Application Mobile',
    );
  }

  // Méthode pour appeler
  void _makeCall() {
    // Simuler un appel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité d\'appel en cours de développement'),
        backgroundColor: Color.fromARGB(255, 183, 58, 106),
      ),
    );
  }

  // Méthode pour envoyer un email
  void _sendEmail() {
    // Simuler l'envoi d'email
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité d\'email en cours de développement'),
        backgroundColor: Color.fromARGB(255, 183, 58, 106),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Rechercher...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (_) => _handleSearch(),
              )
            : const Text(
                "Magazine Infos",
                style: TextStyle(color: Colors.white),
              ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 183, 58, 106),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Bouton de recherche
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 183, 58, 106),
              ),
              child: Text(
                'Menu de Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Ajouter un Rédacteur'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AjoutRedacteurPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Informations des Rédacteurs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RedacteurInfoPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Partager l\'application'),
              onTap: () {
                Navigator.pop(context);
                _shareApp();
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Nous contacter'),
              onTap: () {
                Navigator.pop(context);
                _makeCall();
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Envoyer un email'),
              onTap: () {
                Navigator.pop(context);
                _sendEmail();
              },
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/images/magazineInfo.jpeg'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            SizedBox(height: 20),
            PartieRubrique(),
          ],
        ),
      ),
    );
  }
}

//-------------- Troisième StatelessWidget : PartieTitre-----------------------

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bienvenue au Magazine Infos",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Votre magazine numérique, votre univers d'inspiration",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

//-------------- Quatrième StatelessWidget : PartieTexte-----------------------

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        "Magazine Infos est bien plus qu'un simple magazine numérique. C'est votre passerelle vers la mode, une source d'inspiration quotidienne où art et culture se rencontrent. Nos contenus soigneusement sélectionnés pour vous aideront sur les dernières tendances, la vie et nous veillerons à garder le divertissement au point.",
        style: TextStyle(fontSize: 14, height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

//---------------------------- Cinquième StatelessWidget : PartieIcone----------------------

class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconColumn(Icons.phone, "TEL", () {
            // Fonctionnalité d'appel
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fonctionnalité d\'appel en cours de développement'),
                backgroundColor: Color.fromARGB(255, 183, 58, 106),
              ),
            );
          }),
          _buildIconColumn(Icons.email, "MAIL", () {
            // Fonctionnalité d'email
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fonctionnalité d\'email en cours de développement'),
                backgroundColor: Color.fromARGB(255, 183, 58, 106),
              ),
            );
          }),
          _buildIconColumn(Icons.share, "PARTAGE", () {
            // Fonctionnalité de partage
            Share.share(
              'Découvrez Magazine Info - Votre magazine numérique avec gestion des rédacteurs !',
              subject: 'Magazine Info - Application Mobile',
            );
          }),
        ],
      ),
    );
  }

  Widget _buildIconColumn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 183, 58, 106)),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 183, 58, 106),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

//------------------- Sixième StatelessWidget : PartieRubrique----------------------------

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rubrique Presse - En cours de développement'),
                    backgroundColor: Color.fromARGB(255, 183, 58, 106),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/presse.jpeg',
                  fit: BoxFit.cover,
                  height: 120,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rubrique Mode - En cours de développement'),
                    backgroundColor: Color.fromARGB(255, 183, 58, 106),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/mode.jpeg',
                  fit: BoxFit.cover,
                  height: 120,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
