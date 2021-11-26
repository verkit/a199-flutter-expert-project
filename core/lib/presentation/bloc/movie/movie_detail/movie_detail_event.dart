part of 'movie_detail_bloc.dart';

@immutable
abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDetailMovie extends MovieDetailEvent {
  final int id;

  LoadDetailMovie(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  AddToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveFromWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  RemoveFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
