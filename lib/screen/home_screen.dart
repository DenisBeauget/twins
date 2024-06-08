import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/bloc/category_bloc.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/screen/admin_screen.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/widget/category_button.dart';
import 'package:twins_front/widget/featured_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EstablishmentBloc.isChanged = false;
    CategoryBloc.isChanged = false;

    final EstablishmentBloc establishmentBloc =
        BlocProvider.of<EstablishmentBloc>(context);

    final CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);

    categoryBloc.add(CategoriesALL());
    establishmentBloc.add(EstablishmentALL());

    final TextEditingController searchController = TextEditingController();

    Widget returnCategories(List categoryList, BuildContext context) {
      if (CategoryBloc.isChanged) {
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
                  color: Colors.green,
                  onPressed: () {
                    EstablishmentBloc.isChanged = false;
                    establishmentBloc
                        .add(EstablishmentFilterByCategory(category.name));
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

    Widget returnHightlightEstablishments(
        List establishmentList, BuildContext context) {
      if (EstablishmentBloc.isChanged) {
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

    Widget returnEstablishments(List establishmentList, BuildContext context) {
      if (EstablishmentBloc.isChanged) {
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

    Future<void> reloadEstablishments(BuildContext context, bool fromDB) async {
      if (fromDB) {
        Haptics.vibrate(HapticsType.medium);
        establishmentBloc.add(const EstablishmentManuallySet([]));
        EstablishmentBloc.isChanged = false;
        establishmentBloc.add(EstablishmentALL());
        categoryBloc.add(CategoriesALL());
      } else {
        establishmentBloc.add(const EstablishmentManuallySet([]));
        establishmentBloc.add(EstablishmentManuallySet(
            establishmentBloc.state.establishmentList));
      }
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
        onRefresh: () => reloadEstablishments(context, true),
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
                      hintText: AppLocalizations.of(context)!.search_placeholder,
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
                              child: returnCategories(
                                  state.categoryList, context));
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
                        child: returnHightlightEstablishments(
                            state.establishmentList, context));
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
                        child: returnEstablishments(
                            state.establishmentList, context));
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
