import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  final GetPopularMovies getPopularMovies;
  PopularMoviesCubit(this.getPopularMovies) : super(PopularMoviesInitial());

  Future<void> fetchPopularMovies() async {
    emit(PopularMoviesLoading());
    final result = await getPopularMovies.execute();

    result.fold(
      (failure) => emit(PopularMoviesError(failure.message)),
      (moviesData) => emit(PopularMoviesHasData(moviesData)),
    );
  }
}
