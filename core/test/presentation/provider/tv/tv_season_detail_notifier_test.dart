import 'package:core/data/models/tv/episode_model.dart';
import 'package:core/data/models/tv/season_detail_model.dart';
import 'package:core/domain/usecases/tv/get_tv_season_detail.dart';
import 'package:core/presentation/provider/tv/tv_season_detail_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_season_detail_notifier_test.mocks.dart';

@GenerateMocks([GetTvSeasonDetail])
void main() {
  late TvSeasonDetailNotifier provider;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;

  late int listenerCallCount;

  final tvId = 1;
  final seasonNumber = 1;

  final tEpisodeModel = EpisodeModel(
    airDate: '2021-12-14',
    episodeNumber: 1,
    id: 1,
    name: 'Episode 1',
    overview: 'overview',
    productionCode: '',
    seasonNumber: seasonNumber,
    stillPath: '/stillPath.jpg',
    voteAverage: 0.0,
    voteCount: 0,
  );

  final tSeasonDetail = SeasonDetailModel(
    airDate: '2021-10-12',
    episodes: [tEpisodeModel],
    id: 1,
    name: 'Season 1',
    overview: 'overview',
    posterPath: '/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg',
    seasonNumber: seasonNumber,
  );

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();

    provider = TvSeasonDetailNotifier(
      getTvSeasonDetail: mockGetTvSeasonDetail,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  void _arrangeUsecase() {
    when(mockGetTvSeasonDetail.execute(tvId, seasonNumber)).thenAnswer((_) async => Right(tSeasonDetail.toEntity()));
  }

  group('Get TvSeason Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeasonDetail(tvId, seasonNumber);
      // assert
      verify(mockGetTvSeasonDetail.execute(tvId, seasonNumber));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvSeasonDetail(tvId, seasonNumber);
      // assert
      expect(provider.state, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change TvSeason when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeasonDetail(tvId, seasonNumber);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.seasonDetail, tSeasonDetail.toEntity());
      expect(listenerCallCount, 2);
    });

    test('should show episodes when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeasonDetail(tvId, seasonNumber);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.seasonDetail.episodes, [tEpisodeModel.toEntity()]);
    });
  });

  test('should update error message when request in successful', () async {
    // arrange
    when(mockGetTvSeasonDetail.execute(tvId, seasonNumber)).thenAnswer((_) async => Left(ServerFailure('Failed')));
    // act
    await provider.fetchTvSeasonDetail(tvId, seasonNumber);
    // assert
    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Failed');
  });
}
