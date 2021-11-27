import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/get_now_playing_movies.dart';

part 'now_playing_movie_state.dart';

class NowPlayingMovieCubit extends Cubit<NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  NowPlayingMovieCubit({required this.getNowPlayingMovies}) : super(NowPlayingMovieInitial());

  Future<void> fetchNowPlayingMovies() async {
    emit(NowPlayingMovieLoading());

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(NowPlayingMovieError(failure.message)),
      (moviesData) => emit(NowPlayingMovieHasData(moviesData)),
    );
  }
}
