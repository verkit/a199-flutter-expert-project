import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/datasources/watchlist_local_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:core/domain/usecases/movie/get_watchlist_status.dart';
import 'package:core/domain/usecases/movie/remove_watchlist.dart';
import 'package:core/domain/usecases/movie/save_watchlist.dart';
import 'package:core/domain/usecases/movie/search_movies.dart';
import 'package:core/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:core/domain/usecases/tv/get_popular_tvs.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:core/domain/usecases/tv/get_tv_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:core/domain/usecases/tv/get_tv_season_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/tv/get_tvs_watchlist.dart';
import 'package:core/domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/tv/save_tv_watchlist.dart';
import 'package:core/domain/usecases/tv/search_tvs.dart';
import 'package:core/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_search/movie_search_bloc.dart';
import 'package:core/presentation/bloc/movie/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:core/presentation/bloc/movie/popular_movies/popular_movies_cubit.dart';
import 'package:core/presentation/bloc/movie/top_rated_movies/top_rated_movies_cubit.dart';
import 'package:core/presentation/bloc/movie/wathclist_movie/watchlist_movies_cubit.dart';
import 'package:core/presentation/bloc/tv/now_playing_tv/now_playing_tv_cubit.dart';
import 'package:core/presentation/bloc/tv/popular_tvs/popular_tvs_cubit.dart';
import 'package:core/presentation/bloc/tv/top_rated_tvs/top_rated_tvs_cubit.dart';
import 'package:core/presentation/bloc/tv/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_search/tv_search_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_season_detail/tv_season_detail_cubit.dart';
import 'package:core/presentation/bloc/tv/watchlist_tv/watchlist_tv_cubit.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void init() {
  // provider
  // movie provider
  locator.registerFactory(() => NowPlayingMovieCubit(getNowPlayingMovies: locator()));
  locator.registerFactory(() => MovieDetailBloc(
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ));
  locator.registerFactory(() => MovieSearchBloc(locator()));
  locator.registerFactory(
    () => PopularMoviesCubit(
      locator(),
    ),
  );
  locator.registerFactory(() => TopRatedMoviesCubit(locator()));
  locator.registerFactory(() => WatchlistMoviesCubit(locator()));

  // tvs provider
  locator.registerFactory(
    () => NowPlayingTvCubit(locator()),
  );
  locator.registerFactory(
    () => TvDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => TvSearchBloc(locator()));
  locator.registerFactory(() => PopularTvsCubit(locator()));
  locator.registerFactory(() => TopRatedTvsCubit(locator()));
  locator.registerFactory(() => TvSeasonDetailCubit(locator()));
  locator.registerFactory(() => WatchlistTvCubit(locator()));

  // use case
  // movies
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetMovieWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // tvs
  locator.registerLazySingleton(() => GetNowPlayingTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetTvWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetTvsWatchlist(locator()));
  locator.registerLazySingleton(() => GetTvSeasonDetail(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(() => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<WatchlistLocalDataSource>(
    () => WatchlistLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => SSLClient(client: locator()));
}
