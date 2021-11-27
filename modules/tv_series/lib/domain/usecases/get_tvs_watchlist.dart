import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/repositories/tv_repository.dart';

class GetTvsWatchlist {
  final TvRepository _repository;

  GetTvsWatchlist(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTvs();
  }
}
