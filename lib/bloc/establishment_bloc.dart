import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:twins_front/services/establishments_service.dart';

class EstablishmentBloc extends Bloc<EstablishmentEvent, EstablishmentState> {
  static bool isChanged = false;
  EstablishmentService establishmentService = EstablishmentService();

  List<Establishment> currentEstablishments = List.empty();

  EstablishmentBloc() : super(EstablishmentState(List.empty())) {
    on<EstablishmentALL>((event, emit) async {
      isChanged = false;
      final List<Establishment> establishments =
      await establishmentService.getEstablishments();
      emit(EstablishmentState(establishments));
      currentEstablishments = establishments;
      isChanged = true;
    });

    on<EstablishmentManuallySet>((event, emit) async {
      isChanged = false;
      emit(EstablishmentState(event.establishments));
      isChanged = true;
    });

    on<EstablishmentFilterByCategory>((event, emit) async {
      final List<Establishment> establishments =currentEstablishments.where((establishment) {
        return establishment.categoryName == event.category;
      }).toList();
      emit(EstablishmentState(establishments));
      isChanged = true;
    });

    on<EstablishmentFilterByKeyword>((event, emit) async {
      isChanged = false;
      List<Establishment> filteredEstablishments =
      currentEstablishments.where((establishment) {
        return establishment.name.toLowerCase().contains(event.keyword.toLowerCase());
      }).toList();
      emit(EstablishmentState(filteredEstablishments));
      isChanged = true;
    });
  }

  bool getConnexionStatus() {
    return isChanged;
  }
}

class EstablishmentState {

  final List<Establishment> establishmentList;

  const EstablishmentState(this.establishmentList);

  List<Object?> get props => [establishmentList];
}

class InitialEstablishmentState extends EstablishmentState {
  const InitialEstablishmentState(super.establishmentList);
}

class EstablishmentEvent {
  const EstablishmentEvent();

  List<Establishment> get props => [];
}

class EstablishmentALL extends EstablishmentEvent {}

class EstablishmentManuallySet extends EstablishmentEvent {
  final List<Establishment> establishments;

  const EstablishmentManuallySet(this.establishments);
}


class EstablishmentFilterByCategory extends EstablishmentEvent {
  final String category;

  const EstablishmentFilterByCategory(this.category);
}


class EstablishmentFilterByKeyword extends EstablishmentEvent {
  final String keyword;

  const EstablishmentFilterByKeyword(this.keyword);
}

