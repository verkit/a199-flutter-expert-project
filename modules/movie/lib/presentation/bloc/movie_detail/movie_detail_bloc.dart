import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/movie/movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetMovieWatchListStatus getWatchListStatus;
  final SaveMovieWatchlist saveWatchlist;
  final RemoveMovieWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState.initialState()) {
    on<LoadDetailMovie>(fetchMovieDetail);
    on<AddToWatchlist>(addWatchlist);
    on<RemoveFromWatchlist>(removeFromWatchlist);
  }

  Future<void> fetchMovieDetail(LoadDetailMovie event, Emitter<MovieDetailState> emit) async {
    emit(state.copyWith(status: MovieDetailStatus.loading));

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(event.id);
    final status = await loadWatchlistStatus(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          status: MovieDetailStatus.failure,
          message: failure.message,
        ));
      },
      (movie) {
        emit(state.copyWith(
          status: MovieDetailStatus.loading,
          movie: movie,
        ));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              status: MovieDetailStatus.failure,
              message: failure.message,
            ));
          },
          (movies) {
            emit(state.copyWith(
              status: MovieDetailStatus.success,
              recommendations: movies,
              addedInWatchlist: status,
            ));
          },
        );
      },
    );
  }

  Future<void> addWatchlist(AddToWatchlist event, Emitter<MovieDetailState> emit) async {
    final result = await saveWatchlist.execute(event.movie);
    final status = await loadWatchlistStatus(event.movie.id);

    await result.fold(
      (failure) async {
        emit(state.copyWith(
          status: MovieDetailStatus.failure,
          message: failure.message,
          addedInWatchlist: status,
        ));
      },
      (message) async {
        emit(state.copyWith(
          status: MovieDetailStatus.addToWatchlist,
          message: watchlistAddSuccessMessage,
          addedInWatchlist: status,
        ));
      },
    );
  }

  Future<void> removeFromWatchlist(RemoveFromWatchlist event, Emitter<MovieDetailState> emit) async {
    final result = await removeWatchlist.execute(event.movie);
    final status = await loadWatchlistStatus(event.movie.id);

    await result.fold(
      (failure) async {
        emit(state.copyWith(
          status: MovieDetailStatus.failure,
          message: failure.message,
          addedInWatchlist: status,
        ));
      },
      (message) async {
        emit(state.copyWith(
          status: MovieDetailStatus.removeFromWatchlist,
          message: watchlistRemoveSuccessMessage,
          addedInWatchlist: status,
        ));
      },
    );
  }

  Future<bool> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    return result;
  }
}
