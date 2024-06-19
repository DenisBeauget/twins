import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:twins_front/bloc/category_bloc.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/widget/category_button.dart';
import 'package:twins_front/widget/featured_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/category_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EstablishmentBloc establishmentBloc =
        BlocProvider.of<EstablishmentBloc>(context);

    final CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);

    categoryBloc.add(CategoriesALL());
    establishmentBloc.add(EstablishmentALL(true));

    String categorySelected = "";


    final TextEditingController searchController = TextEditingController();

    Widget returnCategories(BuildContext context) {
      if (categoryBloc.state is CategoryLoaded) {
        List<Category> categoryList =
            (categoryBloc.state as CategoryLoaded).categoryList;
        if (categoryList.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.category_not_found,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)));
        } else {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                final category = categoryList[index];
                return CategoryButton(
                  text: category.name,
                  backgroundColor:
                      category.name == categorySelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.green,
                  foregroundColor:
                      category.name == categorySelected
                          ? Theme.of(context).colorScheme.surface
                          : Colors.black,
                  onPressed: () {
                    if(category.name != categorySelected) {
                      categorySelected = category.name;
                      establishmentBloc.add(EstablishmentFilterByCategory(category.name));
                    }else{
                      categorySelected = '';
                      establishmentBloc.add(EstablishmentALL(false));
                    }
                    categoryBloc.add(CategoriesRefresh());
                  },
                );
              });
        }
      } else {
        return Center(
            child: CircularProgressIndicator(
          color: lightColorScheme.primaryContainer,
        ));
      }
    }

    Widget returnHightlightEstablishments(BuildContext context) {
      if (establishmentBloc.state is EstablishmentLoaded) {
        List<Establishment> establishmentList =
            (establishmentBloc.state as EstablishmentLoaded).establishmentList;
        if (establishmentList.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.no_establishment_found,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
        } else {
          establishmentList = establishmentList.where((establishment) {
            return establishment.hightlight == true;
          }).toList();
          if (establishmentList.isEmpty) {
            return Center(
                child: Text(
                    AppLocalizations.of(context)!.no_establishment_found,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: establishmentList.length,
              itemBuilder: (BuildContext context, int index) {
                final establishment = establishmentList[index];
                return FeaturedCard(
                    imageUrl: establishment.imageUrl,
                    title: establishment.name,
                    categoryName: establishment.categoryName ?? 'Unknow');
              });
        }
      } else {
        return Center(
            child: CircularProgressIndicator(
          color: lightColorScheme.primaryContainer,
        ));
      }
    }

    Widget returnEstablishments(BuildContext context) {
      if (establishmentBloc.state is EstablishmentLoaded) {
        List<Establishment> establishmentList =
            (establishmentBloc.state as EstablishmentLoaded).establishmentList;
        if (establishmentList.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.no_establishment_found,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)));
        } else {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: establishmentList.length,
              itemBuilder: (BuildContext context, int index) {
                final establishment = establishmentList[index];
                return FeaturedCard(
                    imageUrl: establishment.imageUrl,
                    title: establishment.name,
                    categoryName: establishment.categoryName ?? 'Unknow');
              });
        }
      } else {
        return Center(
            child: CircularProgressIndicator(
          color: lightColorScheme.primaryContainer,
        ));
      }
    }

    Future<void> reloadEstablishments() async {
      Haptics.vibrate(HapticsType.medium);
      establishmentBloc.add(EstablishmentALL(true));
      categorySelected = '';
      searchController.clear();
      categoryBloc.add(CategoriesALL());
    }

    int navBarIndex = 0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.location_on, color: Colors.green),
            SizedBox(width: 4),
            Text(
              'Lille, France',
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => reloadEstablishments(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.explore,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)!.search_placeholder,
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_right_alt,
                            color: Theme.of(context).colorScheme.surface),
                        onPressed: () {
                          establishmentBloc.add(EstablishmentFilterByKeyword(
                              searchController.text));
                        },
                      ),
                    ),
                    onChanged: (text) {
                      Future.delayed(const Duration(milliseconds: 300));
                      establishmentBloc.add(
                          EstablishmentFilterByKeyword(searchController.text));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          return SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: returnCategories(context));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context)!.highlighted,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<EstablishmentBloc, EstablishmentState>(
                  builder: (context, state) {
                    return SizedBox(
                        height: 200,
                        child: returnHightlightEstablishments(context));
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.partners,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context)!.see_all,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<EstablishmentBloc, EstablishmentState>(
                  builder: (context, state) {
                    return SizedBox(
                        height: 200,
                        child: returnEstablishments(context));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
