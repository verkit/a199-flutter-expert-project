import 'package:core/domain/entities/tv/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/top_rated_tvs/top_rated_tvs_cubit.dart';
import 'package:tv_series/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/tv/dummy_objects.dart';
import 'top_rated_tvs_page_test.mocks.dart';

@GenerateMocks([TopRatedTvsCubit])
void main() {
  late MockTopRatedTvsCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedTvsCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvsCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading', (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(TopRatedTvsLoading());
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(TopRatedTvsHasData(<Tv>[testTv]));
    when(mockCubit.stream).thenAnswer((_) => Stream.value(TopRatedTvsHasData(<Tv>[testTv])));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(TopRatedTvsError('Error Message'));
    when(mockCubit.stream).thenAnswer((_) => Stream.value(TopRatedTvsError('Error Message')));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display Sizedbox when state in initial', (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(TopRatedTvsInitial());
    when(mockCubit.stream).thenAnswer((_) => Stream.empty());

    final textFinder = find.byType(SizedBox);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
