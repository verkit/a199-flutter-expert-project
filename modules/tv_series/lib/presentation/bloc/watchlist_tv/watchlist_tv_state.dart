part of 'watchlist_tv_cubit.dart';

@immutable
abstract class WatchlistTvsState extends Equatable {
  const WatchlistTvsState();

  @override
  List<Object> get props => [];
}

class WatchlistTvsInitial extends WatchlistTvsState {}

class WatchlistTvsLoading extends WatchlistTvsState {}

class WatchlistTvsError extends WatchlistTvsState {
  final String message;

  WatchlistTvsError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvsHasData extends WatchlistTvsState {
  final List<Tv> result;

  WatchlistTvsHasData(this.result);

  @override
  List<Object> get props => [result];
}
