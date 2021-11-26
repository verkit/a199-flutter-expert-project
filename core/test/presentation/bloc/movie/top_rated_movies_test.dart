import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/movie/top_rated_movies/top_rated_movies_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesCubit topRatedTvsCubit;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedTvsCubit = TopRatedMoviesCubit(mockGetTopRatedMovies);
  });

  test('initial state should emit [Initial]', () {
    expect(topRatedTvsCubit.state, TopRatedMoviesInitial());
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

  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    'should get data from the usecases',
    build: () {
      when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      return topRatedTvsCubit;
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    verify: (cubit) => verify(mockGetTopRatedMovies.execute()),
    expect: () => [
      TopRatedMoviesLoading(),
      TopRatedMoviesHasData(tMovieList),
    ],
  );

  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvsCubit;
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    verify: (cubit) => verify(mockGetTopRatedMovies.execute()),
    expect: () => [
      TopRatedMoviesLoading(),
      TopRatedMoviesError('Server Failure'),
    ],
  );
}
