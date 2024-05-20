import 'package:flutter/material.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/widget/category_button.dart';
import 'package:twins_front/widget/featured_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Establishment>> _establishmentsFuture;
  late Future<List<Category>> _categoryFuture;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _establishmentsFuture = EstablishmentService().getEstablishments();
    _categoryFuture = CategoryService().getCategory();
    _selectedCategory = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.location_on, color: Colors.green),
            SizedBox(width: 4),
            Text(
              'Lille, France',
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Explore',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Bistrot Minot',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.filter_list),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Category>>(
              future: CategoryService().getCategory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No categories found'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: snapshot.data!.map((category) {
                        return CategoryButton(
                          text: category.name,
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              _selectedCategory = category.name;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Nos coups de ♥️',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Establishment>>(
              future: EstablishmentService().getEstablishments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No establishments found'));
                } else {
                  List<Establishment> filteredEstablishments;
                  if (_selectedCategory.isEmpty) {
                    filteredEstablishments = snapshot.data!;
                  } else {
                    filteredEstablishments = snapshot.data!
                        .where((establishment) =>
                            establishment.categoryName == _selectedCategory)
                        .toList();
                  }
                  if (filteredEstablishments.isEmpty) {
                    return Text(
                      AppLocalizations.of(context)!.no_establishment_found,
                    );
                  }
                  return FeaturedSection(
                      establishments: filteredEstablishments);
                }
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Restaurants 🍔',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    'Tout voir',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const RestaurantSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

class FeaturedSection extends StatelessWidget {
  final List<Establishment> establishments;

  const FeaturedSection({super.key, required this.establishments});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: establishments.length,
        itemBuilder: (context, index) {
          final establishment = establishments[index];
          return FeaturedCard(
              imageUrl: 'https://picsum.photos/200/300',
              title: establishment.name,
              categoryName: establishment.categoryName ?? 'Unknow');
        },
      ),
    );
  }
}

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          RestaurantCard(
            imageUrl: 'https://picsum.photos/200/300',
            title: 'Western Strait',
            locations: 16,
          ),
          RestaurantCard(
            imageUrl: 'https://picsum.photos/200/300',
            title: 'Beach House',
            locations: 22,
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int locations;

  const RestaurantCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            '$locations locations',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
