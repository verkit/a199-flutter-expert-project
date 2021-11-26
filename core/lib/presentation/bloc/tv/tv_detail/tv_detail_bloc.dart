import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:core/domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/tv/save_tv_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvWatchListStatus getWatchListStatus;
  final SaveTvWatchlist saveWatchlist;
  final RemoveTvWatchlist removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvDetailState.initialState()) {
    on<LoadDetailTv>(fetchTvDetail);
    on<AddToWatchlist>(addWatchlist);
    on<RemoveFromWatchlist>(removeFromWatchlist);
  }

  Future<void> fetchTvDetail(LoadDetailTv event, Emitter<TvDetailState> emit) async {
    emit(state.copyWith(status: TvDetailStatus.loading));

    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);
    final status = await loadWatchlistStatus(event.id);
    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          status: TvDetailStatus.failure,
          message: failure.message,
        ));
      },
      (tv) {
        emit(state.copyWith(
          status: TvDetailStatus.loading,
          tv: tv,
        ));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              status: TvDetailStatus.failure,
              message: failure.message,
            ));
          },
          (tvs) {
            emit(state.copyWith(
              status: TvDetailStatus.success,
              recommendations: tvs,
              addedInWatchlist: status,
            ));
          },
        );
      },
    );
  }

  Future<void> addWatchlist(AddToWatchlist event, Emitter<TvDetailState> emit) async {
    final result = await saveWatchlist.execute(event.tv);
    final status = await loadWatchlistStatus(event.tv.id);

    await result.fold(
      (failure) async {
        emit(state.copyWith(status: TvDetailStatus.failure, message: failure.message, addedInWatchlist: status));
      },
      (message) async {
        emit(state.copyWith(status: TvDetailStatus.addToWatchlist, message: message, addedInWatchlist: status));
      },
    );
  }

  Future<void> removeFromWatchlist(RemoveFromWatchlist event, Emitter<TvDetailState> emit) async {
    final result = await removeWatchlist.execute(event.tv);
    final status = await loadWatchlistStatus(event.tv.id);

    await result.fold(
      (failure) async {
        emit(state.copyWith(status: TvDetailStatus.failure, message: failure.message, addedInWatchlist: status));
      },
      (message) async {
        emit(state.copyWith(status: TvDetailStatus.removeFromWatchlist, message: message, addedInWatchlist: status));
      },
    );
  }

  Future<bool> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    return result;
  }
}
