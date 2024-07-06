import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/subscription_service.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionService categoryService = SubscriptionService();
  SubscriptionBloc() : super(SubscriptionInitialState()) {

    on<LoadSubscription>((event, emit) async {
      emit(SubscriptionLoading());
      bool subscriptionStatus =  await SubscriptionService.isSubscribed();
      emit(SubscriptionLoaded(subscriptionStatus));
    });
  }
}

class SubscriptionState {}

class SubscriptionInitialState extends SubscriptionState {}
class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final bool isSubscribed;

  SubscriptionLoaded(this.isSubscribed);
}


class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class LoadSubscription extends SubscriptionEvent {}
