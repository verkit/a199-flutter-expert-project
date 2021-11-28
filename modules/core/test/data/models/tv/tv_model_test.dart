import 'package:core/data/models/tv/tv_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv/season.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/domain/entities/tv/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/tv/dummy_objects.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: 'backdropPath',
    firstAirDate: '2015-07-06',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['US'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTv = Tv(
    backdropPath: 'backdropPath',
    firstAirDate: '2015-07-06',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['US'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvDetail = TvDetail(
    backdropPath: 'backdropPath',
    episodeRunTime: [1, 2, 3],
    firstAirDate: '2012-01-01',
    genres: [Genre(id: 1, name: 'Action')],
    homepage: 'homepage',
    id: 1,
    inProduction: false,
    languages: ['en'],
    lastAirDate: '2021-01-01',
    name: 'name',
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

  test('should be a subclass of TV entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });

  test('genre should be pass a same value', () async {
    final genre = Genre(id: 1, name: 'Action');
    expect(genre, testTvDetail.genres[0]);
  });

  test('season should be pass a same value', () async {
    final season = Season(
      airDate: '2021-01-01',
      episodeCount: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 1,
    );
    expect(season, testTvDetail.seasons[0]);
  });

  test('Tv should be pass a same value', () async {
    expect(testTvDetail, tTvDetail);
  });
}
