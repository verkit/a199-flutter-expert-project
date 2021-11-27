import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv_series/domain/usecases/search_tvs.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs _searchTvs;
  TvSearchBloc(this._searchTvs) : super(TvSearchInitial()) {
    on<OnQueryChanged>(
      searchTvs,
      transformer: debounceRestartable(debounceTime),
    );
  }

  Future<void> searchTvs(OnQueryChanged event, Emitter<TvSearchState> emit) async {
    final query = event.query;
    emit(TvSearchLoading());

    final result = await _searchTvs.execute(query);

    result.fold(
      (failure) {
        emit(TvSearchError(failure.message));
      },
      (data) {
        if (data.isEmpty) {
          emit(TvSearchEmpty());
        } else {
          emit(TvSearchHasData(data));
        }
      },
    );
  }

  // How long to wait after the last keypress event
  static const debounceTime = Duration(milliseconds: 500);

  EventTransformer<OnQueryChanged> debounceRestartable<OnQueryChanged>(
    Duration duration,
  ) {
    // This feeds the debounced event stream to restartable() and returns that
    // as a transformer.
    return (events, mapper) => restartable<OnQueryChanged>().call(
          events.debounceTime(duration),
          mapper,
        );
  }
}
