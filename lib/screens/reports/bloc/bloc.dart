import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  List<ReportItem>? items;
  List<ContractComponentItem>? components;
  List<ContractComponentCategory>? categories;
  List<ContractData>? contracts;
  final AppRepository appRepository;

  ReportsBloc({required this.appRepository}) : super(ReportsInitial()) {
    appRepository.authStateStream.listen((_) {
      
    });
    on<ReportsItemsRequested>(_onLoad);
    on<ReportsContractComponentsRequested>(_onContractComponentsLoad);
    on<ReportsContractComponentsAddRequested>(_onContractComponentsAdd);
    on<ReportsContractComponentsSaveRequested>(_onContractComponentsSave);
    on<SaveContractRequested>(_onSaveContract);
    on<AllContractsRequested>(_onReadContracts);
    on<SignContractRequested>(_onSignContract);
  }

  Future<void> _onContractComponentsLoad(
    ReportsContractComponentsRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    components = await appRepository.reportsRepository.readContractComponents();
    categories = await appRepository.reportsRepository
        .readContractComponentsCategories();
    emit(ReportsContractComponentsLoaded(
        items: components!, categories: categories!));
  }

  Future<void> _onContractComponentsAdd(
    ReportsContractComponentsAddRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    final existing = components ??
        await appRepository.reportsRepository.readContractComponents();
    components = [...existing, event.item];
    categories = categories ??
        await appRepository.reportsRepository
            .readContractComponentsCategories();
    await appRepository.reportsRepository.setContractComponents(components!);
    emit(ReportsContractComponentsLoaded(
        items: components!, categories: categories!));
  }

  Future<void> _onContractComponentsSave(
    ReportsContractComponentsSaveRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    components = event.items;
    await appRepository.reportsRepository.setContractComponents(components!);
    emit(ReportsSaved());
    emit(ReportsContractComponentsLoaded(
        items: components!, categories: categories!));
  }

  Future<void> _onSaveContract(
    SaveContractRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    await appRepository.reportsRepository.saveContract(event.contract);
    emit(ReportsSaved());
  }

  Future<void> _onReadContracts(
    AllContractsRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    contracts = await appRepository.reportsRepository.readContracts();
    emit(AllContractsLoaded(
      contracts: contracts!,
      items: getContractItems(),
      user: appRepository.authRepository.userRole,
    ));
  }

  Future<void> _onSignContract(
    SignContractRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    ContractData signedContract = await appRepository.reportsRepository
        .signContract(user: appRepository.userRole, contract: event.contract);
    emit(ReportsSigned(contract: signedContract));
  }

  Future<void> _onLoad(
      ReportsItemsRequested event, Emitter<ReportsState> emit) async {
    components = components ??
        await appRepository.reportsRepository.readContractComponents();
    categories = categories ??
        await appRepository.reportsRepository
            .readContractComponentsCategories();

    emit(ReportsNewContractInfoLoaded(
      items: getContractItems(),
      categories: categories!,
      components: components!,
      employee: appRepository.authRepository.userRole is Employee
          ? appRepository.authRepository.userRole
          : null,
      clients: appRepository.users.clients,
    ));
  }

  List<ReportItem> getContractItems() {
    final List<ReportItem> items = [
      ReportItem(
        text: ReportTextItem(
          templateValue: 'عقد رقم {{paramContractNumber}}/ت ',
          parameters: {
            'paramContractNumber': IntParameter,
          },
          bold: true,
          color: CustomStyle.redDark,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'عقد صيانة أنظمة الحماية من الحريق والإنذار وملحقاتها',
          parameters: null,
          align: TextAlign.center,
          bold: true,
          color: CustomStyle.redDark,
          addDivider: true,
        ),
      ),
      ReportItem(
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
      ReportItem(
        text: ReportTextItem(
          templateValue: 'الطرف الأول: {{paramFirstPartyName}} ',
          parameters: {
            'paramFirstPartyName': StringParameter,
          },
          paddingAfter: 0,
          bold: true,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'سجل تجاري رقم: {{paramFirstPartyCommNumber}} ',
          parameters: {
            'paramFirstPartyCommNumber': IntParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'العنوان: {{paramFirstPartyAddress}} ',
          parameters: {
            'paramFirstPartyAddress': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'يمثلها: {{paramFirstPartyRep}} ',
          parameters: {
            'paramFirstPartyRep': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'رقم الهوية: {{paramFirstPartyRepIdNumber}} ',
          parameters: {
            'paramFirstPartyRepIdNumber': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'ج/ {{paramFirstPartyG}} ',
          parameters: {
            'paramFirstPartyG': StringParameter,
          },
          paddingAfter: 24,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'الطرف الثاني: {{paramSecondPartyName}} ',
          parameters: {
            'paramSecondPartyName': StringParameter,
          },
          paddingAfter: 0,
          bold: true,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'سجل تجاري رقم: {{paramSecondPartyCommNumber}} ',
          parameters: {
            'paramSecondPartyCommNumber': IntParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'العنوان: {{paramSecondPartyAddress}} ',
          parameters: {
            'paramSecondPartyAddress': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'يمثلها: {{paramSecondPartyRep}} ',
          parameters: {
            'paramSecondPartyRep': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'رقم الهوية: {{paramSecondPartyRepIdNumber}} ',
          parameters: {
            'paramSecondPartyRepIdNumber': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'ج/ {{paramSecondPartyG}} ',
          parameters: {
            'paramSecondPartyG': StringParameter,
          },
          paddingAfter: 24,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              'لما كان الطرف الثاني يرغب في إجراء عملية صيانة أنظمة الحماية والإنذار من الحريق وملحقاتها وما أبداه الطرف الأول من توفر الإمكانات من خلال مهندسين وفنيين أكفاء ومختصين في هذه المجال وذلك حسب الأصول الفنية المعتمدة لذلك فقد تم الاتفاق بالتراضي بين الطرفين وهما بكامل الأهلية المعبرة شرعا حسب التالي:',
          paddingAfter: 24,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: '1-	يعتبر التمهيد السابق جزء لا يتجزأ من هذه العقد.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '2-	قبول والتزام الطرف الأول بعمل الصيانة والكشف الدوري لنظام الحريق والذي يشمل (المضخات +صناديق الحريق +الأنظمة التلقائية الثابتة +طفايات الحريق أنظمة مأخذ الحريق الداخلية والخارجية +المعدات والمحابس والتوصيلات الخاصة بنظم الحماية من الحريق +اللوحة الخاصة بمضخة الحريق)وكذلك نظام الإنذار الخاص بالحريق والذي يشمل ( لوحة الإنذار الرئيسية – لوحة الإشارات – لوحة الإشارات المساعدة – كاشفات الحريق- مصابيح الإشارة المساعدة –نقاط النداء اليدوية- أجهزة التنبيه السمعية والمرئية المصدر الاحتياطي (المولد)- وخانق الحريق- إنارة الطوارئ-مراوح دفع الهواء بسلالم الطوارئ-مراوح شفط ودفع الهواء بالبدروم –شبكة تمديدات الكهربائية وجميع الأنظمة الخاصة بهذا النظام والمتطلبات الخاصة بتشغيل النظام والتأكد من جاهزية جميع ما ورد .',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '3-	يلتزم الطرف الأول بعمل جدول زيارات دورية على آلا يقل عن (12) زيارة سنوية بمعدل زيارة واحدة شهريا وتسجيل نتائج الزيارة في سجل السلامة الخاص بالمنشاة وإرفاق تقرير الصيانة بالسجل وتزويد الطرف الثاني بالتقرير.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '4-	يلتزم الطرف الأول بالحضور أو من ينوب عنه من الفنيين في حالة حدوث عطل مفاجئ ولا تعد تلك ضمن الزيارات المجدولة وتسجل في سجل السلامة الخاص لدى المنشأة.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '5-	على الطرف الأول أو الثاني إشعار الدفاع المدني رسميا بأي خلل يؤثر على استمرارية عمل تلك الأنظمة.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '6-	يجب على الطرف الذي يرغب في فسخ العقد إشعار الدفاع المدني رسميا والطرف الأخربرغبته في فسخ العقد قبل شهر من الانتهاء مبدياًأسباب ذلك وعلى الطرف الثاني إحضار عقد صيانة جديد قبل 10 أيام من نهاية العقد الأولوتقديمه للدفاع المدني علي أن يبدأ العقد الجديد مع نهاية العقد السابق.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '7-	يعتبر العقد ساري المفعول في حالة انتهاء مدته مالم يتعارض مع الفقرة السابقة ويعد ملزم للطرفين.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '8-	يلتزم الطرف الثاني بتأمين ما يلزم من قطع غيار اللازمة فور طلبها منه وعلى الطرف الأولإشعار الدفاع المدني عند عدم تأمينها خلال 48 ساعة من تاريخ إبلاغ الطرف الثاني. ',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '9-	يلتزم الطرف الثاني بتعبئة طفايات الحريق ونظام الإطفاء بالغازات بعد إعداد تقرير من قبل الطرف الأول بضرورة تعبئتها أو استبدالها أو الاتفاق مع الطرف الأول على تعبئتها وعلى الطرف الأولإشعار الدفاع المدني كتابيا عند عدم تأمينها خلال 48 ساعة من تاريخ إبلاغ الطرف الثاني.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '10-	في حالة تأخر الطرف الأول عن الصيانة على الطرف الثاني إشعار الدفاع المدني بذلك.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '11-	يلتزم الطرف الثاني بالمحافظة على جميع الأنظمة وعدم السماح بالعبث بها.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '12-	بمجرد التوقيع على هذا العقد يعتبر الطرف الأول مسئولاً عن صيانة معدات الإنذاروالإطفاء بجميع الأنظمة الواردة في الفقرة ثانيا. وأي خلل أو عيب فيها تكون تحت مسئوليته ويتحمل جميع ما يترتب على ذلك من إجراءات بما فيها إحالة الموضوع للجنة لنظر في مخالفات نظام ولوائح وتعليمات الدفاع المدني لتطبيق الغرامة المستحقة.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '13-	على الطرف الأول اتخاذ احتياطات الأمن والسلامة أثناء العمل.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '14-	يلتزم الطرف الأول بإحضار أجهزة الرفع أو النقل التي يتطلبها أثناء العمل.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '15-	على الطرف الأول الالتزام بقوانين وأنظمة المملكة العربية السعودية.',
          paddingAfter: 12,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue:
              '16-	حرر هذا العقد بتاريخ {{paramContractAddDate}} هجرياً من نسختين استلم كلا من الطرفين النسخة الخاصة به.',
          parameters: {
            'paramContractAddDate': HijriDateParameter,
          },
          paddingAfter: 12,
        ),
      ),
      ReportItem(
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
    for (int i = 1; i < (categories?.length ?? 0); i++) {
      final cat = categories![i];
      items.add(
        ReportItem(
          text: ReportTextItem(
            templateValue: '• ${cat.arName}: -',
            paddingAfter: 0,
            bold: true,
            underlined: true,
          ),
        ),
      );
      items.add(
        ReportItem(
          table: ReportTableItem(
            types: [],
            categoryIndex: i,
          ),
        ),
      );
    }

    if ((categories?.length ?? 0) > 0) {
      final cat = categories![0];
      items.add(
        ReportItem(
          text: ReportTextItem(
            templateValue: '• ${cat.arName}: -',
            paddingAfter: 0,
            bold: true,
            underlined: true,
          ),
        ),
      );
      items.add(
        ReportItem(
          table: ReportTableItem(
            types: [],
            categoryIndex: 0,
          ),
        ),
      );
    }

    // Trailing signature and closing items
    items.addAll([
      ReportItem(
        text: ReportTextItem(
          templateValue: 'هذا وتقبلوا منا فائق التحية والتقدير',
          paddingAfter: 24,
          bold: true,
          align: TextAlign.center,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'الطرف الأول: {{param_name}} ',
          parameters: {
            'param_name': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
      ReportItem(
        text: ReportTextItem(
          templateValue: 'الطرف الثاني: {{param_name}} ',
          parameters: {
            'param_name': StringParameter,
          },
          paddingAfter: 0,
        ),
      ),
    ]);
    return items;
  }
}
