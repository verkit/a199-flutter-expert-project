import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class WatchlistTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final bool? isTv;

  WatchlistTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    this.isTv = false,
  });

  factory WatchlistTable.fromMovieEntity(MovieDetail movie) => WatchlistTable(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        isTv: false,
      );

  factory WatchlistTable.fromTvEntity(TvDetail tv) => WatchlistTable(
        id: tv.id,
        title: tv.name,
        posterPath: tv.posterPath,
        overview: tv.overview,
        isTv: true,
      );

  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        isTv: map['is_tv'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'is_tv': isTv,
      };

  Movie toMovieEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );

  Tv toTvEntity() => Tv.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: title,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview];
}
