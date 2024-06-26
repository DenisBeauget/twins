import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twins_front/utils/popup.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/utils/toaster.dart';

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
                    color: Theme.of(context).colorScheme.inversePrimary,
                    border: Border.all(color: Theme.of(context).colorScheme.inversePrimary, width: 20),
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 40),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Text(
                          AppLocalizations.of(context)!.admin_category_title,
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
                        child: returnCategories(context));
                  },
                ),
              ),
              const SizedBox(height: 50),
              Text(AppLocalizations.of(context)!.admin_category_add,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                  autocorrect: true,
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .admin_category_input_placeholder,
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
                    },
                    child:
                        Text(AppLocalizations.of(context)!.admin_category_add)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void confirmDeleteCategory(Category category, BuildContext context) async {
    final bool result = await Popup.showPopupForDelete(
        context,
        AppLocalizations.of(context)!.admin_category_popup_delete_title,
        AppLocalizations.of(context)!
            .admin_category_popup_delete_message(category.name));
    if (result) {
      categoryBloc.add(DeleteCategory(category, context));
    }
  }

  Widget returnCategories(BuildContext context) {
    if (categoryBloc.state is CategoryLoaded) {
      List<Category> categoryList = (categoryBloc.state as CategoryLoaded).categoryList;
      if (categoryList.isEmpty) {
        return Center(
            child: Text(AppLocalizations.of(context)!.category_not_found,
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
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                foregroundColor: Colors.black,
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
      categoryBloc.add(AddCategory(new Category(name: categoryName), context));
    } else {
      Toaster.showFailedToast(context, AppLocalizations.of(context)!.admin_category_empty_input);
    }
  }
}
