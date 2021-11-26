import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/search_tvs.dart';
import 'package:core/presentation/bloc/tv/tv_search/tv_search_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchBloc searchBloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    searchBloc = TvSearchBloc(mockSearchTvs);
  });

  final tTv = Tv(
    id: 1,
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
  final tQuery = 'chucky';

  test('initial state should be empty', () {
    expect(searchBloc.state, TvSearchEmpty());
  });

  group('Search Tvs', () {
    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchTvs.execute(tQuery)).thenAnswer(
          (_) async => Right(tTvList),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: TvSearchBloc.debounceTime,
      expect: () => [
        TvSearchLoading(),
        TvSearchHasData(tTvList),
      ],
      verify: (bloc) {
        verify(mockSearchTvs.execute(tQuery));
      },
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, Empty] when data is gotten successfully',
      build: () {
        when(mockSearchTvs.execute(tQuery)).thenAnswer(
          (_) async => Right([]),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: TvSearchBloc.debounceTime,
      expect: () => [
        TvSearchLoading(),
        TvSearchEmpty(),
      ],
      verify: (bloc) {
        verify(mockSearchTvs.execute(tQuery));
      },
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchTvs.execute(tQuery)).thenAnswer(
          (_) async => Left(
            ServerFailure('Server Failure'),
          ),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: TvSearchBloc.debounceTime,
      expect: () => [
        TvSearchLoading(),
        TvSearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTvs.execute(tQuery));
      },
    );
  });
}
