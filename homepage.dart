import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'companydetails.dart';

class Company {
  String id;
  String description;
  String email;
  String summary;
  String details;
  String category;

  Company(this.id, this.description, this.email, this.summary, this.details, this.category);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = ["All"];
  String selectedCategory = "All";
  List<Company> companies = [];
  bool isLoading = true;
  String errorText = "";

  final String categoriesUrl = "http://wazifati.atwebpages.com/get_categories.php";
  final String companiesUrl = "http://wazifati.atwebpages.com/get_companies.php";

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchCompanies();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(categoriesUrl));
      final decoded = jsonDecode(response.body);
      setState(() {
        categories = List<String>.from(decoded["categories"]);
      });
    } catch (e) {
      setState(() {
        errorText = "Failed to load categories: $e";
      });
    }
  }

  Future<void> fetchCompanies() async {
    try {
      final response = await http.get(Uri.parse(companiesUrl));
      final decoded = jsonDecode(response.body);
      final List<dynamic> list = decoded["companies"];
      setState(() {
        companies = list.map((c) => Company(
          c["company_id"].toString(),
          c["description"],
          c["email"],
          c["summary"],
          c["details"],
          c["category"],
        )).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorText = "Failed to load companies: $e";
        isLoading = false;
      });
    }
  }

  List<Company> getFilteredCompanies() {
    if (selectedCategory == "All") return companies;
    return companies.where((c) => c.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Company> filteredCompanies = getFilteredCompanies();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies & Jobs'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text('Select category', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            DropdownMenu<String>(
              width: 220,
              initialSelection: selectedCategory,
              onSelected: (value) => setState(() => selectedCategory = value!),
              dropdownMenuEntries: categories
                  .map((c) => DropdownMenuEntry<String>(value: c, label: c))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCompanies.length,
                itemBuilder: (context, index) {
                  Company company = filteredCompanies[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(company.email,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(company.description,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('${company.category}',
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CompanyDetailsPage(company),
                              ),
                            );
                          },
                          child: const Text('View details',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (errorText.isNotEmpty)
              Text(errorText, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
