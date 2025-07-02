import 'package:fire_alarm_system/models/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc() : super(ReportsInitial()) {
    on<ReportsItemsRequested>(_onLoad);
  }

  void _onLoad(ReportsItemsRequested event, Emitter<ReportsState> emit) {
    emit(ReportsLoaded(items: [
      ReportItem(
        direction: TextDirection.rtl,
        parameters: {
          'param_day': DayParameter,
          'param_hijri_date': HijriDateParameter,
          'param_gregorian_date': GregorianDateParameter,
        },
        templateValue:
            'بعون من الله تعالى تم في يوم {{param_day}}\u00A0الموافق{{param_hijri_date}} هجرياً، الموافق {{param_gregorian_date}} ميلادياً الإتفاق بين كل من: ',
      ),
    ]));
  }
}
