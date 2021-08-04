part of 'barang_bloc.dart';

abstract class BarangState extends Equatable {
  const BarangState();
}

class BarangInitial extends BarangState {
  @override
  List<Object> get props => [];
}

class ListBarangState extends BarangState {
  final StateStatus status;
  final int code;
  final String message;
  final List<Barang> barang;

  const ListBarangState(
      {this.status = StateStatus.initial,
      this.code = 200,
      this.message = '',
      this.barang = const <Barang>[]});

  ListBarangState copyWith(
      {StateStatus? status, List<Barang>? barang, int? code, String? message}) {
    return ListBarangState(
        status: status ?? this.status,
        code: code ?? this.code,
        message: message ?? this.message,
        barang: barang ?? this.barang);
  }

  @override
  List<Object?> get props => [status, barang, code, message];
}
