import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_bloc.dart';

import 'movie_search_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = MovieSearchBloc(mockSearchMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  test('initial state should emit [Initial]', () {
    expect(searchBloc.state, MovieSearchInitial());
  });

  test('supports value comparison', () {
    expect(OnQueryChanged('query'), OnQueryChanged('query'));
    expect(MovieSearchEvent(), MovieSearchEvent());
  });

  group('Search Movies', () {
    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer(
          (_) async => Right(tMovieList),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: MovieSearchBloc.debounceTime,
      expect: () => [
        MovieSearchLoading(),
        MovieSearchHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Empty] when data is gotten successfully',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer(
          (_) async => Right([]),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: MovieSearchBloc.debounceTime,
      expect: () => [
        MovieSearchLoading(),
        MovieSearchEmpty(),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer(
          (_) async => Left(
            ServerFailure('Server Failure'),
          ),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: MovieSearchBloc.debounceTime,
      expect: () => [
        MovieSearchLoading(),
        MovieSearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );
  });
}
