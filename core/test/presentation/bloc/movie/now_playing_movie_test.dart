import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/movie/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_movie_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late NowPlayingMovieCubit movieListCubit;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    movieListCubit = NowPlayingMovieCubit(
      getNowPlayingMovies: mockGetNowPlayingMovies,
    );
  });

  test('initial state should emit [Initial]', () {
    expect(movieListCubit.state, NowPlayingMovieInitial());
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tNowPlayingMovie = <Movie>[tMovie];

  blocTest<NowPlayingMovieCubit, NowPlayingMovieState>(
    'should get data from the usecases',
    build: () {
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(tNowPlayingMovie));
      return movieListCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingMovies(),
    verify: (cubit) => verify(mockGetNowPlayingMovies.execute()),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieHasData(tNowPlayingMovie),
    ],
  );

  blocTest<NowPlayingMovieCubit, NowPlayingMovieState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieListCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingMovies(),
    verify: (cubit) => verify(mockGetNowPlayingMovies.execute()),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieError('Server Failure'),
    ],
  );
}
