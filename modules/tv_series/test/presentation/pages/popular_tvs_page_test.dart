import 'package:core/domain/entities/tv/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/popular_tvs/popular_tvs_cubit.dart';
import 'package:tv_series/presentation/pages/popular_tvs_page.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/tv/dummy_objects.dart';
import 'popular_tvs_page_test.mocks.dart';

@GenerateMocks([PopularTvsCubit])
void main() {
  late MockPopularTvsCubit mockCubit;

  setUp(() {
    mockCubit = MockPopularTvsCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvsCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(PopularTvsLoading());
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(PopularTvsHasData(<Tv>[testTv]));
    when(mockCubit.stream).thenAnswer((_) => Stream.value(PopularTvsHasData(<Tv>[testTv])));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(PopularTvsError('Error Message'));
    when(mockCubit.stream).thenAnswer((_) => Stream.value(PopularTvsError('Error Message')));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
