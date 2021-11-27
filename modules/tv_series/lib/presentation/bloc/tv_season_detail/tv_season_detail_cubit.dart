import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv/season_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv_series/domain/usecases/get_tv_season_detail.dart';

part 'tv_season_detail_state.dart';

class TvSeasonDetailCubit extends Cubit<TvSeasonDetailState> {
  final GetTvSeasonDetail getTvSeasonDetail;
  TvSeasonDetailCubit(this.getTvSeasonDetail) : super(TvSeasonDetailInitial());

  Future<void> fetchTvSeasonDetail(int id, int seasonNumber) async {
    emit(TvSeasonDetailLoading());

    final detailResult = await getTvSeasonDetail.execute(id, seasonNumber);

    detailResult.fold(
      (failure) {
        emit(TvSeasonDetailError(failure.message));
      },
      (seasonDetail) {
        emit(TvSeasonDetailHasData(seasonDetail));
      },
    );
  }
}
