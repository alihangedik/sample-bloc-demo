import 'package:demo_bloc/cats_repository.dart';
import 'package:demo_bloc/cats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatsCubit extends Cubit<CatsState> {
  final CatsRepository _catsRepository;
  CatsCubit(this._catsRepository) : super(CatsInitial());

  Future<void> getCats() async {
    try {
      emit(CatsLoading());
      Future.delayed(Duration(microseconds: 500));
      final response = await _catsRepository.getCats();
      emit(CatsCompleted(response));
    } on NetworkError catch (e) {
      emit(CatsError("${e.statusCode + " " + e.message}"));
    }
  }
}
