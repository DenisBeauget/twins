import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twins_front/screen/admin_screen.dart';
import 'package:twins_front/screen/home_screen.dart';
import 'package:twins_front/utils/popup.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/utils/toaster.dart';
import 'package:twins_front/utils/validador.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/category_bloc.dart';
import '../widget/category_button.dart';

class ManageCategory extends StatelessWidget {
  ManageCategory({super.key});

  late CategoryBloc categoryBloc;

  String categoryName = "";

  @override
  Widget build(BuildContext context) {

    categoryBloc = BlocProvider.of<CategoryBloc>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
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
                          "Pour supprimer une catégorie, appuyez dessus.",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
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
              const SizedBox(height: 50),
              Text("Ajouter une catégorie",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                  autocorrect: true,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                      hintText: "Nom de la catégorie",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onChanged: (value) {
                    categoryName = value;
                  }),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: btnSecondaryStyle(context),
                    onPressed: () {
                      addCategory(categoryName, context);
                      reloadCategories(context);
                    },
                    child: Text("Ajouter")),
              )
            ],
          ),
        ),
      ),
    );
  }


  void reloadCategories(BuildContext context) {
    CategoryBloc.isChanged = false;
    categoryBloc.add(CategoriesALL());
  }

  void confirmDeleteCategory(Category category, BuildContext context) async {
    final bool result = await Popup.showPopupForDelete(
        context,
        "Supprimer la catégorie",
        "Êtes-vous sûr de vouloir supprimer la catégorie ${category.name} ?");
    if (result) {
      categoryBloc.add(DeleteCategory(category, context));
      reloadCategories(context);
    }
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
                  confirmDeleteCategory(category, context);
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

  void addCategory(String categoryName, BuildContext context) {
    if (categoryName.isNotEmpty) {
      categoryBloc
          .add(AddCategory(new Category(name: categoryName), context));
    } else {
      Toaster.showFailedToast(context, "Veuillez entrer un nom de catégorie");
    }
  }


}
