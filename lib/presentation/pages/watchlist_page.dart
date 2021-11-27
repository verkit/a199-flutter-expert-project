import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/bloc/wathclist_movie/watchlist_movies_cubit.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv/watchlist_tv_cubit.dart';
import 'package:tv_series/presentation/pages/watchlist_page.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';
  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    WatchlistMoviesPage(),
    WatchlistTvsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistMoviesCubit>().fetchWatchlistMovies();
    context.read<WatchlistTvCubit>().fetchWatchlistTvs();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'TV',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
