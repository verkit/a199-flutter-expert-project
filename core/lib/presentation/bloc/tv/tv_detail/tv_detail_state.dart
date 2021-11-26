part of 'tv_detail_bloc.dart';

enum TvDetailStatus { initial, loading, success, failure , addToWatchlist, removeFromWatchlist}

class TvDetailState extends Equatable {
  const TvDetailState({
    this.addedInWatchlist = false,
    this.status = TvDetailStatus.initial,
    this.message,
    this.tv,
    this.recommendations,
  });

  final bool addedInWatchlist;
  final TvDetailStatus status;
  final String? message;
  final TvDetail? tv;
  final List<Tv>? recommendations;

  factory TvDetailState.initialState() {
    return TvDetailState(tv: null, recommendations: null);
  }

  TvDetailState copyWith({
    TvDetailStatus? status,
    TvDetail? tv,
    List<Tv>? recommendations,
    String? message,
    bool? addedInWatchlist,
  }) {
    return TvDetailState(
      status: status ?? this.status,
      addedInWatchlist: addedInWatchlist ?? this.addedInWatchlist,
      tv: tv ?? this.tv,
      recommendations: recommendations ?? this.recommendations,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        addedInWatchlist,
        status,
        message,
        tv,
        recommendations,
      ];
}
