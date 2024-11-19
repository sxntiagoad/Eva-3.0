import 'package:eva/models/format_limpieza.dart';
import 'package:eva/models/limpieza.dart';
import 'package:eva/models/week.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LimpiezaNotifier extends StateNotifier<Limpieza> {
  LimpiezaNotifier() : super(Limpieza(carId: '', fecha: '', inspecciones: formatInspeccionesLimpieza()));

  void updateDayOfWeek(String category, String day, bool? value){
    final updatedInspecciones = Map<String, Week>.from(state.inspecciones);
    if (updatedInspecciones.containsKey(category)){
      final currentWeek = updatedInspecciones[category]!;
      final updatedWeek = currentWeek.copyWith(lunes: day == 'Lunes' ? () => value : null,
        martes: day == 'Martes' ? () => value : null,
        miercoles: day == 'Miercoles' ? () => value : null,
        jueves: day == 'Jueves' ? () => value : null,
        viernes: day == 'Viernes' ? () => value : null,
        sabado: day == 'Sabado' ? () => value : null,
        domingo: day == 'Domingo' ? () => value : null,
      );
       // Actualiza el mapa con el nuevo Week
        updatedInspecciones[category] = updatedWeek;
        // Actualiza el estado completo con el nuevo mapa de inspecciones
        state = state.copyWith(inspecciones: updatedInspecciones);

    }
  }
}