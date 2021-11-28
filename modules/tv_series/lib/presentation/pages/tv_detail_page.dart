import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/domain/entities/tv/tv_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/pages/tv_season_detail_page.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvDetailBloc>().add(LoadDetailTv(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (_, state) {
          if (state.status == TvDetailStatus.loading || state.status == TvDetailStatus.initial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == TvDetailStatus.success ||
              state.status == TvDetailStatus.addToWatchlist ||
              state.status == TvDetailStatus.removeFromWatchlist) {
            final tv = state.tv;
            return SafeArea(
              child: DetailContent(
                tv!,
                state.recommendations!,
                state.addedInWatchlist,
                state,
              ),
            );
          } else {
            return Center(child: Text(state.message ?? 'Error', style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;
  final TvDetailState state;
  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist, this.state);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context.read<TvDetailBloc>().add(AddToWatchlist(tv));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text(TvDetailBloc.watchlistAddSuccessMessage)));
                                } else {
                                  context.read<TvDetailBloc>().add(RemoveFromWatchlist(tv));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(TvDetailBloc.watchlistRemoveSuccessMessage)));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            _buildSeasons(),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _buildTvRecommendations(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Container _buildSeasons() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final season = tv.seasons[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeasonDetailPage.ROUTE_NAME,
                  arguments: {
                    'id': tv.id,
                    'seasonNumber': season.seasonNumber,
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Stack(
                  children: [
                    if (season.posterPath != null)
                      CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500${season.posterPath}',
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(
                          32.0,
                        ),
                        child: Icon(Icons.error),
                      ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kRichBlack,
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.transparent.withOpacity(0.0),
                              kRichBlack,
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 0,
                      right: 0,
                      child: Text(
                        'Season ${season.seasonNumber}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: tv.seasons.length,
      ),
    );
  }

  Widget _buildTvRecommendations() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: recommendations.length,
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
