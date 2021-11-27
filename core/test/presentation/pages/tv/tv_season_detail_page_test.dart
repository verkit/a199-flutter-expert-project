import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/data/models/tv/episode_model.dart';
import 'package:core/data/models/tv/season_detail_model.dart';
import 'package:core/presentation/bloc/tv/tv_season_detail/tv_season_detail_cubit.dart';
import 'package:core/presentation/pages/tv/tv_season_detail_page.dart';
import 'package:core/presentation/widgets/episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_season_detail_page_test.mocks.dart';

@GenerateMocks([TvSeasonDetailCubit])
void main() {
  late MockTvSeasonDetailCubit mockCubit;

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
    mockCubit = MockTvSeasonDetailCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeasonDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display loading when loading', (tester) async {
    when(mockCubit.state).thenReturn(TvSeasonDetailLoading());
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(TvSeasonDetailPage(
      id: tvId,
      seasonNumber: seasonNumber,
    )));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display detail', (tester) async {
    when(mockCubit.state).thenReturn(TvSeasonDetailHasData(tSeasonDetail.toEntity()));
    when(mockCubit.stream).thenAnswer((_) => Stream.value(TvSeasonDetailHasData(tSeasonDetail.toEntity())));

    await tester.pumpWidget(_makeTestableWidget(TvSeasonDetailPage(
      id: tvId,
      seasonNumber: seasonNumber,
    )));

    expect(find.text('Season 1'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(find.byType(EpisodeCard), findsNWidgets(tSeasonDetail.episodes.length));
  });

  testWidgets('Page should display error when error', (tester) async {
    when(mockCubit.state).thenReturn(TvSeasonDetailError('Error Message'));
    when(mockCubit.stream).thenAnswer((_) => Stream.value(TvSeasonDetailError('Error Message')));

    await tester.pumpWidget(_makeTestableWidget(TvSeasonDetailPage(
      id: tvId,
      seasonNumber: seasonNumber,
    )));

    expect(find.text("Error Message"), findsOneWidget);
  });
}
