import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
