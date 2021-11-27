import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movies_state.dart';

class WatchlistMoviesCubit extends Cubit<WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;
  WatchlistMoviesCubit(this.getWatchlistMovies) : super(WatchlistMoviesInitial());

  Future<void> fetchWatchlistMovies() async {
    emit(WatchlistMoviesLoading());

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (moviesData) {
        emit(WatchlistMoviesHasData(moviesData));
      },
    );
  }
}
