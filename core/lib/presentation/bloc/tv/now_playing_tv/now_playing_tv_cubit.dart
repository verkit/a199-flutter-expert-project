import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'now_playing_tv_state.dart';

class NowPlayingTvCubit extends Cubit<NowPlayingTvState> {
  final GetNowPlayingTvs getNowPlayingTvs;
  NowPlayingTvCubit(this.getNowPlayingTvs) : super(NowPlayingTvInitial());

  Future<void> fetchNowPlayingTvs() async {
    emit(NowPlayingTvLoading());

    final result = await getNowPlayingTvs.execute();
    result.fold(
      (failure) => emit(NowPlayingTvError(failure.message)),
      (tvsData) => emit(NowPlayingTvHasData(tvsData)),
    );
  }
}
