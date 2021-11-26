part of 'tv_detail_bloc.dart';

@immutable
abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDetailTv extends TvDetailEvent {
  final int id;

  LoadDetailTv(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TvDetailEvent {
  final TvDetail tv;

  AddToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvDetail tv;

  RemoveFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
