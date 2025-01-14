import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/utils/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_cubit.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_cubit.dart';
import 'package:movie/presentation/bloc/wathclist_movie/watchlist_movies_cubit.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/search_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/presentation/bloc/now_playing_tv/now_playing_tv_cubit.dart';
import 'package:tv_series/presentation/bloc/popular_tvs/popular_tvs_cubit.dart';
import 'package:tv_series/presentation/bloc/top_rated_tvs/top_rated_tvs_cubit.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_season_detail/tv_season_detail_cubit.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv/watchlist_tv_cubit.dart';
import 'package:tv_series/presentation/pages/popular_tvs_page.dart';
import 'package:tv_series/presentation/pages/search_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';
import 'package:tv_series/presentation/pages/tv_season_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  BlocOverrides.runZoned(
    () {
      runApp(MyApp());
    },
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // movie
        BlocProvider(create: (_) => di.locator<NowPlayingMovieCubit>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesCubit>()),

        // tvs
        BlocProvider(create: (_) => di.locator<NowPlayingTvCubit>()),
        BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvsCubit>()),
        BlocProvider(create: (_) => di.locator<PopularTvsCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvCubit>()),
        BlocProvider(create: (_) => di.locator<TvSeasonDetailCubit>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistPage());

            // Movies
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case MovieSearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => MovieSearchPage());

            // TV
            case PopularTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvsPage());
            case TopRatedTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvsPage());
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case TvSeasonDetailPage.ROUTE_NAME:
              final id = (settings.arguments! as Map)['id'];
              final seasonNumber = (settings.arguments! as Map)['seasonNumber'];
              return MaterialPageRoute(
                builder: (_) => TvSeasonDetailPage(id: id, seasonNumber: seasonNumber),
              );
            case TvSearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TvSearchPage());

            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
