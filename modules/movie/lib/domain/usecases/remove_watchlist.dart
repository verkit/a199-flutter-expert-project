import 'package:core/domain/entities/movie/movie_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../repositories/movie_repository.dart';

class RemoveMovieWatchlist {
  final MovieRepository repository;

  RemoveMovieWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
