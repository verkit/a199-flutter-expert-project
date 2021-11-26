import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:core/presentation/bloc/movie/wathclist_movie/watchlist_movies_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesCubit watchlistMoviesCubit;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesCubit = WatchlistMoviesCubit(mockGetWatchlistMovies);
  });

  test('initial state should emit [Initial]', () {
    expect(watchlistMoviesCubit.state, WatchlistMoviesInitial());
  });

  blocTest<WatchlistMoviesCubit, WatchlistMoviesState>(
    'should get data from the usecases',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistMoviesCubit;
    },
    act: (cubit) => cubit.fetchWatchlistMovies(),
    verify: (cubit) => verify(mockGetWatchlistMovies.execute()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesHasData([testWatchlistMovie]),
    ],
  );

  blocTest<WatchlistMoviesCubit, WatchlistMoviesState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMoviesCubit;
    },
    act: (cubit) => cubit.fetchWatchlistMovies(),
    verify: (cubit) => verify(mockGetWatchlistMovies.execute()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesError('Server Failure'),
    ],
  );
}
