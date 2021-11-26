import 'package:core/presentation/bloc/tv/watchlist_tv/watchlist_tv_cubit.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistTvsPage extends StatefulWidget {
  @override
  _WatchlistTvsPageState createState() => _WatchlistTvsPageState();
}

class _WatchlistTvsPageState extends State<WatchlistTvsPage> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistTvCubit>().fetchWatchlistTvs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvCubit, WatchlistTvsState>(
          builder: (_, state) {
            if (state is WatchlistTvsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvsHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data[index];
                  return TvCard(tv);
                },
                itemCount: data.length,
              );
            } else if (state is WatchlistTvsError) {
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
