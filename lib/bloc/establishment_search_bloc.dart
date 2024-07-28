import 'package:bloc/bloc.dart';
import 'package:twins_front/services/establishments_service.dart';

import '../utils/shared_data.dart';

class EstablishmentSearchBloc extends Bloc<EstablishmentSearchEvent, EstablishmentSearchState> {
  EstablishmentSearchBloc() : super(EstablishmentSearchInitialState()) {
    on<LoadEstablishments>((event, emit) async {
      emit(EstablishmentSearchLoading());

      await SharedData.allEstablishmentsInitializationDone;

      emit(EstablishmentSearchLoaded(SharedData.allEstablishments));
    });

    on<EstablishmentSearchFilterByKeyword>((event, emit) async {
      emit(EstablishmentSearchLoading());
      List<Establishment> filteredEstablishments =
          SharedData.allEstablishments.where((establishment) {
        return establishment.name
                .toLowerCase()
                .contains(event.keyword.toLowerCase()) ||
            establishment.categoryName!
                .toLowerCase()
                .contains(event.keyword.toLowerCase());
      }).toList();
      emit(EstablishmentSearchLoaded(filteredEstablishments));
    });
  }
}

class EstablishmentSearchState {}

class EstablishmentSearchInitialState extends EstablishmentSearchState {}

class EstablishmentSearchLoading extends EstablishmentSearchState {}

class EstablishmentSearchLoaded extends EstablishmentSearchState {
  final List<Establishment> establishmentList;

  EstablishmentSearchLoaded(this.establishmentList);
}

class EstablishmentSearchEvent {
  const EstablishmentSearchEvent();

  List<Establishment> get props => [];
}

class EstablishmentSearchFilterByKeyword extends EstablishmentSearchEvent {
  final String keyword;

  const EstablishmentSearchFilterByKeyword(this.keyword);
}

class LoadEstablishments extends EstablishmentSearchEvent {}
