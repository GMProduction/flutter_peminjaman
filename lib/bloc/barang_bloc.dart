import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peminjaman/controller/barang_controller.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/model/barang.dart';

part 'barang_event.dart';

part 'barang_state.dart';

class BarangBloc extends Bloc<BarangEvent, ListBarangState> {
  BarangBloc() : super(const ListBarangState());
  BarangController _barangController = BarangController();

  @override
  Stream<ListBarangState> mapEventToState(
    BarangEvent event,
  ) async* {
    yield ListBarangState().copyWith(
        status: StateStatus.onLoading,
        barang: [],
        code: 200,
        message: 'Sedang Mengunduh Data..');

    if (event is FetchListBarang) {
      yield await _barangController.mapListBarangToState(state, '');
    } else if (event is FetchListBarangByName) {
      print("fetch list by name");
      yield await _barangController.mapListBarangByNameToState(state, event.param);
    }
  }
}
