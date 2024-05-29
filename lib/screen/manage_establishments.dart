import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:twins_front/bloc/category_bloc.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/screen/admin_screen.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/utils/popup.dart';
import 'package:twins_front/widget/featured_card.dart';

class ManageEstablishments extends StatefulWidget {
  const ManageEstablishments({super.key});

  @override
  State<ManageEstablishments> createState() => _ManageEstablishments();
}

class _ManageEstablishments extends State<ManageEstablishments> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool? isChecked = true;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    EstablishmentBloc.isChanged = false;
    CategoryBloc.isChanged = false;
    Category? dropdownValue;

    final EstablishmentBloc establishmentBloc =
        BlocProvider.of<EstablishmentBloc>(context);

    final CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);

    categoryBloc.add(CategoriesALL());
    establishmentBloc.add(EstablishmentALL());

    Future<void> reloadEstablishments(BuildContext context, bool fromDB) async {
      if (fromDB) {
        Haptics.vibrate(HapticsType.medium);
        establishmentBloc.add(const EstablishmentManuallySet([]));
        EstablishmentBloc.isChanged = false;
        establishmentBloc.add(EstablishmentALL());
      } else {
        establishmentBloc.add(const EstablishmentManuallySet([]));
        establishmentBloc.add(EstablishmentManuallySet(
            establishmentBloc.state.establishmentList));
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
                    Popup.showPopupForDeleteEstablishment(
                        context, establishment.name, reloadEstablishments);
                  },
                  child: FeaturedCard(
                    imageUrl: 'https://picsum.photos/200/300',
                    title: establishment.name,
                    categoryName: establishment.categoryName ?? 'Unknow',
                  ),
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

    Widget returnCategories(CategoryState state, BuildContext context) {
      if (CategoryBloc.isChanged) {
        if (state.categoryList.isEmpty) {
          return const Center(
              child: Text("Pas de catégories trouvées",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
        } else {
          return DropdownButton<Category>(
            dropdownColor: Theme.of(context).colorScheme.secondary,
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: state.categoryList
                .map<DropdownMenuItem<Category>>((Category value) {
              return DropdownMenuItem<Category>(
                value: value,
                child: Text(
                  value.name,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (Category? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
              Popup.showPopupForDeleteCategory(
                context,
                dropdownValue?.name,
                () async {
                  categoryBloc.add(CategoriesALL());
                },
              );
            },
          );
        }
      } else {
        return Center(
            child: CircularProgressIndicator(
          color: lightColorScheme.primaryContainer,
        ));
      }
    }

    return Scaffold(
      backgroundColor: darkColorScheme.secondary,
      appBar: AppBar(
        backgroundColor: lightColorScheme.primaryContainer,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: const TextSpan(
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    text: "Gestion des établissements")),
            const SizedBox(width: 20),
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
                        decoration:
                            inputStyle("Nom de l'établissement", Icons.house),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          return returnCategories(state, context);
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                              text: const TextSpan(
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  text: "Mise en avant")),
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                          child: const Text("Ajoutez établissement")),
                    ],
                  ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: darkColorScheme.secondary,
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
        tooltip: "Retour à l'administration",
        child: const Icon(Icons.settings),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
