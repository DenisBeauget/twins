import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/style/style_schema.dart';
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
  late Future<List<Establishment>> _establishmentsHighLightFuture;
  late Future<List<Category>> _categoryFuture;
  late String _selectedCategory;
  Future<List<Establishment>>? _searchEstablishmentsFuture;
  Future<List<Establishment>>? _searchHighLightEstablishmentsFuture;
  Future<List<Category>>? _searchCategoryFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _establishmentsFuture = EstablishmentService().getEstablishments();
    _categoryFuture = CategoryService().getCategory();
    _establishmentsHighLightFuture =
        EstablishmentService().getHighLightEstablishments();
    _selectedCategory = '';
  }

  void _search(String keyword) {
    setState(() {
      _searchEstablishmentsFuture =
          EstablishmentService().searchEstablishments(keyword);
      _searchCategoryFuture = CategoryService().searchCategories(keyword);
      _searchHighLightEstablishmentsFuture =
          EstablishmentService().searchHighLightEstablishments(keyword);
    });
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.explore,
                style: const TextStyle(
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
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: lightColorScheme.primary),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_right_alt,
                          color: Colors.black),
                      onPressed: () {
                        _search(_searchController.text);
                      },
                    ),
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                  onSubmitted: _search,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Category>>(
              future: _searchCategoryFuture ?? _categoryFuture,
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...snapshot.data!.map((category) {
                            return CategoryButton(
                              text: category.name,
                              color: Colors.green,
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = category.name;
                                });
                              },
                            );
                          }).expand((widget) => [
                                widget,
                                const SizedBox(width: 10),
                              ]),
                        ],
                      ),
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
              future: _searchHighLightEstablishmentsFuture ??
                  _establishmentsHighLightFuture,
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
                    'Nos partenaires',
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
            FutureBuilder<List<Establishment>>(
              future: _searchEstablishmentsFuture ?? _establishmentsFuture,
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
            )
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
