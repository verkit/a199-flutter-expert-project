import 'package:core/domain/entities/movie/movie_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
