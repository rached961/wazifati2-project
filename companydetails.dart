import 'package:flutter/material.dart';
import 'homepage.dart'; // import Company model

class CompanyDetailsPage extends StatelessWidget {
  final Company company;

  const CompanyDetailsPage(this.company, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company.email), // or company.id if you prefer
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                company.description,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Text(
                "Category: ${company.category}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              Text(
                "Summary",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                company.summary,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              Text(
                "Details",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                company.details,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
