import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:core/domain/usecases/tv/get_popular_tvs.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:core/presentation/bloc/tv/now_playing_tv/now_playing_tv_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late NowPlayingTvCubit tvListCubit;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    tvListCubit = NowPlayingTvCubit(mockGetNowPlayingTvs);
  });

  test('initial state should emit [Initial]', () {
    expect(tvListCubit.state, NowPlayingTvInitial());
  });

  final tTv = Tv(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    backdropPath: 'backdropPath',
    overview: 'overview',
    firstAirDate: 'firstAirDate',
    voteAverage: 1.0,
    voteCount: 1,
    genreIds: [1, 2, 3],
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    popularity: 1.0,
  );

  final tTvList = <Tv>[tTv];

  blocTest<NowPlayingTvCubit, NowPlayingTvState>(
    'should get data from the usecases',
    build: () {
      when(mockGetNowPlayingTvs.execute()).thenAnswer((_) async => Right(tTvList));
      return tvListCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingTvs(),
    verify: (cubit) => verify(mockGetNowPlayingTvs.execute()),
    expect: () => [
      NowPlayingTvLoading(),
      NowPlayingTvHasData(tTvList),
    ],
  );

  blocTest<NowPlayingTvCubit, NowPlayingTvState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetNowPlayingTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvListCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingTvs(),
    verify: (cubit) => verify(mockGetNowPlayingTvs.execute()),
    expect: () => [
      NowPlayingTvLoading(),
      NowPlayingTvError('Server Failure'),
    ],
  );
}
