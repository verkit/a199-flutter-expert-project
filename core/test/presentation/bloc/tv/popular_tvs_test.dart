import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_popular_tvs.dart';
import 'package:core/presentation/bloc/tv/popular_tvs/popular_tvs_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tvs_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late PopularTvsCubit popularTvsCubit;

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

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    popularTvsCubit = PopularTvsCubit(mockGetPopularTvs);
  });

  test('initial state should emit [Initial]', () {
    expect(popularTvsCubit.state, PopularTvsInitial());
  });

  blocTest<PopularTvsCubit, PopularTvsState>(
    'should get data from the usecases',
    build: () {
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      return popularTvsCubit;
    },
    act: (cubit) => cubit.fetchPopularTvs(),
    verify: (cubit) => verify(mockGetPopularTvs.execute()),
    expect: () => [
      PopularTvsLoading(),
      PopularTvsHasData(tTvList),
    ],
  );

  blocTest<PopularTvsCubit, PopularTvsState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvsCubit;
    },
    act: (cubit) => cubit.fetchPopularTvs(),
    verify: (cubit) => verify(mockGetPopularTvs.execute()),
    expect: () => [
      PopularTvsLoading(),
      PopularTvsError('Server Failure'),
    ],
  );
}
