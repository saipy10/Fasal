import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GovtSchemePage extends StatelessWidget {
  const GovtSchemePage({super.key});

  final List<Map<String, dynamic>> schemes = const [
    {
      'title': 'National Mission on Edible Oils - Oilseeds (NMEO-Oilseeds)',
      'description':
          'Aims to boost domestic oilseed production and achieve self-reliance in edible oils over 2024-2031 with ₹10,103 crore.',
      'date': '2024-10-03',
      'imageUrl':
          'https://i0.wp.com/gokulamseekias.com/wp-content/uploads/2024/10/photo_2024-10-05_13-34-26-3.jpg?fit=870%2C489&ssl=1',
      'officialUrl': 'https://www.nfsm.gov.in/',
    },
    {
      'title': 'Pradhan Mantri Rashtriya Krishi Vikas Yojana (PM-RKVY)',
      'description':
          'Promotes sustainable agriculture with ₹57,074.72 crore, merging various schemes for flexibility.',
      'date': '2024-10-03',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe8D-5v5Y9J6Klos4NPrBsM-PM-QpE4WmHtA&s',
      'officialUrl': 'https://rkvy.nic.in/',
    },
    {
      'title': 'Krishonnati Yojana (KY)',
      'description':
          'Focuses on food security and agricultural self-sufficiency with ₹44,246.89 crore.',
      'date': '2024-10-03',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdEOceeqfm3FalX0CMxho56LnH8miehIMIkw&s',
      'officialUrl': 'https://agricoop.nic.in/',
    },
    {
      'title': 'Pradhan Mantri Kisan Samman Nidhi (PM-KISAN)',
      'description':
          'Provides ₹6,000 per year to small and marginal farmers in three installments.',
      'date': '2019-02-01',
      'imageUrl':
          'https://pm-yojana.in/uploads/images/2022/02/webp/image_750x_621c98137c8ab.webp',
      'officialUrl': 'https://pmkisan.gov.in/',
    },
    {
      'title': 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
      'description':
          'Government-sponsored crop insurance scheme integrating multiple stakeholders.',
      'date': '2016-04-13',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkLwYwcpOtJrlLGkkfaL-PvsutEyBhBG_JuA&s',
      'officialUrl': 'https://pmfby.gov.in/',
    },
    {
      'title': 'Pradhan Mantri Krishi Sinchai Yojana (PMKSY)',
      'description':
          'Aims to improve irrigation efficiency with micro-irrigation systems.',
      'date': '2015-07-01',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkJrfd56BuvF8CcwDSaEFlrejIeREh_oIh1Q&s',
      'officialUrl': 'https://pmksy.gov.in/',
    },
    {
      'title': 'Paramparagat Krishi Vikas Yojana (PKVY)',
      'description':
          'Promotes organic farming by forming clusters and covering certification costs.',
      'date': '2015-04-01',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyQNN0_xexqJ9pFPpW7GrGYhEB8Sc7CyiHUw&s',
      'officialUrl': 'https://pgsindia-ncof.gov.in/pkvy/index.aspx',
    },
    {
      'title': 'Soil Health Card Scheme',
      'description':
          'Issues soil health cards to farmers to improve soil fertility and nutrient management.',
      'date': '2015-02-19',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQS2rLFX8sfv3WXaS6n4VouciNM0XCn-pzagQ&s',
      'officialUrl': 'https://soilhealth.dac.gov.in/',
    },
  ];

  Future<void> _launchUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not launch website: $url")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error launching website: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedSchemes = List<Map<String, dynamic>>.from(schemes)
      ..sort((a, b) => b['date'].compareTo(a['date']));

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sortedSchemes.length,
        itemBuilder: (context, index) {
          final scheme = sortedSchemes[index];
          return InkWell(
            onTap: () => _launchUrl(scheme['officialUrl'], context),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        scheme['imageUrl'],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      scheme['title'],
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      scheme['description'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Launched: ${scheme['date']}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
