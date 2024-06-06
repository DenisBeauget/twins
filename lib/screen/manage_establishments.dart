import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/utils/toaster.dart';

import '../bloc/category_bloc.dart';
import '../style/style_schema.dart';
import '../utils/popup.dart';
import '../widget/category_button.dart';
import '../widget/featured_card.dart';

class ManageEstablishments extends StatelessWidget {
  late Future<List<Category>> futureCategories;
  bool isChecked = false;

  late CategoryBloc categoryBloc;
  late EstablishmentBloc establishmentBloc;

  String establishmentName = "";

  late Category? categorySelected = null;

  final ValueNotifier<String> _notify = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    categoryBloc = BlocProvider.of<CategoryBloc>(context);
    establishmentBloc = BlocProvider.of<EstablishmentBloc>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.green, width: 20),
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 40),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Expanded(
                        child: Text(
                            "Pour supprimer un établissement, appuyez dessus.",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.surface),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
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
                  ),
                  onChanged: (text) {
                    Future.delayed(const Duration(milliseconds: 300));
                    establishmentBloc.add(EstablishmentFilterByKeyword(text));
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<EstablishmentBloc, EstablishmentState>(
                  builder: (context, state) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                          height: 120,
                          child: returnEstablishments(
                              state.establishmentList, context)),
                    );
                  },
                ),
                const SizedBox(height: 50),
                Text("Ajouter un établissement",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    bloc: categoryBloc,
                    builder: (context, state) {
                      return SizedBox(
                          height: 40,
                          child: returnCategories(state.categoryList, context));
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: _notify,
                  builder: (BuildContext context, String value, Widget? child) {
                    return returnSelectedCategory();
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                    autocorrect: true,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        hintText: "Nom de l'établissement",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onChanged: (value) {
                      establishmentName = value;
                    }),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: btnSecondaryStyle(context),
                      onPressed: () {
                        addEstablishment(context);
                      },
                      child: Text("Ajouter")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget returnCategories(List categoryList, BuildContext context) {
    if (CategoryBloc.isChanged) {
      if (categoryList.isEmpty) {
        return const Center(
            child: Text("Pas de catégories trouvées",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
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
                  categorySelected = category;
                  _notify.value = categorySelected?.name ?? "";
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

  Widget returnEstablishments(List establishmentList, BuildContext context) {
    if (EstablishmentBloc.isChanged) {
      if (establishmentList.isEmpty) {
        return const Center(
            child: Text("Pas d'établissements trouvées",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
      } else {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: establishmentList.length,
            itemBuilder: (BuildContext context, int index) {
              final establishment = establishmentList[index];
              return GestureDetector(
                onTap: () {
                  confirmDeleteEstablishment(establishment, context);
                },
                child: FeaturedCardSmall(
                    imageUrl: 'https://picsum.photos/200/300',
                    title: establishment.name,
                    categoryName: establishment.categoryName ?? 'Unknow'),
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

  Widget returnSelectedCategory() {
    if (categorySelected == null) {
      return const Text("Aucune catégorie sélectionnée");
    } else {
      return Text("Catégorie sélectionnée : ${categorySelected?.name}");
    }
  }

  void addEstablishment(BuildContext context) {
    if (categorySelected == null) {
      Toaster.showFailedToast(context, "Veuillez sélectionner une catégorie");
      return;
    }
    if (establishmentName.isEmpty || establishmentName == null) {
      Toaster.showFailedToast(context, "Veuillez saisir un nom");
      return;
    }

    establishmentBloc.add(AddEstablishment(
        new Establishment(
            name: establishmentName,
            hightlight: isChecked,
            categoryName: categorySelected?.name),
        context));
  }

  Future<void> confirmDeleteEstablishment(
      establishment, BuildContext context) async {
    final bool result = await Popup.showPopupForDelete(
        context,
        "Supprimer l'établissement",
        "Êtes-vous sûr de vouloir supprimer l'établissement ${establishment.name} ?");
    if (result) {
      establishmentBloc.add(DeleteEstablishment(establishment, context));
    }
  }
}
