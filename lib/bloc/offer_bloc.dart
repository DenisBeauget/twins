import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/services/offers_service.dart';
import 'package:twins_front/services/establishments_service.dart';

import '../utils/toaster.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  static bool isChanged = false;
  OffersService OfferService = OffersService();

  List<Offer> currentOffers = List.empty();

  OfferBloc() : super(OfferState(List.empty())) {
    on<OfferALL>((event, emit) async {
      isChanged = false;
      final List<Offer> offers =
          await OfferService.getOffersByEstablishment(event.establishmentName);
      print(offers.length);
      emit(OfferState(offers));
      currentOffers = offers;
      isChanged = true;
    });

    on<OfferManuallySet>((event, emit) async {
      isChanged = false;
      emit(OfferState(event.Offers));
      isChanged = true;
    });

    on<AddOffer>((event, emit) async {
      isChanged = false;
      if (event.offer.startDate.isAfter(event.offer.endDate)) {
        Toaster.showFailedToast(event.context,
            AppLocalizations.of(event.context)!.admin_offer_bad_date);
      } else {
        await OfferService.addOfferToSpecificEstablishment(event.offer)
            .then((value) {
          if (value) {
            currentOffers.add(event.offer);
            Toaster.showSuccessToast(event.context,
                AppLocalizations.of(event.context)!.admin_offer_added);
          } else {
            Toaster.showFailedToast(event.context,
                AppLocalizations.of(event.context)!.admin_offer_cant_add);
          }
        }).whenComplete(() => emit(OfferState(currentOffers)));
        isChanged = true;
      }
    });

    on<DeleteOffer>((event, emit) async {
      isChanged = false;
      await OfferService.deleteOfferFromSpecificEstablishment(event.offer.title)
          .then((value) {
        if (value) {
          currentOffers.removeWhere((e) => e.title == event.offer.title);
          Toaster.showSuccessToast(event.context,
              AppLocalizations.of(event.context)!.admin_offer_deleted_message);
        } else {
          Toaster.showFailedToast(
              event.context, AppLocalizations.of(event.context)!.delete_error);
        }
      }).whenComplete(() => emit(OfferState(currentOffers)));
      isChanged = true;
    });
  }

  bool getConnexionStatus() {
    return isChanged;
  }
}

class OfferState {
  final List<Offer> OfferList;

  const OfferState(this.OfferList);

  List<Object?> get props => [OfferList];
}

class InitialOfferState extends OfferState {
  const InitialOfferState(super.OfferList);
}

class OfferEvent {
  const OfferEvent();

  List<Offer> get props => [];
}

class OfferALL extends OfferEvent {
  final String establishmentName;
  const OfferALL(this.establishmentName);
}

class OfferManuallySet extends OfferEvent {
  final List<Offer> Offers;

  const OfferManuallySet(this.Offers);
}

class OfferFilterByCategory extends OfferEvent {
  final String category;

  const OfferFilterByCategory(this.category);
}

class OfferFilterByKeyword extends OfferEvent {
  final String keyword;

  const OfferFilterByKeyword(this.keyword);
}

class AddOffer extends OfferEvent {
  final Offer offer;
  final BuildContext context;

  const AddOffer(this.offer, this.context);
}

class DeleteOffer extends OfferEvent {
  final Offer offer;
  final BuildContext context;

  const DeleteOffer(this.offer, this.context);
}
