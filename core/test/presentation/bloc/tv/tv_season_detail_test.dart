import 'package:bloc_test/bloc_test.dart';
import 'package:core/data/models/tv/episode_model.dart';
import 'package:core/data/models/tv/season_detail_model.dart';
import 'package:core/domain/usecases/tv/get_tv_season_detail.dart';
import 'package:core/presentation/bloc/tv/tv_season_detail/tv_season_detail_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_season_detail_test.mocks.dart';

@GenerateMocks([GetTvSeasonDetail])
void main() {
  late TvSeasonDetailCubit tvSeasonDetailCubit;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;

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
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    tvSeasonDetailCubit = TvSeasonDetailCubit(mockGetTvSeasonDetail);
  });

  blocTest<TvSeasonDetailCubit, TvSeasonDetailState>(
    'should get data from the usecases',
    build: () {
      when(mockGetTvSeasonDetail.execute(tvId, seasonNumber)).thenAnswer((_) async => Right(tSeasonDetail.toEntity()));
      return tvSeasonDetailCubit;
    },
    act: (cubit) => cubit.fetchTvSeasonDetail(tvId, seasonNumber),
    verify: (cubit) => verify(mockGetTvSeasonDetail.execute(tvId, seasonNumber)),
    expect: () => [
      TvSeasonDetailLoading(),
      TvSeasonDetailHasData(tSeasonDetail.toEntity()),
    ],
  );

  blocTest<TvSeasonDetailCubit, TvSeasonDetailState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetTvSeasonDetail.execute(tvId, seasonNumber))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvSeasonDetailCubit;
    },
    act: (cubit) => cubit.fetchTvSeasonDetail(tvId, seasonNumber),
    verify: (cubit) => verify(mockGetTvSeasonDetail.execute(tvId, seasonNumber)),
    expect: () => [
      TvSeasonDetailLoading(),
      TvSeasonDetailError('Server Failure'),
    ],
  );
}
