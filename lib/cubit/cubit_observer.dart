import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class StateObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} $change');
    super.onChange(cubit, change);
  }
}
