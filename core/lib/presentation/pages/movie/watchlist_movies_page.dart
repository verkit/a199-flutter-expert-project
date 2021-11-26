import 'package:core/presentation/bloc/movie/wathclist_movie/watchlist_movies_cubit.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistMoviesCubit>().fetchWatchlistMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMoviesCubit, WatchlistMoviesState>(
          builder: (_, state) {
            if (state is WatchlistMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistMoviesHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data[index];
                  return MovieCard(movie);
                },
                itemCount: data.length,
              );
            } else if (state is WatchlistMoviesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
