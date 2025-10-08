import 'dart:ui';

import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class ReportsTemplate {
  static List<ContractItem> getContractItems(
      List<ContractCategory> contractCategories) {
    final List<ContractItem> items = [
      ContractItem(
        text: ReportTextItem(
          templateValue: 'عقد رقم {{paramContractNumber}}/FB ',
          parameters: {
            'paramContractNumber': IntParameter,
          },
          bold: true,
          color: CustomStyle.redDark,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'عقد صيانة أنظمة الحماية من الحريق والإنذار وملحقاتها',
          parameters: null,
          align: TextAlign.center,
          bold: true,
          color: CustomStyle.redDark,
          addDivider: true,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              'بعون من الله تعالى تم في يوم {{paramContractAgreementDay}}، الموافق{{paramContractAgreementHijriDate}} هجرياً، الموافق {{paramContractAgreementGregorianDate}} ميلادياً الإتفاق بين كل من: ',
          parameters: {
            'paramContractAgreementDay': DayParameter,
            'paramContractAgreementHijriDate': HijriDateParameter,
            'paramContractAgreementGregorianDate': GregorianDateParameter,
          },
          paddingAfter: 24,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'الطرف الأول: {{paramFirstPartyName}} ',
          parameters: {
            'paramFirstPartyName': StringParameter,
          },
          paddingAfter: 0,
          bold: true,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'سجل تجاري رقم: {{paramFirstPartyCommNumber}} ',
          parameters: {
            'paramFirstPartyCommNumber': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'العنوان: {{paramFirstPartyAddress}} ',
          parameters: {
            'paramFirstPartyAddress': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'يمثلها: {{paramFirstPartyRep}} ',
          parameters: {
            'paramFirstPartyRep': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'رقم الهوية: {{paramFirstPartyRepIdNumber}} ',
          parameters: {
            'paramFirstPartyRepIdNumber': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'ج/ {{paramFirstPartyG}} ',
          parameters: {
            'paramFirstPartyG': StringParameter,
          },
          paddingAfter: 24,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'الطرف الثاني: {{paramSecondPartyName}} ',
          parameters: {
            'paramSecondPartyName': StringParameter,
          },
          paddingAfter: 0,
          bold: true,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'سجل تجاري رقم: {{paramSecondPartyCommNumber}} ',
          parameters: {
            'paramSecondPartyCommNumber': IntParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'العنوان: {{paramSecondPartyAddress}} ',
          parameters: {
            'paramSecondPartyAddress': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'يمثلها: {{paramSecondPartyRep}} ',
          parameters: {
            'paramSecondPartyRep': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'رقم الهوية: {{paramSecondPartyRepIdNumber}} ',
          parameters: {
            'paramSecondPartyRepIdNumber': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: 'ج/ {{paramSecondPartyG}} ',
          parameters: {
            'paramSecondPartyG': StringParameter,
          },
          paddingAfter: 24,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              'لما كان الطرف الثاني يرغب في إجراء عملية صيانة أنظمة الحماية والإنذار من الحريق وملحقاتها وما أبداه الطرف الأول من توفر الإمكانات من خلال مهندسين وفنيين أكفاء ومختصين في هذه المجال وذلك حسب الأصول الفنية المعتمدة لذلك فقد تم الاتفاق بالتراضي بين الطرفين وهما بكامل الأهلية المعبرة شرعا حسب التالي:',
          paddingAfter: 24,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue: '1-	يعتبر التمهيد السابق جزء لا يتجزأ من هذه العقد.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '2-	قبول والتزام الطرف الأول بعمل الصيانة والكشف الدوري لنظام الحريق والذي يشمل (المضخات + صناديق الحريق + الأنظمة التلقائية الثابتة + طفايات الحريق + أنظمة مأخذ الحريق الداخلية والخارجية +المعدات والمحابس والتوصيلات الخاصة بنظم الحماية من الحريق + اللوحة الخاصة بمضخة الحريق)وكذلك نظام الإنذار الخاص بالحريق والذي يشمل ( لوحة الإنذار الرئيسية – لوحة الإشارات – لوحة الإشارات المساعدة – كاشفات الحريق - مصابيح الإشارة المساعدة – نقاط النداء اليدوية - أجهزة التنبيه السمعية والمرئية المصدر الاحتياطي (المولد) - وخانق الحريق - إنارة الطوارئ - مراوح دفع الهواء بسلالم الطوارئ - مراوح شفط ودفع الهواء بالبدروم – شبكة تمديدات الكهربائية وجميع الأنظمة الخاصة بهذا النظام والمتطلبات الخاصة بتشغيل النظام والتأكد من جاهزية جميع ما ورد .',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '3-	يلتزم الطرف الأول بعمل جدول زيارات دورية على آلا يقل عن (12) زيارة سنوية بمعدل زيارة واحدة شهريا وتسجيل نتائج الزيارة في سجل السلامة الخاص بالمنشاة وإرفاق تقرير الصيانة بالسجل وتزويد الطرف الثاني بالتقرير.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '4-	يلتزم الطرف الأول بالحضور أو من ينوب عنه من الفنيين في حالة حدوث عطل مفاجئ ولا تعد تلك ضمن الزيارات المجدولة وتسجل في سجل السلامة الخاص لدى المنشأة.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '5-	على الطرف الأول أو الثاني إشعار الدفاع المدني رسميا بأي خلل يؤثر على استمرارية عمل تلك الأنظمة.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '6-	يجب على الطرف الذي يرغب في فسخ العقد إشعار الدفاع المدني رسميا والطرف الأخر برغبته في فسخ العقد قبل شهر من الانتهاء مبدياًأسباب ذلك وعلى الطرف الثاني إحضار عقد صيانة جديد قبل 10 أيام من نهاية العقد الأول وتقديمه للدفاع المدني علي أن يبدأ العقد الجديد مع نهاية العقد السابق.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '7-	يعتبر العقد ساري المفعول في حالة انتهاء مدته ما لم يتعارض مع الفقرة السابقة ويعد ملزم للطرفين.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '8-	يلتزم الطرف الثاني بتأمين ما يلزم من قطع غيار اللازمة فور طلبها منه وعلى الطرف الأول إشعار الدفاع المدني عند عدم تأمينها خلال 48 ساعة من تاريخ إبلاغ الطرف الثاني. ',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '9-	يلتزم الطرف الثاني بتعبئة طفايات الحريق ونظام الإطفاء بالغازات بعد إعداد تقرير من قبل الطرف الأول بضرورة تعبئتها أو استبدالها أو الاتفاق مع الطرف الأول على تعبئتها وعلى الطرف الأول إشعار الدفاع المدني كتابيا عند عدم تأمينها خلال 48 ساعة من تاريخ إبلاغ الطرف الثاني.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '10-	في حالة تأخر الطرف الأول عن الصيانة على الطرف الثاني إشعار الدفاع المدني بذلك.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '11-	يلتزم الطرف الثاني بالمحافظة على جميع الأنظمة وعدم السماح بالعبث بها.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '12-	بمجرد التوقيع على هذا العقد يعتبر الطرف الأول مسئولاً عن صيانة معدات الإنذار والإطفاء بجميع الأنظمة الواردة في الفقرة ثانيا. وأي خلل أو عيب فيها تكون تحت مسئوليته ويتحمل جميع ما يترتب على ذلك من إجراءات بما فيها إحالة الموضوع للجنة لنظر في مخالفات نظام ولوائح وتعليمات الدفاع المدني لتطبيق الغرامة المستحقة.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '13-	على الطرف الأول اتخاذ احتياطات الأمن والسلامة أثناء العمل.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '14-	يلتزم الطرف الأول بإحضار أجهزة الرفع أو النقل التي يتطلبها أثناء العمل.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '15-	على الطرف الأول الالتزام بقوانين وأنظمة المملكة العربية السعودية.',
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '16-	حرر هذا العقد بتاريخ {{paramContractAddDate}} هجرياً من نسختين استلم كلا من الطرفين النسخة الخاصة به.',
          parameters: {
            'paramContractAddDate': HijriDateParameter,
          },
          paddingAfter: 12,
        ),
      ),
      ContractItem(
        text: ReportTextItem(
          templateValue:
              '17-	قيمة هذا العقد الإجمالية لمدة {{paramContractPeriod}} هو مبلغ {{paramContractAmount}} ريال فقط سنوياً تدفع دفعة واحدة.',
          parameters: {
            'paramContractPeriod': StringParameter,
            'paramContractAmount': IntParameter,
          },
          paddingAfter: 24,
        ),
      ),
    ];

    // Dynamically add a section (title + empty table) for each category
    for (int i = 1; i < (contractCategories.length); i++) {
      final cat = contractCategories[i];
      items.add(
        ContractItem(
          text: ReportTextItem(
            templateValue: '• ${cat.arName}: -',
            paddingAfter: 0,
            bold: true,
            underlined: true,
          ),
        ),
      );
      items.add(
        ContractItem(
          table: ReportTableItem(
            types: [],
            categoryIndex: i,
          ),
        ),
      );
    }

    if (contractCategories.isNotEmpty) {
      final cat = contractCategories[0];
      items.add(
        ContractItem(
          text: ReportTextItem(
            templateValue: '• ${cat.arName}: -',
            paddingAfter: 0,
            bold: true,
            underlined: true,
          ),
        ),
      );
      items.add(
        ContractItem(
          table: ReportTableItem(
            types: [],
            categoryIndex: 0,
          ),
        ),
      );
    }

    // Trailing signature and closing items
    items.addAll([
      ContractItem(
        text: ReportTextItem(
          templateValue: 'هذا وتقبلوا منا فائق التحية والتقدير',
          paddingAfter: 24,
          bold: true,
          align: TextAlign.center,
        ),
      ),
    ]);
    return items;
  }
}
