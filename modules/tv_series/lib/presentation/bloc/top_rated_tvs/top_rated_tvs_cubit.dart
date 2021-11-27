import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';

part 'top_rated_tvs_state.dart';

class TopRatedTvsCubit extends Cubit<TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;
  TopRatedTvsCubit(this.getTopRatedTvs) : super(TopRatedTvsInitial());

  Future<void> fetchTopRatedTvs() async {
    emit(TopRatedTvsLoading());
    final result = await getTopRatedTvs.execute();

    result.fold(
      (failure) => emit(TopRatedTvsError(failure.message)),
      (tvsData) => emit(TopRatedTvsHasData(tvsData)),
    );
  }
}
