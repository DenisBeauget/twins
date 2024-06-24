import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/utils/toaster.dart';

import '../bloc/category_bloc.dart';
import '../style/style_schema.dart';
import '../utils/popup.dart';
import '../widget/category_button.dart';
import '../widget/featured_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageEstablishments extends StatelessWidget {
  late Future<List<Category>> futureCategories;
  bool isChecked = false;

  late CategoryBloc categoryBloc;
  late EstablishmentBloc establishmentBloc;

  String establishmentName = "";

  late Category? categorySelected;

  final ValueNotifier<String> _notify = ValueNotifier<String>("");

  late File _image = File('');
  final picker = ImagePicker();

  ManageEstablishments({super.key});

  @override
  Widget build(BuildContext context) {
    categoryBloc = BlocProvider.of<CategoryBloc>(context);
    establishmentBloc = BlocProvider.of<EstablishmentBloc>(context);

    establishmentBloc.add(const EstablishmentFilterByKeyword(""));

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
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 40),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Expanded(
                        child: Text(
                            AppLocalizations.of(context)!
                                .admin_establishment_title,
                            style: const TextStyle(
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
                    hintText: AppLocalizations.of(context)!.search_placeholder,
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
                          child: returnEstablishments(context)),
                    );
                  },
                ),
                const SizedBox(height: 50),
                Text(
                    AppLocalizations.of(context)!.admin_establishment_add_title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    bloc: categoryBloc,
                    builder: (context, state) {
                      return SizedBox(
                          height: 40,
                          child: returnCategories((state as CategoryLoaded).categoryList, context));
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: _notify,
                  builder: (BuildContext context, String value, Widget? child) {
                    return returnSelectedCategory(context);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                    autocorrect: true,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .admin_establishment_name_input_placeholder,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.photo_outlined,
                            color: Theme.of(context).colorScheme.onSurface),
                        onPressed: () {
                          getImageFromGallery();
                        },
                      ),
                    ),
                    onChanged: (value) {
                      establishmentName = value;
                    }),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ChangeNotifierProvider(
                      create: (_) => CheckboxProvider(),
                      child: Consumer<CheckboxProvider>(
                        builder: (context, checkboxProvider, _) => Checkbox(
                            value: checkboxProvider.isChecked,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onChanged: (value) {
                              checkboxProvider.isChecked = value ?? true;
                              isChecked = checkboxProvider.isChecked;
                            }),
                      ),
                    ),
                    Text(AppLocalizations.of(context)!
                        .admin_establishment_highlight),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<EstablishmentBloc, EstablishmentState>(
                  bloc: establishmentBloc,
                  builder: (context, state) {
                    return returnAddBtn(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget returnCategories(List categoryList, BuildContext context) {
    if (categoryBloc.state is CategoryLoaded) {
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
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
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

  Widget returnAddBtn(BuildContext context) {
    if (establishmentBloc.state is EstablishmentCreating) {
      return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: btnSecondaryStyle(context),
            onPressed: () {
              addEstablishment(context);
            },
            child: Center(
                child: CircularProgressIndicator(
              color: lightColorScheme.primaryContainer,
            )),
          ));
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: btnSecondaryStyle(context),
          onPressed: () {
            addEstablishment(context);
          },
          child: Text(AppLocalizations.of(context)!.admin_establishment_add)),
    );
  }

  Widget returnEstablishments(BuildContext context) {
    if (establishmentBloc.state is EstablishmentLoaded) {
      List<Establishment> establishmentList =
          (establishmentBloc.state as EstablishmentLoaded).establishmentList;      if (establishmentList.isEmpty) {
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
                  confirmDeleteEstablishment(establishment, context);
                },
                child: FeaturedCardSmall(
                    imageUrl: establishment.imageUrl,
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

  Widget returnSelectedCategory(BuildContext context) {
    if (categorySelected == null) {
      return Text(AppLocalizations.of(context)!
          .admin_establishment_category_not_selected);
    } else {
      return Text(AppLocalizations.of(context)!
          .admin_establishment_category_selected(categorySelected!.name));
    }
  }

  void addEstablishment(BuildContext context) {
    if (categorySelected == null) {
      Toaster.showFailedToast(
          context,
          AppLocalizations.of(context)!
              .admin_establishment_select_category_message);
      return;
    }
    if (establishmentName.isEmpty) {
      Toaster.showFailedToast(context,
          AppLocalizations.of(context)!.admin_establishment_enter_name_message);
      return;
    }

    if (_image.path.isEmpty) {
      Toaster.showFailedToast(
          context,
          AppLocalizations.of(context)!
              .admin_establishment_select_image_message);
      return;
    }

    establishmentBloc.add(AddEstablishment(
        Establishment(
            name: establishmentName,
            hightlight: isChecked,
            categoryName: categorySelected?.name,
            imageUrl: '',
            imageName: ''),
        _image,
        context));
  }

  Future<void> confirmDeleteEstablishment(
      establishment, BuildContext context) async {
    final bool result = await Popup.showPopupForDelete(
        context,
        AppLocalizations.of(context)!.admin_establishment_popup_delete_title,
        AppLocalizations.of(context)!
            .admin_establishment_popup_delete_message(establishment.name));
    if (result) {
      establishmentBloc.add(DeleteEstablishment(establishment, context));
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File compressedFile =
          await FlutterNativeImage.compressImage(pickedFile.path, quality: 5);
      _image = compressedFile;
    }
  }
}

class CheckboxProvider with ChangeNotifier {
  bool _isChecked = false;

  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }
}
