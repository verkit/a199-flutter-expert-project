import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/usecases/search_movies.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies _searchMovies;
  MovieSearchBloc(this._searchMovies) : super(MovieSearchInitial()) {
    on<OnQueryChanged>(
      searchMovies,
      transformer: debounceRestartable(debounceTime),
    );
  }

  Future<void> searchMovies(OnQueryChanged event, Emitter<MovieSearchState> emit) async {
    final query = event.query;
    emit(MovieSearchLoading());

    final result = await _searchMovies.execute(query);

    result.fold(
      (failure) {
        emit(MovieSearchError(failure.message));
      },
      (data) {
        if (data.isEmpty) {
          emit(MovieSearchEmpty());
        } else {
          emit(MovieSearchHasData(data));
        }
      },
    );
  }

  // How long to wait after the last keypress event
  static const debounceTime = Duration(milliseconds: 500);

  EventTransformer<OnQueryChanged> debounceRestartable<OnQueryChanged>(
    Duration duration,
  ) {
    // This feeds the debounced event stream to restartable() and returns that
    // as a transformer.
    return (events, mapper) => restartable<OnQueryChanged>().call(
          events.debounceTime(duration),
          mapper,
        );
  }
}
