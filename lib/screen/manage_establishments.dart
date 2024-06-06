import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:twins_front/bloc/category_bloc.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/screen/admin_screen.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/utils/popup.dart';
import 'package:twins_front/utils/toaster.dart';
import 'package:twins_front/widget/featured_card.dart';

class ManageEstablishments extends StatefulWidget {
  const ManageEstablishments({super.key});

  @override
  State<ManageEstablishments> createState() => _ManageEstablishments();
}

class _ManageEstablishments extends State<ManageEstablishments> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  Category? dropdownValue;
  late Future<List<Category>> futureCategories;
  bool? isChecked = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    final EstablishmentBloc establishmentBloc =
        BlocProvider.of<EstablishmentBloc>(context);

    final CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);

    categoryBloc.add(CategoriesALL());
    establishmentBloc.add(EstablishmentALL());

    Future<void> reloadEstablishments(BuildContext context, bool fromDB) async {
      if (fromDB) {
        Haptics.vibrate(HapticsType.medium);
        establishmentBloc.add(const EstablishmentManuallySet([]));
        await Future.delayed(const Duration(seconds: 1));
        establishmentBloc.add(EstablishmentALL());
      } else {
        establishmentBloc.add(const EstablishmentManuallySet([]));
        establishmentBloc.add(EstablishmentManuallySet(
            establishmentBloc.state.establishmentList));
      }
    }

    Widget returnEstablishments(List establishmentList, BuildContext context) {
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
              return GestureDetector(
                onTap: () {
                  Popup.showPopupForDeleteEstablishment(
                      context, establishment.name, reloadEstablishments);
                },
                child: FeaturedCard(
                  imageUrl: 'https://picsum.photos/200/300',
                  title: establishment.name,
                  categoryName: establishment.categoryName ?? 'Unknown',
                ),
              );
            });
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.manage_establishment)),
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
                      hintText: 'Search',
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
                child: BlocBuilder<EstablishmentBloc, EstablishmentState>(
                  builder: (context, state) {
                    return SizedBox(
                        height: 200,
                        child: returnEstablishments(
                            state.establishmentList, context));
                  },
                ),
              ),
              const Divider(
                color: Colors.black,
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
                            AppLocalizations.of(context)!.establishment_name,
                            Icons.house),
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<List<Category>>(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('No categories found');
                          } else {
                            return DropdownButton<Category>(
                              value: dropdownValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: snapshot.data!
                                  .map<DropdownMenuItem<Category>>(
                                      (Category value) {
                                return DropdownMenuItem<Category>(
                                  value: value,
                                  child: Text(
                                    value.name,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Category? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  text: AppLocalizations.of(context)!
                                      .highlighted)),
                          Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          style: btnPrimaryStyle(),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await processAddEstablishment(
                                  context,
                                  dropdownValue!.name,
                                  _nameController.text,
                                  isChecked!);
                              reloadEstablishments(context, true);
                            }
                          },
                          child: Text(
                              AppLocalizations.of(context)!.add_establishment)),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> processAddEstablishment(BuildContext context,
      String categoryName, String name, bool isHighlight) async {
    if (await EstablishmentService()
        .addEstablishment(categoryName, name, isHighlight)) {
      Toaster.showSuccessToast(
          context, AppLocalizations.of(context)!.establishment_added);
    } else {
      Toaster.showFailedToast(
          context, AppLocalizations.of(context)!.establishment_already_exist);
    }
  }

  void loadCategories() {
    futureCategories = CategoryService().getCategory();
    futureCategories.then((categories) {
      setState(() {
        if (categories.isNotEmpty) {
          dropdownValue = categories[0];
        } else {
          dropdownValue = null;
        }
      });
    });
  }
}
