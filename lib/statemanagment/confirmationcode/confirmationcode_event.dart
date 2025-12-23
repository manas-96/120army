part of 'confirmationcode_bloc.dart';

sealed class ConfirmationcodeEvent extends Equatable {
  const ConfirmationcodeEvent();

  @override
  List<Object> get props => [];
}

final class ConfirmationcodeEventTrigger extends ConfirmationcodeEvent {
  final String user_id;
  const ConfirmationcodeEventTrigger(this.user_id);
  @override
  List<Object> get props => [user_id];
}
