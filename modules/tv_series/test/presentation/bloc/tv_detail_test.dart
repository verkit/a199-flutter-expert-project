import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tv_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv_series/domain/usecases/remove_tv_watchlist.dart';
import 'package:tv_series/domain/usecases/save_tv_watchlist.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';

import '../../dummy_data/tv/dummy_objects.dart';
import 'tv_detail_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetTvWatchListStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvWatchListStatus mockGetWatchlistStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;

  final tId = 1;

  final tTv = Tv(
    id: tId,
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

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetTvWatchListStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveTvWatchlist,
      removeWatchlist: mockRemoveTvWatchlist,
    );
  });

  test('initial state should emit [Initial]', () {
    expect(tvDetailBloc.state, TvDetailState.initialState());
  });

  group('Get Tv Detail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should get data from the usecases and get the watchlist status',
      build: () {
        when(mockGetTvDetail.execute(tId)).thenAnswer((_) async => Right(testTvDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetTvRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvList));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(LoadDetailTv(tId)),
      expect: () => [
        TvDetailState(
          status: TvDetailStatus.loading,
          addedInWatchlist: false,
          tv: null,
          recommendations: null,
          message: null,
        ),
        TvDetailState(
          status: TvDetailStatus.loading,
          addedInWatchlist: false,
          tv: testTvDetail,
          recommendations: null,
          message: null,
        ),
        TvDetailState(
          status: TvDetailStatus.success,
          addedInWatchlist: true,
          recommendations: tTvList,
          tv: testTvDetail,
          message: null,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        when(mockGetTvRecommendations.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(LoadDetailTv(tId)),
      expect: () => [
        const TvDetailState(
          status: TvDetailStatus.loading,
          addedInWatchlist: false,
          tv: null,
          recommendations: null,
          message: null,
        ),
        const TvDetailState(
          status: TvDetailStatus.failure,
          addedInWatchlist: false,
          tv: null,
          recommendations: null,
          message: "Server Failure",
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvDetail.id)).thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(testTvDetail.id));
      },
      expect: () => [
        TvDetailState(
          status: TvDetailStatus.addToWatchlist,
          addedInWatchlist: true,
          recommendations: null,
          tv: null,
          message: 'Added to Watchlist',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should show error when add watchlist failed',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testTvDetail.id)).thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(testTvDetail.id));
      },
      expect: () => [
        TvDetailState(
          status: TvDetailStatus.failure,
          addedInWatchlist: false,
          recommendations: null,
          tv: null,
          message: 'Failed',
        ),
      ],
    );
    blocTest<TvDetailBloc, TvDetailState>(
      'should update watchlist status when remove watchlist success',
      build: () {
        when(mockRemoveTvWatchlist.execute(testTvDetail)).thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvDetail.id)).thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState(
          status: TvDetailStatus.removeFromWatchlist,
          addedInWatchlist: false,
          recommendations: null,
          tv: null,
          message: 'Removed from Watchlist',
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should show error when remove watchlist failed',
      build: () {
        when(mockRemoveTvWatchlist.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testTvDetail.id)).thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(testTvDetail.id));
      },
      expect: () => [
        TvDetailState(
          status: TvDetailStatus.failure,
          addedInWatchlist: true,
          recommendations: null,
          tv: null,
          message: 'Failed',
        ),
      ],
    );
  });
}
