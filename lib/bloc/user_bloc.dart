import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:twins_front/services/user_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc(this.userService) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final completeUser = await UserService.getCompleteUserByUid(event.uid);
        if (completeUser != null) {
          emit(UserLoaded(completeUser));
        } else {
          emit(const UserError("User not found"));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final String uid;

  const LoadUser(this.uid);

  @override
  List<Object?> get props => [uid];
}

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final CompleteUser user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
