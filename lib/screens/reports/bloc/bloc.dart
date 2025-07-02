import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/utils/styles.dart';
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
        templateValue: 'عقد رقم {{param_contract}}/ت ',
        parameters: {
          'param_contract': IntParameter,
        },
        bold: true,
        color: CustomStyle.redDark,
      ),
      ReportItem(
        templateValue: 'عقد صيانة أنظمة الحماية من الحريق والإنذار وملحقاتها',
        parameters: null,
        align: TextAlign.center,
        bold: true,
        color: CustomStyle.redDark,
        addDivider: true,
      ),
      ReportItem(
        templateValue:
            'بعون من الله تعالى تم في يوم {{param_day}}، الموافق{{param_hijri_date}} هجرياً، الموافق {{param_gregorian_date}} ميلادياً الإتفاق بين كل من: ',
        parameters: {
          'param_day': DayParameter,
          'param_hijri_date': HijriDateParameter,
          'param_gregorian_date': GregorianDateParameter,
        },
        paddingAfter: 24,
      ),
      ReportItem(
        templateValue: 'الطرف الأول {{param_name}} ',
        parameters: {
          'param_name': StringParameter,
        },
        paddingAfter: 0,
        bold: true,
      ),
      ReportItem(
        templateValue: 'سجل تجاري رقم {{param_commercial_record}} ',
        parameters: {
          'param_commercial_record': IntParameter,
        },
        paddingAfter: 0,
      ),
      ReportItem(
        templateValue: 'العنوان {{param_address}} ',
        parameters: {
          'param_address': StringParameter,
        },
        paddingAfter: 0,
      ),
      ReportItem(
        templateValue: 'يمثلها المهندس {{param_engineer_name}} ',
        parameters: {
          'param_engineer_name': StringParameter,
        },
        paddingAfter: 0,
      ),
      ReportItem(
        templateValue: 'رقم الهوية {{param_id_number}} ',
        parameters: {
          'param_id_number': StringParameter,
        },
        paddingAfter: 0,
      ),
      ReportItem(
        templateValue: 'ج/ {{param_G}} ',
        parameters: {
          'param_G': StringParameter,
        },
        paddingAfter: 24,
      ),
      ReportItem(
        templateValue: 'الطرف الثاني {{param_name}} ',
        parameters: {
          'param_name': StringParameter,
        },
        paddingAfter: 0,
        bold: true,
      ),
      ReportItem(
        templateValue: 'سجل تجاري رقم {{param_commercial_record}} ',
        parameters: {
          'param_commercial_record': IntParameter,
        },
        paddingAfter: 0,
      ),
      ReportItem(
        templateValue: 'العنوان {{param_address}} ',
        parameters: {
          'param_address': StringParameter,
        },
        paddingAfter: 0,
      ),
      ReportItem(
        templateValue: 'يمثلها المهندس {{param_engineer_name}} ',
        parameters: {
          'param_engineer_name': StringParameter,
        },
        paddingAfter: 0,
      ),
      ReportItem(
        templateValue: 'رقم الهوية {{param_id_number}} ',
        parameters: {
          'param_id_number': StringParameter,
        },
        paddingAfter: 0,
      ),
      ReportItem(
        templateValue: 'ج/ {{param_G}} ',
        parameters: {
          'param_G': StringParameter,
        },
        paddingAfter: 24,
      ),
      ReportItem(
        templateValue:
            'لما كان الطرف الثاني يرغب في إجراء عملية صيانة أنظمة الحماية والإنذار من الحريق وملحقاتها وما أبداه الطرف الأول من توفر الإمكانات من خلال مهندسين وفنيين أكفاء ومختصين في هذه المجال وذلك حسب الأصول الفنية المعتمدة لذلك فقد تم الاتفاق بالتراضي بين الطرفين وهما بكامل الأهلية المعبرة شرعا حسب التالي:',
        paddingAfter: 24,
      ),
      ReportItem(
        templateValue: '1-	يعتبر التمهيد السابق جزء لا يتجزأ من هذه العقد.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '2-	قبول والتزام الطرف الأول بعمل الصيانة والكشف الدوري لنظام الحريق والذي يشمل (المضخات +صناديق الحريق +الأنظمة التلقائية الثابتة +طفايات الحريق أنظمة مأخذ الحريق الداخلية والخارجية +المعدات والمحابس والتوصيلات الخاصة بنظم الحماية من الحريق +اللوحة الخاصة بمضخة الحريق)وكذلك نظام الإنذار الخاص بالحريق والذي يشمل ( لوحة الإنذار الرئيسية – لوحة الإشارات – لوحة الإشارات المساعدة – كاشفات الحريق- مصابيح الإشارة المساعدة –نقاط النداء اليدوية- أجهزة التنبيه السمعية والمرئية المصدر الاحتياطي (المولد)- وخانق الحريق- إنارة الطوارئ-مراوح دفع الهواء بسلالم الطوارئ-مراوح شفط ودفع الهواء بالبدروم –شبكة تمديدات الكهربائية وجميع الأنظمة الخاصة بهذا النظام والمتطلبات الخاصة بتشغيل النظام والتأكد من جاهزية جميع ما ورد .',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '3-	يلتزم الطرف الأول بعمل جدول زيارات دورية على آلا يقل عن (12) زيارة سنوية بمعدل زيارة واحدة شهريا وتسجيل نتائج الزيارة في سجل السلامة الخاص بالمنشاة وإرفاق تقرير الصيانة بالسجل وتزويد الطرف الثاني بالتقرير.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '4-	يلتزم الطرف الأول بالحضور أو من ينوب عنه من الفنيين في حالة حدوث عطل مفاجئ ولا تعد تلك ضمن الزيارات المجدولة وتسجل في سجل السلامة الخاص لدى المشاءة.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '5-	على الطرف الأول أو الثاني إشعار الدفاع المدني رسميا بأي خلل يؤثر على استمرارية عمل تلك الأنظمة.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '6-	يجب على الطرف الذي يرغب في فسخ العقد إشعار الدفاع المدني رسميا والطرف الأخربرغبته في فسخ العقد قبل شهر من الانتهاء مبدياًأسباب ذلك وعلى الطرف الثاني إحضار عقد صيانة جديد قبل 10 أيام من نهاية العقد الأولوتقديمه للدفاع المدني علي أن يبدأ العقد الجديد مع نهاية العقد السابق.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '7-	يعتبر العقد ساري المفعول في حالة انتهاء مدته مالم يتعارض مع الفقرة السابقة ويعد ملزم للطرفين.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '8-	يلتزم الطرف الثاني بتأمين ما يلزم من قطع غيار اللازمة فور طلبها منه وعلى الطرف الأولإشعار الدفاع المدني عند عدم تأمينها خلال 48 ساعة من تاريخ إبلاغ الطرف الثاني. ',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '9-	يلتزم الطرف الثاني بتعبئة طفايات الحريق ونظام الإطفاء بالغازات بعد إعداد تقرير من قبل الطرف الأول بضرورة تعبئتها أو استبدالها أو الاتفاق مع الطرف الأول على تعبئتها وعلى الطرف الأولإشعار الدفاع المدني كتابيا عند عدم تأمينها خلال 48 ساعة من تاريخ إبلاغ الطرف الثاني.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '10-	في حالة تأخر الطرف الأول عن الصيانة على الطرف الثاني إشعار الدفاع المدني بذلك.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '11-	يلتزم الطرف الثاني بالمحافظة على جميع الأنظمة وعدم السماح بالعبث بها.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '12-	بمجرد التوقيع على هذا العقد يعتبر الطرف الأول مسئولاً عن صيانة معدات الإنذاروالإطفاء بجميع الأنظمة الواردة في الفقرة ثانيا. وأي خلل أو عيب فيها تكون تحت مسئوليته ويتحمل جميع ما يترتب على ذلك من إجراءات بما فيها إحالة الموضوع للجنة لنظر في مخالفات نظام ولوائح وتعليمات الدفاع المدني لتطبيق الغرامة المستحقة.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '13-	على الطرف الأول اتخاذ احتياطات الأمن والسلامة أثناءالعمل.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '14-	يلتزم الطرف الأول بإحضار أجهزة الرفع أو النقل التي يتطلبها أثناءالعمل.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '15-	على الطرف الأول الالتزام بقوانين وأنظمة المملكة العربية السعودية.',
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '16-	حرر هذا العقد بتاريخ {{param_hijri_date}} هجرياً من نسختين استلم كلا من الطرفين النسخة الخاصة به.',
        parameters: {
          'param_hijri_date': HijriDateParameter,
        },
        paddingAfter: 12,
      ),
      ReportItem(
        templateValue:
            '17-	قيمة هذا العقد الإجمالية لمدة {{param_period}} هو مبلغ {{param_amount}} ريال فقط سنوياً تدفع دفعة واحدة.',
        parameters: {
          'param_period': StringParameter,
          'param_amount': IntParameter,
        },
        paddingAfter: 24,
      ),
    ]));
  }
}
