part of 'movie_search_bloc.dart';

@immutable
abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object> get props => [];
}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchEmpty extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchError extends MovieSearchState {
  final String message;

  MovieSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieSearchHasData extends MovieSearchState {
  final List<Movie> result;

  MovieSearchHasData(this.result);

  @override
  List<Object> get props => [result];
}
