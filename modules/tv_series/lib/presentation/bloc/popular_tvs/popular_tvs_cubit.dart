import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv_series/domain/usecases/get_popular_tvs.dart';

part 'popular_tvs_state.dart';

class PopularTvsCubit extends Cubit<PopularTvsState> {
  final GetPopularTvs getPopularTvs;
  PopularTvsCubit(this.getPopularTvs) : super(PopularTvsInitial());

  Future<void> fetchPopularTvs() async {
    emit(PopularTvsLoading());
    final result = await getPopularTvs.execute();

    result.fold(
      (failure) => emit(PopularTvsError(failure.message)),
      (tvsData) => emit(PopularTvsHasData(tvsData)),
    );
  }
}
