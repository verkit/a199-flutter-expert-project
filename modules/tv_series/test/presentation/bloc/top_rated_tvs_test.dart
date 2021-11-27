import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv_series/presentation/bloc/top_rated_tvs/top_rated_tvs_cubit.dart';

import 'top_rated_tvs_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TopRatedTvsCubit topRatedTvsCubit;

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
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    topRatedTvsCubit = TopRatedTvsCubit(mockGetTopRatedTvs);
  });

  test('initial state should emit [Initial]', () {
    expect(topRatedTvsCubit.state, TopRatedTvsInitial());
  });

  blocTest<TopRatedTvsCubit, TopRatedTvsState>(
    'should get data from the usecases',
    build: () {
      when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Right(tTvList));
      return topRatedTvsCubit;
    },
    act: (cubit) => cubit.fetchTopRatedTvs(),
    verify: (cubit) => verify(mockGetTopRatedTvs.execute()),
    expect: () => [
      TopRatedTvsLoading(),
      TopRatedTvsHasData(tTvList),
    ],
  );

  blocTest<TopRatedTvsCubit, TopRatedTvsState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvsCubit;
    },
    act: (cubit) => cubit.fetchTopRatedTvs(),
    verify: (cubit) => verify(mockGetTopRatedTvs.execute()),
    expect: () => [
      TopRatedTvsLoading(),
      TopRatedTvsError('Server Failure'),
    ],
  );
}
