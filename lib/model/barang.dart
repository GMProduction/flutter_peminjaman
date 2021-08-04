import 'package:equatable/equatable.dart';

class Barang extends Equatable {

  final int id;
  final String nama;
  final int qty;
  final String image;

  Barang({required this.id, required this.nama, required this.qty, required this.image});
  @override
  // TODO: implement props
  List<Object?> get props => [id, nama, qty, image];

}