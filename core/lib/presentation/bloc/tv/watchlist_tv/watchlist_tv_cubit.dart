import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tvs_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_tv_state.dart';

class WatchlistTvCubit extends Cubit<WatchlistTvsState> {
  final GetTvsWatchlist getWatchlistTvs;
  WatchlistTvCubit(this.getWatchlistTvs) : super(WatchlistTvsInitial());

  Future<void> fetchWatchlistTvs() async {
    emit(WatchlistTvsLoading());

    final result = await getWatchlistTvs.execute();
    result.fold(
      (failure) {
        emit(WatchlistTvsError(failure.message));
      },
      (tvsData) {
        emit(WatchlistTvsHasData(tvsData));
      },
    );
  }
}
