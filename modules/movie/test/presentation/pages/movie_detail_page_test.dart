import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

import '../../dummy_data/dummy_objects.dart';

class MockBloc extends Mock implements MovieDetailBloc {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

// @GenerateMocks([MovieDetailBloc])
void main() {
  late MovieDetailBloc bloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });

  setUp(() {
    bloc = MockBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
      ),
    );
  }

  testWidgets('Circullar progress should display when still loading', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(MovieDetailState(status: MovieDetailStatus.loading));
    when(() => bloc.stream).thenAnswer((_) => const Stream.empty());

    final circularProgress = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(circularProgress, findsOneWidget);
  });
  testWidgets('Message should display when error', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(MovieDetailState(status: MovieDetailStatus.failure, message: 'Error'));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailState(status: MovieDetailStatus.failure, message: 'Error')),
    );

    final message = find.text("Error");

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(message, findsOneWidget);
  });

  testWidgets('Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(MovieDetailState(
      status: MovieDetailStatus.success,
      movie: testMovieDetail,
      recommendations: <Movie>[],
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailState(
        status: MovieDetailStatus.success,
        movie: testMovieDetail,
        recommendations: <Movie>[],
      )),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(MovieDetailState(
      movie: testMovieDetail,
      status: MovieDetailStatus.success,
      recommendations: <Movie>[],
      addedInWatchlist: true,
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailState(
        movie: testMovieDetail,
        status: MovieDetailStatus.success,
        recommendations: <Movie>[],
        addedInWatchlist: true,
      )),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should display Snackbar when added to watchlist', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(MovieDetailState(
      movie: testMovieDetail,
      recommendations: <Movie>[],
      status: MovieDetailStatus.addToWatchlist,
      message: MovieDetailBloc.watchlistAddSuccessMessage,
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailState(
        movie: testMovieDetail,
        recommendations: <Movie>[],
        status: MovieDetailStatus.addToWatchlist,
        message: MovieDetailBloc.watchlistAddSuccessMessage,
      )),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(MovieDetailBloc.watchlistAddSuccessMessage), findsOneWidget);
  });

  testWidgets('Watchlist button should display Text error when added to watchlist failed', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(MovieDetailState(
      movie: testMovieDetail,
      recommendations: <Movie>[],
      status: MovieDetailStatus.failure,
      message: 'Error',
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailState(
        movie: testMovieDetail,
        recommendations: <Movie>[],
        status: MovieDetailStatus.failure,
        message: 'Error',
      )),
    );

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Watchlist button should display Snackbar when remove from watchlist', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(
      MovieDetailState(
        movie: testMovieDetail,
        recommendations: <Movie>[],
        addedInWatchlist: true,
        status: MovieDetailStatus.removeFromWatchlist,
        message: MovieDetailBloc.watchlistRemoveSuccessMessage,
      ),
    );
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(
        MovieDetailState(
          movie: testMovieDetail,
          recommendations: <Movie>[],
          addedInWatchlist: true,
          status: MovieDetailStatus.removeFromWatchlist,
          message: MovieDetailBloc.watchlistRemoveSuccessMessage,
        ),
      ),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(MovieDetailBloc.watchlistRemoveSuccessMessage), findsOneWidget);
  });

  testWidgets('Page should display Sizedbox when state in initial', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(MovieDetailState.initialState());
    when(() => bloc.stream).thenAnswer((_) => Stream.empty());

    final textFinder = find.byType(SizedBox);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when recommendation data is loaded', (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(MovieDetailState(
      status: MovieDetailStatus.success,
      movie: testMovieDetail,
      recommendations: <Movie>[testMovie],
    ));
    when(() => bloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailState(
        status: MovieDetailStatus.success,
        movie: testMovieDetail,
        recommendations: <Movie>[testMovie],
      )),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });
}
