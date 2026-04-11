import '../../domain/entities/entities.dart';
import '../../ui/helpers/helpers.dart';

class CongressPersonModel extends CongressPersonEntity {
  const CongressPersonModel({
    required super.id,
    required super.uri,
    required super.name,
    required super.partyAbbreviation,
    required super.partyUri,
    required super.stateAbbreviation,
    required super.legislatureId,
    required super.urlProfilePic,
    required super.email,
    required super.stateSvg,
  });

  factory CongressPersonModel.fromMap({required Map json}) {
    try {
      final siglaUf = json['siglaUf']?.toString() ?? '';
      return CongressPersonModel(
        id: int.parse(json['id']?.toString() ?? '0'),
        uri: json['uri']?.toString() ?? '',
        name: json['nome']?.toString() ?? '',
        partyAbbreviation: json['siglaPartido']?.toString() ?? '',
        partyUri: json['uriPartido']?.toString() ?? '',
        stateAbbreviation: siglaUf,
        legislatureId: int.parse(json['idLegislatura']?.toString() ?? '0'),
        urlProfilePic: json['urlFoto']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        stateSvg: svgIcon(value: siglaUf),
      );
    } on TypeError catch (error) {
      throw Exception(error);
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uri': uri,
      'nome': name,
      'siglaPartido': partyAbbreviation,
      'uriPartido': partyUri,
      'siglaUf': stateAbbreviation,
      'idLegislatura': legislatureId,
      'urlFoto': urlProfilePic,
      'email': email,
    };
  }

  CongressPersonEntity toEntity() => CongressPersonEntity(
        id: id,
        uri: uri,
        name: name,
        partyAbbreviation: partyAbbreviation,
        partyUri: partyUri,
        stateAbbreviation: stateAbbreviation,
        legislatureId: legislatureId,
        urlProfilePic: urlProfilePic,
        email: email,
        stateSvg: stateSvg,
      );
}
