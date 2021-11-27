import 'package:core/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvs usecase;
  late MockTvRepository repository;

  setUp(() {
    repository = MockTvRepository();
    usecase = GetTopRatedTvs(repository);
  });

  final tTvs = <Tv>[];

  test('should get list of tvs from repository', () async {
    // arrange
    when(repository.getTopRatedTvs()).thenAnswer((_) async => Right(tTvs));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvs));
  });
}
