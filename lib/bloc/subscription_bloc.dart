import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twins_front/services/subscription_service.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionService categoryService = SubscriptionService();
  SubscriptionBloc() : super(SubscriptionInitialState()) {
    on<LoadSubscription>((event, emit) async {
      emit(SubscriptionLoading());
      final (isSubscribed, subscription) =
          await SubscriptionService.getSubscriptionStatus();
      emit(SubscriptionLoaded(isSubscribed, subscription));

      emit(SubscriptionLoaded(isSubscribed, subscription));
    });
  }
}

class SubscriptionState {}

class SubscriptionInitialState extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final bool isSubscribed;
  final Subscription? subscription;

  SubscriptionLoaded(this.isSubscribed, this.subscription);
}

class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class LoadSubscription extends SubscriptionEvent {}
