import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/product_card.dart';

class ProductCatalogScreen extends StatefulWidget {
  @override
  _ProductCatalogScreenState createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  late List<Product> products;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    products = SampleData.getProducts();
  }

  List<String> getCategories() {
    Set<String> categories = Set<String>();
    categories.add('All');
    for (var product in products) {
      categories.add(product.category);
    }
    return categories.toList();
  }

  List<Product> getFilteredProducts() {
    if (selectedCategory == 'All') {
      return products;
    } else {
      return products.where((product) => product.category == selectedCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = getFilteredProducts();

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

        // Products grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: filteredProducts[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: filteredProducts[index]),
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