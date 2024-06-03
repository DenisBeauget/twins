import 'package:flutter/material.dart';
import 'package:twins_front/screen/admin_screen.dart';
import 'package:twins_front/screen/home_screen.dart';
import 'package:twins_front/utils/popup.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/utils/toaster.dart';
import 'package:twins_front/utils/validador.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageCategory extends StatefulWidget {
  const ManageCategory({super.key});

  @override
  State<ManageCategory> createState() => _ManageCategory();
}

class _ManageCategory extends State<ManageCategory> {
  late Future<List<Category>> futureCategories;
  Category? dropdownValue;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primaryContainer,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: TextSpan(
                    text: AppLocalizations.of(context)!.manage_category)),
            const SizedBox(width: 20),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    text: AppLocalizations.of(context)!.category_available)),
            const SizedBox(height: 20),
            FutureBuilder<List<Category>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No categories found');
                } else {
                  return DropdownButton<Category>(
                    dropdownColor: darkColorScheme.primaryContainer,
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: snapshot.data!
                        .map<DropdownMenuItem<Category>>((Category value) {
                      return DropdownMenuItem<Category>(
                        value: value,
                        child: Text(
                          value.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (Category? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      Popup.showPopupForDeleteCategory(
                          context, dropdownValue?.name, loadCategories);
                    },
                  );
                }
              },
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: inputStyle(
                          AppLocalizations.of(context)!.category_name,
                          Icons.category),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        style: btnPrimaryStyle(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            processAddCategory(context, _nameController.text);
                          }
                        },
                        child:
                            Text(AppLocalizations.of(context)!.add_category)),
                  ],
                ))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminScreen()))
        },
        child: const Icon(Icons.settings),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void processAddCategory(BuildContext context, String name) async {
    if (await CategoryService().addCategory(name)) {
      loadCategories();
      return Toaster.showSuccessToast(
          context, AppLocalizations.of(context)!.category_added);
    }
    return Toaster.showFailedToast(
        context, AppLocalizations.of(context)!.category_already_exist);
  }

  void loadCategories() {
    setState(() {
      futureCategories = CategoryService().getCategory();
      futureCategories.then((categories) {
        if (categories.isNotEmpty) {
          dropdownValue = categories[0];
        } else {
          dropdownValue = null;
        }
      });
    });
  }
}
