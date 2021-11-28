import 'package:core/data/models/watchlist_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/tv/season.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/domain/entities/tv/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tMovie = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tWatchlistMovie = WatchlistTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTv = Tv.watchlist(
    id: 1,
    name: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tWatchlistTv = WatchlistTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    type: 'tv',
  );

  final _testTvDetail = TvDetail(
    backdropPath: 'backdropPath',
    episodeRunTime: [1, 2, 3],
    firstAirDate: '2012-01-01',
    genres: [Genre(id: 1, name: 'Action')],
    homepage: 'homepage',
    id: 1,
    inProduction: false,
    languages: ['en'],
    lastAirDate: '2021-01-01',
    name: 'title',
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    seasons: [
      Season(
        airDate: '2021-01-01',
        episodeCount: 1,
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
      )
    ],
    status: 'status',
    tagline: 'tagline',
    type: 'type',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Movie entity', () async {
    final result = tWatchlistMovie.toMovieEntity();
    expect(result, tMovie);
  });

  test('should be a subclass of Tv entity', () async {
    final result = tWatchlistTv.toTvEntity();
    expect(result, tTv);
  });

  test('detail movie should be a subclass of Watchlist', () async {
    final result = WatchlistTable.fromMovieEntity(testMovieDetail);
    expect(result, tWatchlistMovie);
  });
  test('detail tv should be a subclass of Watchlist', () async {
    final result = WatchlistTable.fromTvEntity(_testTvDetail);
    expect(result, tWatchlistTv);
  });
}
