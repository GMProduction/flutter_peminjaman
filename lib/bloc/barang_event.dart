part of 'barang_bloc.dart';

abstract class BarangEvent extends Equatable {
  const BarangEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchListBarang extends BarangEvent {
  @override
  List<Object?> get props => [];
}

class FetchListBarangByName extends BarangEvent {
  final String param;

  const FetchListBarangByName({required this.param});

  @override
  // TODO: implement props
  List<Object?> get props => [param];
}
