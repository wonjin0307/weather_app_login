import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/models/user_models.dart';
// 변경된 정보 및 상태를 관리하는 Cubit
// User 에 대한 정보를 관리하고 전달 한다.
class UserCubit extends Cubit<User> {
  UserCubit(super.initialState);
}