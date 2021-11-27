import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tvs_watchlist.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv/watchlist_tv_cubit.dart';

import '../../dummy_data/tv/dummy_objects.dart';
import 'watchlist_tv_test.mocks.dart';

@GenerateMocks([GetTvsWatchlist])
void main() {
  late WatchlistTvCubit watchlistTvCubit;
  late MockGetTvsWatchlist mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetTvsWatchlist();
    watchlistTvCubit = WatchlistTvCubit(mockGetWatchlistTvs);
  });

  test('initial state should emit [Initial]', () {
    expect(watchlistTvCubit.state, WatchlistTvsInitial());
  });

  blocTest<WatchlistTvCubit, WatchlistTvsState>(
    'should get data from the usecases',
    build: () {
      when(mockGetWatchlistTvs.execute()).thenAnswer((_) async => Right([testWatchlistTv]));
      return watchlistTvCubit;
    },
    act: (cubit) => cubit.fetchWatchlistTvs(),
    verify: (cubit) => verify(mockGetWatchlistTvs.execute()),
    expect: () => [
      WatchlistTvsLoading(),
      WatchlistTvsHasData([testWatchlistTv]),
    ],
  );

  blocTest<WatchlistTvCubit, WatchlistTvsState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetWatchlistTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistTvCubit;
    },
    act: (cubit) => cubit.fetchWatchlistTvs(),
    verify: (cubit) => verify(mockGetWatchlistTvs.execute()),
    expect: () => [
      WatchlistTvsLoading(),
      WatchlistTvsError('Server Failure'),
    ],
  );
}
