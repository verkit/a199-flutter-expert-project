import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/get_top_rated_movies.dart';

part 'top_rated_movies_state.dart';

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;
  TopRatedMoviesCubit(this.getTopRatedMovies) : super(TopRatedMoviesInitial());

  Future<void> fetchTopRatedMovies() async {
    emit(TopRatedMoviesLoading());
    final result = await getTopRatedMovies.execute();

    result.fold(
      (failure) => emit(TopRatedMoviesError(failure.message)),
      (moviesData) => emit(TopRatedMoviesHasData(moviesData)),
    );
  }
}
