import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/watchlist_local_data_source.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:tv_series/data/datasources/tv_remote_data_source.dart';
import 'package:tv_series/domain/repositories/tv_repository.dart';

@GenerateMocks([
  WatchlistLocalDataSource,
  DatabaseHelper,
  TvRemoteDataSource,
  TvRepository,
  SSLClient,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
