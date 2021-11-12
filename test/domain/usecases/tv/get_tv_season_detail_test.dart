import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/tv/episode_model.dart';
import 'package:ditonton/data/models/tv/season_detail_model.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeasonDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvSeasonDetail(mockTvRepository);
  });

  final tId = 1;
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

  test('should get tv session detail from the repository', () async {
    // arrange
    when(mockTvRepository.getTvSeasonDetail(tId, seasonNumber))
        .thenAnswer((_) async => Right(tSeasonDetail.toEntity()));
    // act
    final result = await usecase.execute(tId, seasonNumber);
    // assert
    expect(result, Right(tSeasonDetail.toEntity()));
  });
}
