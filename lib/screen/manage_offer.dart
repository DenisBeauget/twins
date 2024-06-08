import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/bloc/offer_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/services/offers_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/utils/popup.dart';
import 'package:twins_front/widget/featured_card.dart';

class ManageOffer extends StatelessWidget {
  ManageOffer({super.key});

  bool isChecked = false;

  late EstablishmentBloc establishmentBloc;
  late OfferBloc offerBloc;
  late Establishment establishmentSelected =
      Establishment(name: "", hightlight: false, imageUrl: '', imageName: '');

  String establishmentName = "";

  final ValueNotifier<String> _notify = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    offerBloc = BlocProvider.of<OfferBloc>(context);
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
                          child: returnEstablishments(
                              state.establishmentList, context)),
                    );
                  },
                ),
                const Divider(height: 50),
                BlocBuilder<OfferBloc, OfferState>(
                    bloc: offerBloc,
                    builder: (context, state) {
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 120,
                            child: returnOffers(context),
                          ));
                    }),
                Text(
                    AppLocalizations.of(context)!.admin_establishment_add_title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                    autocorrect: true,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .admin_establishment_name_input_placeholder,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                        .admin_establishment_highlight)
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: btnSecondaryStyle(context),
                      onPressed: () {},
                      child: Text(AppLocalizations.of(context)!
                          .admin_establishment_add)),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
              return GestureDetector(
                onTap: () => {
                  establishmentSelected = establishment,
                  offerBloc.add(OfferALL(establishmentSelected.id!)),
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

  Widget returnOffers(BuildContext context) {
    if (establishmentSelected.name.isNotEmpty) {
      List<Offer> offersList = offerBloc.state.OfferList;
      if (offersList.isNotEmpty) {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: offersList.length,
            itemBuilder: (BuildContext context, int index) {
              final offer = offersList[index];
              return GestureDetector(child: Text(offer.title));
            });
      } else {
        return const Center(child: Text("Pas d'établissement selectioné"));
      }
    } else {
      return const Center(child: Text("Pas d'établissement selectioné"));
    }
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
}

class CheckboxProvider with ChangeNotifier {
  bool _isChecked = false;

  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }
}
