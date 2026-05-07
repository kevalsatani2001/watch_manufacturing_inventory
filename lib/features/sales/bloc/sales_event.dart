import 'package:equatable/equatable.dart';

sealed class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class SalesLoadRequested extends SalesEvent {
  const SalesLoadRequested();
}

final class SalesQuantityChanged extends SalesEvent {
  const SalesQuantityChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class SalesCreateOrderRequested extends SalesEvent {
  const SalesCreateOrderRequested();
}

