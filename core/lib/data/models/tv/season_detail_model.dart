import 'package:core/data/models/tv/episode_model.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailModel extends Equatable {
  SeasonDetailModel({
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.id,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String? airDate;
  final List<EpisodeModel> episodes;
  final String name;
  final String overview;
  final int id;
  final String? posterPath;
  final int seasonNumber;

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) => SeasonDetailModel(
        airDate: json['air_date'],
        episodes: List.from(json['episodes']).map((e) => EpisodeModel.fromJson(e)).toList(),
        name: json['name'],
        overview: json['overview'],
        id: json['id'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
      );

  Map<String, dynamic> toJson() => {
        'air_date': airDate,
        'episodes': episodes.map((e) => e.toJson()).toList(),
        'name': name,
        'overview': overview,
        'id': id,
        'poster_path': posterPath,
        'season_number': seasonNumber,
      };

  SeasonDetail toEntity() => SeasonDetail(
        airDate: airDate,
        episodes: episodes.map((e) => e.toEntity()).toList(),
        name: name,
        overview: overview,
        id: id,
        posterPath: posterPath,
        seasonNumber: seasonNumber,
      );

  @override
  List<Object?> get props => [
        airDate,
        episodes,
        name,
        overview,
        id,
        posterPath,
        seasonNumber,
      ];
}
