import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTvsWatchlist {
  final TvRepository _repository;

  GetTvsWatchlist(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTvs();
  }
}
