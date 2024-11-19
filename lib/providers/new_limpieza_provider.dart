import 'package:eva/models/format_limpieza.dart';
import 'package:eva/models/limpieza.dart';
import 'package:eva/models/week.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LimpiezaNotifier extends StateNotifier<Limpieza> {
  LimpiezaNotifier() 
    : super(Limpieza(
        carId: '', 
        fecha: DateTime.now().toIso8601String(), 
        inspecciones: formatInspeccionesLimpieza()
      ));

  void updateCarId(String newCarId) {
    state = state.copyWith(carId: newCarId);
  }

  void updateDayOfWeek(String category, String day, bool? value) {
    final updatedInspecciones = Map<String, Week>.from(state.inspecciones);
    
    if (updatedInspecciones.containsKey(category)) {
      final currentWeek = updatedInspecciones[category]!;
      
      final updatedWeek = currentWeek.copyWith(
        lunes: day == 'Lunes' ? () => value : null,
        martes: day == 'Martes' ? () => value : null,
        miercoles: day == 'Miercoles' ? () => value : null,
        jueves: day == 'Jueves' ? () => value : null,
        viernes: day == 'Viernes' ? () => value : null,
        sabado: day == 'Sabado' ? () => value : null,
        domingo: day == 'Domingo' ? () => value : null,
      );

      updatedInspecciones[category] = updatedWeek;
      state = state.copyWith(inspecciones: updatedInspecciones);
    }
  }

  void reset() {
    state = Limpieza(
      carId: '', 
      fecha: DateTime.now().toIso8601String(), 
      inspecciones: formatInspeccionesLimpieza()
    );
  }
}

// Provider global
final newLimpiezaProvider = StateNotifierProvider<LimpiezaNotifier, Limpieza>((ref) {
  return LimpiezaNotifier();
});

// Provider simple para validación básica
final isLimpiezaValidProvider = Provider<bool>((ref) {
  final limpieza = ref.watch(newLimpiezaProvider);
  return limpieza.carId.isNotEmpty;
});