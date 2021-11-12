import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/models/tv/episode_model.dart';
import 'package:ditonton/data/models/tv/season_detail_model.dart';
import 'package:ditonton/presentation/pages/tv/tv_season_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_season_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'tv_season_detail_page_test.mocks.dart';

@GenerateMocks([TvSeasonDetailNotifier])
void main() {
  late MockTvSeasonDetailNotifier mockNotifier;

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
    mockNotifier = MockTvSeasonDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeasonDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display detail', (tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.seasonDetail).thenReturn(tSeasonDetail.toEntity());

    await tester.pumpWidget(_makeTestableWidget(TvSeasonDetailPage(
      id: tvId,
      seasonNumber: seasonNumber,
    )));

    expect(find.text('Season 1'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(find.byType(EpisodeCard), findsNWidgets(tSeasonDetail.episodes.length));
  });

  testWidgets('Page should display loading when loading', (tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    await tester.pumpWidget(_makeTestableWidget(TvSeasonDetailPage(
      id: tvId,
      seasonNumber: seasonNumber,
    )));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error when error', (tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn("Error");

    await tester.pumpWidget(_makeTestableWidget(TvSeasonDetailPage(
      id: tvId,
      seasonNumber: seasonNumber,
    )));

    expect(find.text("Error"), findsOneWidget);
  });
}
