import 'dart:convert';
import 'dart:io';

import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/models/tv/episode_model.dart';
import 'package:core/data/models/tv/season_detail_model.dart';
import 'package:core/data/models/tv/tv_detail_model.dart';
import 'package:core/data/models/tv/tv_response.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvRemoteDataSource dataSource;
  late MockHttpClient mockHttpClient;
  late SSLClient mockSSLClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSSLClient = SSLClient(client: mockHttpClient);
    dataSource = TvRemoteDataSourceImpl(client: mockSSLClient);
  });

  group('get Now Playing Tvs', () {
    final tTvList = TvResponse.fromJson(json.decode(readJson('dummy_data/tv/now_playing.json'))).tvList;

    test('should return list of Tv Model when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'))).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv/now_playing.json'), 200),
      );
      // act
      final result = await dataSource.getNowPlayingTvs();
      // assert
      expect(result, equals(tTvList));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tvs', () {
    final tTvList = TvResponse.fromJson(json.decode(readJson('dummy_data/tv/populars.json'))).tvList;

    test('should return list of tvs when response is success (200)', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'))).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv/populars.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getPopularTvs();
      // assert
      expect(result, tTvList);
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Tvs', () {
    final tTvList = TvResponse.fromJson(json.decode(readJson('dummy_data/tv/top_rated.json'))).tvList;

    test('should return list of tvs when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'))).thenAnswer((_) async => http.Response(
            readJson('dummy_data/tv/top_rated.json'),
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ));
      // act
      final result = await dataSource.getTopRatedTvs();
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when response code is other than 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail', () {
    final tId = 1;
    final tTvDetail = TvDetailModel.fromJson(json.decode(readJson('dummy_data/tv/detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY'))).thenAnswer((_) async => http.Response(
            readJson('dummy_data/tv/detail.json'),
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ));
      // act
      final result = await dataSource.getTvDetail(tId);
      // assert
      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tTvList = TvResponse.fromJson(json.decode(readJson('dummy_data/tv/recommendations.json'))).tvList;
    final tId = 1;

    test('should return list of Tv Model when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(readJson('dummy_data/tv/recommendations.json'), 200));
      // act
      final result = await dataSource.getTvRecommendations(tId);
      // assert
      expect(result, equals(tTvList));
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tvs', () {
    final tSearchResult = TvResponse.fromJson(json.decode(readJson('dummy_data/tv/search_chucky_movie.json'))).tvList;
    final tQuery = 'chucky';

    test('should return list of tvs when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
                readJson('dummy_data/tv/search_chucky_movie.json'),
                200,
                headers: {
                  HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
                },
              ));
      // act
      final result = await dataSource.searchTvs(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvs(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv season detail', () {
    final tvId = 1;
    final seasonNumber = 1;

    final tEpisodeModel = EpisodeModel(
      airDate: '2021-12-14',
      episodeNumber: 1,
      id: 1,
      name: 'Episode 1',
      overview: 'overview',
      productionCode: '',
      seasonNumber: seasonNumber,
      stillPath: '/stillPath.jpg',
      voteAverage: 0.0,
      voteCount: 0,
    );

    final tSeasonDetail = SeasonDetailModel(
      airDate: '2021-10-12',
      episodes: [tEpisodeModel],
      id: 1,
      name: 'Season 1',
      overview: 'overview',
      posterPath: '/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg',
      seasonNumber: seasonNumber,
    );

    test('should get tv season detail', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tvId/season/$seasonNumber?$API_KEY')))
          .thenAnswer((_) async => http.Response(readJson('dummy_data/tv/season_detail.json'), 200));
      // act
      final result = await dataSource.getTvSeasonDetail(tvId, seasonNumber);
      // assert
      expect(result, equals(tSeasonDetail));
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tvId/season/$seasonNumber?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeasonDetail(tvId, seasonNumber);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
