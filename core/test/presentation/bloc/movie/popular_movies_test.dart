import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/presentation/bloc/movie/popular_movies/popular_movies_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesCubit popularMoviesCubit;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesCubit = PopularMoviesCubit(mockGetPopularMovies);
  });

  test('initial state should emit [Initial]', () {
    expect(popularMoviesCubit.state, PopularMoviesInitial());
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

  final tMovieList = <Movie>[tMovie];

  blocTest<PopularMoviesCubit, PopularMoviesState>(
    'should get data from the usecases',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      return popularMoviesCubit;
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    verify: (cubit) => verify(mockGetPopularMovies.execute()),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesHasData(tMovieList),
    ],
  );

  blocTest<PopularMoviesCubit, PopularMoviesState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesCubit;
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    verify: (cubit) => verify(mockGetPopularMovies.execute()),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesError('Server Failure'),
    ],
  );
}
