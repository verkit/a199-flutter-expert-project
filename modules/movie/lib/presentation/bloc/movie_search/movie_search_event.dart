part of 'movie_search_bloc.dart';

class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends MovieSearchEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
