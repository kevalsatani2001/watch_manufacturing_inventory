import 'package:equatable/equatable.dart';

sealed class ProductionEvent extends Equatable {
  const ProductionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class ProductionQuantityChanged extends ProductionEvent {
  const ProductionQuantityChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class ProductionAssembleRequested extends ProductionEvent {
  const ProductionAssembleRequested();
}

final class ProductionLoadRequested extends ProductionEvent {
  const ProductionLoadRequested();
}
