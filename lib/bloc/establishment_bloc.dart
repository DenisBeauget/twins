import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/services/offers_service.dart';
import 'package:twins_front/services/storage_service.dart';

import '../utils/toaster.dart';

class EstablishmentBloc extends Bloc<EstablishmentEvent, EstablishmentState> {
  EstablishmentService establishmentService = EstablishmentService();
  StorageService storageService = StorageService();
  OffersService offerService = OffersService();
  List<Establishment> currentEstablishments = List.empty();

  EstablishmentBloc() : super(EstablishmentInitialState()) {
    on<EstablishmentALL>((event, emit) async {
      emit(EstablishmentLoading());

      final List<Establishment> establishments = event.fromDB
          ? await establishmentService.getEstablishments()
          : currentEstablishments;

      for (Establishment establishment in establishments) {
        establishment.offers =
            await offerService.getOffersByEstablishment(establishment.id!);
      }

      emit(EstablishmentLoaded(establishments));
      currentEstablishments = establishments;
    });

    on<EstablishmentFilterByCategory>((event, emit) async {
      emit(EstablishmentLoading());

      final List<Establishment> establishments =
          currentEstablishments.where((establishment) {
        return establishment.categoryName == event.categoryName;
      }).toList();
      emit(EstablishmentLoaded(establishments));
    });

    on<EstablishmentFilterByKeyword>((event, emit) async {
      emit(EstablishmentLoading());

      List<Establishment> filteredEstablishments =
          currentEstablishments.where((establishment) {
        return establishment.name
            .toLowerCase()
            .contains(event.keyword.toLowerCase());
      }).toList();
      emit(EstablishmentLoaded(filteredEstablishments));
    });

    on<AddEstablishment>((event, emit) async {
      (state is EstablishmentLoaded)
          ? emit(EstablishmentCreating(
              (state as EstablishmentLoaded).establishmentList))
          : emit(EstablishmentCreating(List.empty()));

      //randomly generated image url

      int id = Random().nextInt(1000);

      String? imageUrl = await storageService.uploadFile(
          'establishments/${event.establishment.name}-$id', event.image);

      event.establishment.imageUrl = imageUrl!;
      String imagePath = 'establishments/${event.establishment.name}-$id';

      event.establishment.imageName = imagePath;

      await establishmentService
          .addEstablishment(event.establishment)
          .then((value) {
        if (value != null) {
          emit(EstablishmentLoading());
          event.establishment.id = value;
          currentEstablishments.add(event.establishment);
          Toaster.showSuccessToast(event.context,
              AppLocalizations.of(event.context)!.establishment_added);
        } else {
          storageService
              .deleteFile('establishments/${event.establishment.name}-$id');
          Toaster.showFailedToast(event.context,
              AppLocalizations.of(event.context)!.establishment_already_exist);
        }
      }).whenComplete(() => emit(EstablishmentLoaded(currentEstablishments)));
    });

    on<UpdateEstablishment>((event, emit) async {
      (state is EstablishmentLoaded)
          ? emit(EstablishmentCreating(
          (state as EstablishmentLoaded).establishmentList))
          : emit(EstablishmentUpdating(List.empty()));
      if (event.image.path != 'not_changed') {
        String oldImagePath = event.establishment.imageName;

        //randomly generated image url
        int id = Random().nextInt(1000);

        String? imageUrl = await storageService.uploadFile(
            'establishments/${event.establishment.name}-$id', event.image);

        event.establishment.imageUrl = imageUrl!;
        String imagePath = 'establishments/${event.establishment.name}-$id';

        event.establishment.imageName = imagePath;

        storageService.deleteFile(oldImagePath);
      }

      await establishmentService
          .updateEstablishment(event.establishment)
          .then((value) {
        if (value) {
          currentEstablishments
              .removeWhere((e) => e.id == event.establishment.id);
          currentEstablishments.add(event.establishment);
          Toaster.showSuccessToast(event.context, 'mis à jour avec succès');
        } else {
          Toaster.showFailedToast(
              event.context, 'Erreur lors de la mise à jour');
        }
      }).whenComplete(() => emit(EstablishmentLoaded(currentEstablishments)));
    });

    on<DeleteEstablishment>((event, emit) async {
      await establishmentService
          .deleteEstablishment(event.establishment.name)
          .then((value) {
        if (value) {
          emit(EstablishmentLoading());

          currentEstablishments
              .removeWhere((e) => e.name == event.establishment.name);
          Toaster.showSuccessToast(
              event.context,
              AppLocalizations.of(event.context)!
                  .admin_establishment_delete_success);
        } else {
          Toaster.showFailedToast(
              event.context, AppLocalizations.of(event.context)!.delete_error);
        }
      }).whenComplete(() => emit(EstablishmentLoaded(currentEstablishments)));
    });
  }
}

class EstablishmentState {}

class EstablishmentInitialState extends EstablishmentState {}

class EstablishmentLoading extends EstablishmentState {}

class EstablishmentLoaded extends EstablishmentState {
  final List<Establishment> establishmentList;

  EstablishmentLoaded(this.establishmentList);
}

class EstablishmentCreating extends EstablishmentState {
  final List<Establishment> establishmentList;

  EstablishmentCreating(this.establishmentList);
}

class EstablishmentUpdating extends EstablishmentState {
  final List<Establishment> establishmentList;

  EstablishmentUpdating(this.establishmentList);
}

class EstablishmentEvent {
  const EstablishmentEvent();

  List<Establishment> get props => [];
}

class EstablishmentALL extends EstablishmentEvent {
  final bool fromDB;

  EstablishmentALL(this.fromDB);
}

class EstablishmentFilterByCategory extends EstablishmentEvent {
  final String categoryName;

  const EstablishmentFilterByCategory(this.categoryName);
}

class EstablishmentFilterByKeyword extends EstablishmentEvent {
  final String keyword;

  const EstablishmentFilterByKeyword(this.keyword);
}

class AddEstablishment extends EstablishmentEvent {
  final Establishment establishment;
  final File image;
  final BuildContext context;

  const AddEstablishment(this.establishment, this.image, this.context);
}

class UpdateEstablishment extends EstablishmentEvent {
  final Establishment establishment;
  final File image;
  final BuildContext context;

  const UpdateEstablishment(this.establishment, this.image, this.context);
}

class DeleteEstablishment extends EstablishmentEvent {
  final Establishment establishment;
  final BuildContext context;

  const DeleteEstablishment(this.establishment, this.context);
}
