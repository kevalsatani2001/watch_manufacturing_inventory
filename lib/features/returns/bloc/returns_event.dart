import 'package:equatable/equatable.dart';

sealed class ReturnsEvent extends Equatable {
  const ReturnsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class ReturnsLoadRequested extends ReturnsEvent {
  const ReturnsLoadRequested();
}

final class ReturnsQuantityChanged extends ReturnsEvent {
  const ReturnsQuantityChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class ReturnsAddBackRequested extends ReturnsEvent {
  const ReturnsAddBackRequested();
}

final class ReturnsDismantleRequested extends ReturnsEvent {
  const ReturnsDismantleRequested();
}

