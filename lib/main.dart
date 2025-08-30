import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MonApplication());
}

// Classe MonApplication - Application principale
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Météo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PrevisionInterface(),
    );
  }
}

// Classe PrevisionInterface - Interface utilisateur principale
class PrevisionInterface extends StatefulWidget {
  const PrevisionInterface({super.key});

  @override
  State<PrevisionInterface> createState() => _PrevisionInterfaceState();
}

class _PrevisionInterfaceState extends State<PrevisionInterface> {
  final TextEditingController _villeController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _donneesMeteo;
  String? _errorMessage;

  // Méthode pour récupérer les données météorologiques
  Future<void> _recupererDonnees() async {
    final ville = _villeController.text.trim();
    
    if (ville.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer le nom d\'une ville';
        _donneesMeteo = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _donneesMeteo = null;
    });

    try {
      // Remplacez 'VOTRE_API_KEY' par votre vraie clé API OpenWeather
      const apiKey = 'VOTRE_API_KEY'; // À remplacer par votre clé API
      final url = 'https://api.openweathermap.org/data/2.5/weather?q=$ville&appid=$apiKey&units=metric&lang=fr';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        // Conversion des données JSON en objet Dart
        _donneesMeteo = json.decode(response.body);
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur: Ville non trouvée ou problème de connexion';
          _donneesMeteo = null;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur de connexion: $e';
        _donneesMeteo = null;
      });
    }
  }

  @override
  void dispose() {
    _villeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prévisions météo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ de saisie pour la ville
            TextField(
              controller: _villeController,
              decoration: const InputDecoration(
                labelText: 'Entrez une ville',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              onSubmitted: (_) => _recupererDonnees(),
            ),
            
            const SizedBox(height: 20),
            
            // Bouton pour obtenir la météo
            ElevatedButton(
              onPressed: _isLoading ? null : _recupererDonnees,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Obtenir la météo'),
            ),
            
            const SizedBox(height: 30),
            
            // Affichage du chargement
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 10),
                    Text('Chargement des données météorologiques...'),
                  ],
                ),
              ),
            
            // Affichage des erreurs
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // Affichage des données météorologiques
            if (_donneesMeteo != null)
              DonneesMeteoWidget(donneesMeteo: _donneesMeteo!),
            
            // Message par défaut si aucune donnée
            if (!_isLoading && _errorMessage == null && _donneesMeteo == null)
              const Center(
                child: Text(
                  'Aucune donnée météo disponible.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Classe DonneesMeteoWidget - Affichage des données météorologiques
class DonneesMeteoWidget extends StatelessWidget {
  final Map<String, dynamic> donneesMeteo;

  const DonneesMeteoWidget({
    super.key,
    required this.donneesMeteo,
  });

  @override
  Widget build(BuildContext context) {
    final main = donneesMeteo['main'] as Map<String, dynamic>?;
    final weather = donneesMeteo['weather'] as List<dynamic>?;
    final weatherDescription = weather?.isNotEmpty == true 
        ? weather![0]['description'] as String? 
        : null;
    
    final temperature = main?['temp']?.toString();
    final description = weatherDescription ?? 'Description non disponible';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations météorologiques',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.thermostat, color: Colors.orange, size: 30),
              const SizedBox(width: 10),
              Text(
                'Température: ${temperature ?? 'N/A'}°C',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.cloud, color: Colors.blue, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Description: $description',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
