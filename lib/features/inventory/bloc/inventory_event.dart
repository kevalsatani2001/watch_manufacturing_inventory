import 'package:equatable/equatable.dart';

sealed class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class InventoryLoadRequested extends InventoryEvent {
  const InventoryLoadRequested();
}

final class InventoryItemChanged extends InventoryEvent {
  const InventoryItemChanged(this.itemName);

  final String? itemName;

  @override
  List<Object?> get props => <Object?>[itemName];
}

final class InventoryQuantityChanged extends InventoryEvent {
  const InventoryQuantityChanged(this.value);

  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

final class InventoryStockInRequested extends InventoryEvent {
  const InventoryStockInRequested();
}

final class InventoryStockOutRequested extends InventoryEvent {
  const InventoryStockOutRequested();
}

final class InventoryFilterItemChanged extends InventoryEvent {
  const InventoryFilterItemChanged(this.itemName);

  final String? itemName;

  @override
  List<Object?> get props => <Object?>[itemName];
}

final class InventoryFilterTxChanged extends InventoryEvent {
  const InventoryFilterTxChanged(this.tx);

  final String tx;

  @override
  List<Object?> get props => <Object?>[tx];
}

final class InventoryFilterFromDateChanged extends InventoryEvent {
  const InventoryFilterFromDateChanged(this.from);

  final DateTime? from;

  @override
  List<Object?> get props => <Object?>[from];
}

final class InventoryFilterToDateChanged extends InventoryEvent {
  const InventoryFilterToDateChanged(this.to);

  final DateTime? to;

  @override
  List<Object?> get props => <Object?>[to];
}

final class InventoryFilterReasonChanged extends InventoryEvent {
  const InventoryFilterReasonChanged(this.reason);

  final String reason;

  @override
  List<Object?> get props => <Object?>[reason];
}

final class InventoryClearFiltersRequested extends InventoryEvent {
  const InventoryClearFiltersRequested();
}

