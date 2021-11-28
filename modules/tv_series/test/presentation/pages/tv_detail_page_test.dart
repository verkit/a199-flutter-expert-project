import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv/season.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/domain/entities/tv/tv_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/tv/dummy_objects.dart';

class MockBloc extends Mock implements TvDetailBloc {}

class TvDetailEventFake extends Fake implements TvDetailEvent {}

class TvDetailStateFake extends Fake implements TvDetailState {}

void main() {
  late TvDetailBloc bloc;

  setUpAll(() {
    registerFallbackValue(TvDetailEventFake());
    registerFallbackValue(TvDetailStateFake());
  });

  setUp(() {
    bloc = MockBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Circullar progress should display when still loading', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(TvDetailState(status: TvDetailStatus.loading));
    when(() => bloc.stream).thenAnswer((_) => const Stream.empty());

    final circularProgress = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(circularProgress, findsOneWidget);
  });
  testWidgets('Message should display when error', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(TvDetailState(status: TvDetailStatus.failure, message: 'Error'));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(TvDetailState(status: TvDetailStatus.failure, message: 'Error')),
    );

    final message = find.text("Error");

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(message, findsOneWidget);
  });
  testWidgets('Watchlist button should display add icon when tv not added to watchlist', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(TvDetailState(
      status: TvDetailStatus.success,
      tv: testTvDetail,
      recommendations: <Tv>[],
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(TvDetailState(
        status: TvDetailStatus.success,
        tv: testTvDetail,
        recommendations: <Tv>[],
      )),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should dispay check icon when tv is added to wathclist', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(TvDetailState(
      tv: testTvDetail,
      status: TvDetailStatus.success,
      recommendations: <Tv>[],
      addedInWatchlist: true,
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(TvDetailState(
        tv: testTvDetail,
        status: TvDetailStatus.success,
        recommendations: <Tv>[],
        addedInWatchlist: true,
      )),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should display Snackbar when added to watchlist', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(TvDetailState(
      tv: testTvDetail,
      recommendations: <Tv>[],
      status: TvDetailStatus.addToWatchlist,
      message: TvDetailBloc.watchlistAddSuccessMessage,
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(TvDetailState(
        tv: testTvDetail,
        recommendations: <Tv>[],
        status: TvDetailStatus.addToWatchlist,
        message: TvDetailBloc.watchlistAddSuccessMessage,
      )),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(TvDetailBloc.watchlistAddSuccessMessage), findsOneWidget);
  });

  testWidgets('Watchlist button should display Snackbar when remove from watchlist', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(TvDetailState(
      tv: testTvDetail,
      recommendations: <Tv>[],
      addedInWatchlist: true,
      status: TvDetailStatus.removeFromWatchlist,
      message: TvDetailBloc.watchlistRemoveSuccessMessage,
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(TvDetailState(
        tv: testTvDetail,
        recommendations: <Tv>[],
        addedInWatchlist: true,
        status: TvDetailStatus.removeFromWatchlist,
        message: TvDetailBloc.watchlistRemoveSuccessMessage,
      )),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(TvDetailBloc.watchlistRemoveSuccessMessage), findsOneWidget);
  });

  testWidgets('Page should display icon error when season image poster is null', (tester) async {
    final _testTvDetail = TvDetail(
      backdropPath: 'backdropPath',
      episodeRunTime: [1, 2, 3],
      firstAirDate: '2012-01-01',
      genres: [Genre(id: 1, name: 'Action')],
      homepage: 'homepage',
      id: 1,
      inProduction: false,
      languages: ['en'],
      lastAirDate: '2021-01-01',
      name: 'name',
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1.0,
      posterPath: 'null',
      seasons: [
        Season(
          airDate: '2021-01-01',
          episodeCount: 1,
          id: 1,
          name: 'name',
          overview: 'overview',
          posterPath: null,
          seasonNumber: 1,
        )
      ],
      status: 'status',
      tagline: 'tagline',
      type: 'type',
      voteAverage: 1,
      voteCount: 1,
    );

    when(() => bloc.state).thenReturn(TvDetailState(
      tv: _testTvDetail,
      status: TvDetailStatus.success,
      recommendations: <Tv>[],
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(TvDetailState(
        tv: _testTvDetail,
        status: TvDetailStatus.success,
        recommendations: <Tv>[],
      )),
    );

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('Page should display ListView when recommendation data is loaded', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(TvDetailState(
      tv: testTvDetail,
      status: TvDetailStatus.success,
      recommendations: [testTv],
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(TvDetailState(
        tv: testTvDetail,
        status: TvDetailStatus.success,
        recommendations: [testTv],
      )),
    );

    final listViewFinder = find.byKey(Key('_buildTvRecommendations'));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });
}
