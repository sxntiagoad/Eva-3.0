import 'package:eva/models/format_inspecciones.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/preoperacional.dart';
import '../models/week.dart';

class PreoperacionalNotifier extends StateNotifier<Preoperacional> {
  PreoperacionalNotifier()
      : super(Preoperacional(
          carId: '',
          fecha: _getCurrentDateAsString(),
          inspecciones: formatInspecciones(),
          isOpen: false,
          typeKit: '',
          observaciones: '',
          kilometrajeInit: 0,
          kilometrajeFinal: 0,
        ));
  
  void updateCarId(String newCarId) {
    state = state.copyWith(carId: newCarId);
  }

  void updateFecha(String newFecha) {
    state = state.copyWith(fecha: newFecha);
  }

  void addOrUpdateInspecciones(Map<String, Map<String, Week>> newInspecciones) {
    final updatedInspecciones =
        Map<String, Map<String, Week>>.from(state.inspecciones);

    newInspecciones.forEach((key, value) {
      updatedInspecciones[key] = value;
    });

    state = state.copyWith(inspecciones: updatedInspecciones);
  }

  void updateIsOpen(bool newIsOpen) {
    state = state.copyWith(isOpen: newIsOpen);
  }

  void updateTypeKit(String newTypeKit) {
    state = state.copyWith(typeKit: newTypeKit);
  }

  void updateDocId(String newDocId) {
    state = state.copyWith(docId: newDocId);
  }

  // Nuevo método para actualizar observaciones
  void updateObservaciones(String newObservaciones) {
    state = state.copyWith(observaciones: newObservaciones);
  }

  void updateKilometrajeInit(int newKilometrajeInit) {
    state = state.copyWith(kilometrajeInit: newKilometrajeInit);
  }

  void updateKilometrajeFinal(int newKilometrajeFinal) {
    state = state.copyWith(kilometrajeFinal: newKilometrajeFinal);
  }

  void updateDayOfWeek(
    String category,
    String subCategory,
    String day,
    bool? value,
  ) {

    final updatedInspecciones = Map<String, Map<String, Week>>.from(
      state.inspecciones,
    );

    if (updatedInspecciones.containsKey(
          category,
        ) &&
        updatedInspecciones[category]!.containsKey(
          subCategory,
        )) {
      final currentWeek = updatedInspecciones[category]![subCategory];

      final updatedWeek = currentWeek?.copyWith(
        lunes: day == 'Lunes' ? () => value : null,
        martes: day == 'Martes' ? () => value : null,
        miercoles: day == 'Miercoles' ? () => value : null,
        jueves: day == 'Jueves' ? () => value : null,
        viernes: day == 'Viernes' ? () => value : null,
        sabado: day == 'Sabado' ? () => value : null,
        domingo: day == 'Domingo' ? () => value : null,
      );

      if (updatedWeek != null) {
        updatedInspecciones[category]![subCategory] = updatedWeek;
        state = state.copyWith(
          inspecciones: updatedInspecciones,
        );
      }
    }
  }
}

final newPreoperacionalProvider =
    StateNotifierProvider.autoDispose<PreoperacionalNotifier, Preoperacional>((ref) {
  return PreoperacionalNotifier();
});

String _getCurrentDateAsString() {
  final now = DateTime.now();
  final formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  return formattedDate;
}