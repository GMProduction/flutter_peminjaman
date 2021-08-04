import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:peminjaman/bloc/barang_bloc.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/model/barang.dart';

class BarangController {
  Future<ApiObjectResponse> _fetchListBarang() async {
    try {
      final response = await Dio().get('http://192.168.137.1:8000/api/barang');
      return ApiObjectResponse(
          code: response.data['status'],
          data: response.data['payload'],
          message: 'Success');
    } on DioError catch (e) {
      return ApiObjectResponse(
          code: 500, data: null, message: e.response!.statusMessage.toString());
    } on Exception catch (e) {
      return ApiObjectResponse(code: 500, data: null, message: e.toString());
    }
  }

  Future<ListBarangState> mapListBarangToState(
      ListBarangState state, String param) async {
    try {
      final ApiObjectResponse response = await _fetchListBarang();
      if (response.code != 200) {
        return state.copyWith(
            barang: [],
            status: StateStatus.failure,
            code: response.code,
            message: response.message);
      }
      final data = response.data as List;
      final List<Barang> barang = data.map((item) {
        final String image = item['image'] ?? '';
        return Barang(
            id: item['id'] as int,
            nama: item['nama_barang'] as String,
            qty: item['qty'] as int,
            image: image);
      }).toList();
      return state.copyWith(
          barang: barang,
          status: StateStatus.success,
          code: 200,
          message: 'Success');
    } catch (e) {
      return state.copyWith(
          status: StateStatus.failure,
          barang: [],
          code: 500,
          message: 'Error Convert To State ${e.toString()}');
    }
  }

  Future<ApiObjectResponse> _fetchListBarangByName(String param) async {
      try{
        final response = await Dio().get('http://192.168.137.1:8000/api/barang/cari/$param');
        return ApiObjectResponse(
            code: 200,
            data: response.data,
            message: 'Success');
      }on DioError catch (e) {
        return ApiObjectResponse(
            code: 500, data: null, message: e.response!.statusMessage.toString());
      } on Exception catch (e) {
        return ApiObjectResponse(code: 500, data: null, message: e.toString());
      }
  }

  Future<ListBarangState> mapListBarangByNameToState(
      ListBarangState state, String param) async {
    try {
      final ApiObjectResponse response = await _fetchListBarangByName(param);
      if (response.code != 200) {
        return state.copyWith(
            barang: [],
            status: StateStatus.failure,
            code: response.code,
            message: response.message);
      }
      final data = response.data as List;
      final List<Barang> barang = data.map((item) {
        final String image = item['image'] ?? '';
        return Barang(
            id: item['id'] as int,
            nama: item['nama_barang'] as String,
            qty: item['qty'] as int,
            image: image);
      }).toList();
      return state.copyWith(
          barang: barang,
          status: StateStatus.success,
          code: 200,
          message: 'Success');
    } catch (e) {
      return state.copyWith(
          status: StateStatus.failure,
          barang: [],
          code: 500,
          message: 'Error Convert To State ${e.toString()}');
    }
  }


}
