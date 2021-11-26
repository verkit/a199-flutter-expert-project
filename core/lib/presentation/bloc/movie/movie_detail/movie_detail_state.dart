part of 'movie_detail_bloc.dart';

enum MovieDetailStatus { initial, loading, success, failure, addToWatchlist, removeFromWatchlist }

class MovieDetailState extends Equatable {
  const MovieDetailState({
    this.addedInWatchlist = false,
    this.status = MovieDetailStatus.initial,
    this.message,
    this.movie,
    this.recommendations,
  });

  final bool addedInWatchlist;
  final MovieDetailStatus status;
  final String? message;
  final MovieDetail? movie;
  final List<Movie>? recommendations;

  factory MovieDetailState.initialState() {
    return MovieDetailState(movie: null, recommendations: null);
  }

  MovieDetailState copyWith({
    MovieDetailStatus? status,
    MovieDetail? movie,
    List<Movie>? recommendations,
    String? message,
    bool? addedInWatchlist,
  }) {
    return MovieDetailState(
      status: status ?? this.status,
      addedInWatchlist: addedInWatchlist ?? this.addedInWatchlist,
      movie: movie ?? this.movie,
      recommendations: recommendations ?? this.recommendations,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        addedInWatchlist,
        status,
        message,
        movie,
        recommendations,
      ];
}
