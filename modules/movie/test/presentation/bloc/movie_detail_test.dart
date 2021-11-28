import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetMovieWatchListStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetMovieWatchListStatus mockGetWatchlistStatus;
  late MockSaveMovieWatchlist mockSaveMovieWatchlist;
  late MockRemoveMovieWatchlist mockRemoveMovieWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetMovieWatchListStatus();
    mockSaveMovieWatchlist = MockSaveMovieWatchlist();
    mockRemoveMovieWatchlist = MockRemoveMovieWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveMovieWatchlist,
      removeWatchlist: mockRemoveMovieWatchlist,
    );
  });

  test('initial state should emit [Initial]', () {
    expect(movieDetailBloc.state, MovieDetailState.initialState());
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  group('Get Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should get data from the usecases and get the watchlist status',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(LoadDetailMovie(tId)),
      expect: () => [
        MovieDetailState(
          status: MovieDetailStatus.loading,
          addedInWatchlist: false,
          movie: null,
          recommendations: null,
          message: null,
        ),
        MovieDetailState(
          status: MovieDetailStatus.loading,
          addedInWatchlist: false,
          movie: testMovieDetail,
          recommendations: null,
          message: null,
        ),
        MovieDetailState(
          status: MovieDetailStatus.success,
          addedInWatchlist: true,
          recommendations: tMovies,
          movie: testMovieDetail,
          message: null,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(LoadDetailMovie(tId)),
      expect: () => [
        const MovieDetailState(
          status: MovieDetailStatus.loading,
          addedInWatchlist: false,
          movie: null,
          recommendations: null,
          message: null,
        ),
        const MovieDetailState(
          status: MovieDetailStatus.failure,
          addedInWatchlist: false,
          movie: null,
          recommendations: null,
          message: "Server Failure",
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveMovieWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      },
      expect: () => [
        MovieDetailState(
          status: MovieDetailStatus.addToWatchlist,
          addedInWatchlist: true,
          recommendations: null,
          movie: null,
          message: 'Added to Watchlist',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should return error when data recommendation movie is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(LoadDetailMovie(tId)),
      expect: () => [
        const MovieDetailState(
          status: MovieDetailStatus.loading,
          addedInWatchlist: false,
          movie: null,
          recommendations: null,
          message: null,
        ),
        MovieDetailState(
          status: MovieDetailStatus.loading,
          addedInWatchlist: false,
          movie: testMovieDetail,
          recommendations: null,
          message: null,
        ),
        MovieDetailState(
          status: MovieDetailStatus.failure,
          addedInWatchlist: false,
          movie: testMovieDetail,
          recommendations: null,
          message: "Server Failure",
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should show error when add watchlist failed',
      build: () {
        when(mockSaveMovieWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      },
      expect: () => [
        MovieDetailState(
          status: MovieDetailStatus.failure,
          addedInWatchlist: false,
          recommendations: null,
          movie: null,
          message: 'Failed',
        ),
      ],
    );
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should update watchlist status when remove watchlist success',
      build: () {
        when(mockRemoveMovieWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailState(
          status: MovieDetailStatus.removeFromWatchlist,
          addedInWatchlist: false,
          recommendations: null,
          movie: null,
          message: 'Removed from Watchlist',
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should show error when remove watchlist failed',
      build: () {
        when(mockRemoveMovieWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      },
      expect: () => [
        MovieDetailState(
          status: MovieDetailStatus.failure,
          addedInWatchlist: true,
          recommendations: null,
          movie: null,
          message: 'Failed',
        ),
      ],
    );
  });

  test('supports value comparison', () {
    expect(MovieDetailEvent(), MovieDetailEvent());
    expect(LoadDetailMovie(1), LoadDetailMovie(1));
    expect(AddToWatchlist(testMovieDetail), AddToWatchlist(testMovieDetail));
    expect(RemoveFromWatchlist(testMovieDetail), RemoveFromWatchlist(testMovieDetail));
  });

  test('should return same state', () {
    final state = MovieDetailState(
      status: MovieDetailStatus.failure,
      addedInWatchlist: true,
      recommendations: null,
      movie: null,
      message: 'Failed',
    );
    expect(state, state.copyWith());
  });
}
