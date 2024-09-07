import 'dart:convert';

import 'package:flutter/widgets.dart';

class Week {
  final bool? lunes;
  final bool? martes;
  final bool? miercoles;
  final bool? jueves;
  final bool? viernes;
  final bool? sabado;
  final bool? domingo;
  Week({
    this.lunes,
    this.martes,
    this.miercoles,
    this.jueves,
    this.viernes,
    this.sabado,
    this.domingo,
  });

  Week copyWith({
    ValueGetter<bool?>? lunes,
    ValueGetter<bool?>? martes,
    ValueGetter<bool?>? miercoles,
    ValueGetter<bool?>? jueves,
    ValueGetter<bool?>? viernes,
    ValueGetter<bool?>? sabado,
    ValueGetter<bool?>? domingo,
  }) {
    return Week(
      lunes: lunes != null ? lunes() : this.lunes,
      martes: martes != null ? martes() : this.martes,
      miercoles: miercoles != null ? miercoles() : this.miercoles,
      jueves: jueves != null ? jueves() : this.jueves,
      viernes: viernes != null ? viernes() : this.viernes,
      sabado: sabado != null ? sabado() : this.sabado,
      domingo: domingo != null ? domingo() : this.domingo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Lunes': lunes,
      'Martes': martes,
      'Miercoles': miercoles,
      'Jueves': jueves,
      'Viernes': viernes,
      'Sabado': sabado,
      'Domingo': domingo,
    };
  }

  factory Week.fromMap(Map<String, dynamic> map) {
    return Week(
      lunes: map['Lunes'],
      martes: map['Martes'],
      miercoles: map['Miercoles'],
      jueves: map['Jueves'],
      viernes: map['Viernes'],
      sabado: map['Sabado'],
      domingo: map['Domingo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Week.fromJson(String source) => Week.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Week(lunes: $lunes, martes: $martes, miercoles: $miercoles, jueves: $jueves, viernes: $viernes, sabado: $sabado, domingo: $domingo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Week &&
      other.lunes == lunes &&
      other.martes == martes &&
      other.miercoles == miercoles &&
      other.jueves == jueves &&
      other.viernes == viernes &&
      other.sabado == sabado &&
      other.domingo == domingo;
  }

  @override
  int get hashCode {
    return lunes.hashCode ^
      martes.hashCode ^
      miercoles.hashCode ^
      jueves.hashCode ^
      viernes.hashCode ^
      sabado.hashCode ^
      domingo.hashCode;
  }
}
