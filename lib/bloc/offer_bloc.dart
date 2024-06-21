import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/services/offers_service.dart';
import 'package:twins_front/services/establishments_service.dart';

import '../utils/toaster.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  OffersService OfferService = OffersService();

  List<Offer> currentOffers = List.empty();

  OfferBloc() : super(OfferState()) {
    on<OfferALL>((event, emit) async {
      emit(OfferLoading());
      final List<Offer> offers =
          await OfferService.getOffersByEstablishment(event.establishmentName);
      emit(OfferLoaded(offers));
      currentOffers = offers;
    });

    on<AddOffer>((event, emit) async {
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
        }).whenComplete(() => emit(OfferLoaded(currentOffers)));
      }
    });

    on<DeleteOffer>((event, emit) async {
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
      }).whenComplete(() => emit(OfferLoaded(currentOffers)));
    });
  }
}

class OfferState {}

class OfferLoading extends OfferState {}

class OfferLoaded extends OfferState {
  final List<Offer> offerList;

  OfferLoaded(this.offerList);
}

class OfferEvent {
  const OfferEvent();

  List<Offer> get props => [];
}

class OfferALL extends OfferEvent {
  final String establishmentName;
  const OfferALL(this.establishmentName);
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
