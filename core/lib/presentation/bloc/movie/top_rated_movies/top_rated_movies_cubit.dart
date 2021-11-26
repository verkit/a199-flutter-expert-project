import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
