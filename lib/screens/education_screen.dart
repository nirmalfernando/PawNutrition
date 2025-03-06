import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/education_content.dart';
import '../widgets/education_card.dart';

class EducationScreen extends StatefulWidget {
  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  late List<EducationContent> educationContent;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    educationContent = SampleData.getEducationContent();
  }

  List<String> getCategories() {
    Set<String> categories = Set<String>();
    categories.add('All');
    for (var content in educationContent) {
      categories.add(content.category);
    }
    return categories.toList();
  }

  List<EducationContent> getFilteredContent() {
    if (selectedCategory == 'All') {
      return educationContent;
    } else {
      return educationContent.where((content) => content.category == selectedCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredContent = getFilteredContent();

    return Column(
      children: [
        // Category filter
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: getCategories().map((category) {
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),

        // Education content list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredContent.length,
            itemBuilder: (context, index) {
              return EducationCard(
                content: filteredContent[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationDetailScreen(content: filteredContent[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class EducationDetailScreen extends StatelessWidget {
  final EducationContent content;

  EducationDetailScreen({required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content.category),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.menu_book,
                  size: 80,
                  color: Colors.grey[600],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    content.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Summary
                  Text(
                    content.summary,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Full content
                  Text(
                    content.content,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 32),

                  // Related products section
                  Text(
                    'Recommended Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // This would normally be populated with actual related products
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.pets),
                    ),
                    title: Text('Premium Dry Dog Food'),
                    subtitle: Text('\$49.99'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to product detail
                    },
                  ),

                  Divider(),

                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.pets),
                    ),
                    title: Text('Salmon Oil Supplement'),
                    subtitle: Text('\$24.99'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to product detail
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}