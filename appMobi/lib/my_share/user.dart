
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  User(this.code, this.name, this.id, this.area, this.mixer1, this.mixer2, this.mixer3, this.cycle, this.starttime);
  String code;
  String name;
  String id;
  String area;
  String mixer1;
  String mixer2;
  String mixer3;
  String cycle;
  String starttime;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}