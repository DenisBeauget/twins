import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/widget/featured_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EstablishmentsScreen extends StatelessWidget {
  const EstablishmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EstablishmentBloc establishmentBloc =
        BlocProvider.of<EstablishmentBloc>(context);

    establishmentBloc.add(EstablishmentALL(false));

    final TextEditingController searchController = TextEditingController();

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
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: establishmentList.length,
              itemBuilder: (BuildContext context, int index) {
                final establishment = establishmentList[index];
                return FeaturedCardBig(establishment: establishment);
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
      searchController.clear();
    }

    int navBarIndex = 0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            establishmentBloc.add(
                const EstablishmentFilterByKeyword(""));
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.partners,
          style:
          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => reloadEstablishments(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<EstablishmentBloc, EstablishmentState>(
                  builder: (context, state) {
                    return returnEstablishments(context);
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
