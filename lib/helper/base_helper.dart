import 'package:equatable/equatable.dart';

enum StateStatus { initial, onLoading, success, failure }

const String HostAddress = 'http://192.168.137.1:8003/api';
const String HostImage = "http://192.168.137.1:8003/";
const String BaseAvatar =
    'https://user-images.githubusercontent.com/4462072/63714494-c4d9c880-c7f6-11e9-8940-5a9636ecba36.png';
const String FaceAvatar =
    'https://blogunik.com/wp-content/uploads/2018/01/Tatjana-Saphira-1.jpg';

class ApiObjectResponse extends Equatable {
  final int code;
  final dynamic data;
  final String message;

  ApiObjectResponse(
      {required this.code, required this.data, this.message = ''});
  @override
  List<Object?> get props => [code, data, message];
}
