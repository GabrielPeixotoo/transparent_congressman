import 'package:equatable/equatable.dart';

class CongressPersonEntity extends Equatable {
  final int id;
  final String uri;
  final String name;
  final String partyAbbreviation;
  final String partyUri;
  final String stateAbbreviation;
  final int legislatureId;
  final String urlProfilePic;
  final String email;
  final String stateSvg;
  const CongressPersonEntity({
    required this.id,
    required this.uri,
    required this.name,
    required this.partyAbbreviation,
    required this.partyUri,
    required this.stateAbbreviation,
    required this.legislatureId,
    required this.urlProfilePic,
    required this.email,
    required this.stateSvg,
  });

  @override
  List<Object> get props => [
        id,
        uri,
        name,
        partyAbbreviation,
        partyUri,
        stateAbbreviation,
        legislatureId,
        urlProfilePic,
        email,
        stateSvg,
      ];
}
