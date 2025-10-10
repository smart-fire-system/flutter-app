import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';

class ContractsCommon {
  List<String> typesForCategory(ContractData contract, int? categoryIndex) {
    if (categoryIndex == null) return const [];
    final List<String> names = [];
    for (final cat in contract.componentsData.categories) {
      for (final item in cat.items) {
        if (item.categoryIndex == categoryIndex) {
          final String name = (item.arName.trim().isNotEmpty
                  ? item.arName.trim()
                  : item.enName.trim())
              .trim();
          if (!names.contains(name)) names.add(name);
        }
      }
    }
    return names;
  }

  bool isCategoryTitle(ReportTextItem item) {
    final t = item.templateValue.trim();
    return t.startsWith('• ');
  }

  String paramText(ContractData contract, String key) {
    switch (key) {
      case 'paramContractNumber':
        return contract.paramContractNumber ?? '';
      case 'paramContractAgreementDay':
        return contract.paramContractAgreementDay ?? '';
      case 'paramContractAgreementHijriDate':
        return contract.paramContractAgreementHijriDate ?? '';
      case 'paramContractAgreementGregorianDate':
        return contract.paramContractAgreementGregorianDate ?? '';
      case 'paramFirstPartyName':
        return contract.paramFirstPartyName ?? '';
      case 'paramFirstPartyCommNumber':
        return contract.paramFirstPartyCommNumber ?? '';
      case 'paramFirstPartyAddress':
        return contract.paramFirstPartyAddress ?? '';
      case 'paramFirstPartyRep':
        return contract.paramFirstPartyRep ?? '';
      case 'paramFirstPartyRepIdNumber':
        return contract.paramFirstPartyRepIdNumber ?? '';
      case 'paramFirstPartyG':
        return contract.paramFirstPartyG ?? '';
      case 'paramSecondPartyName':
        return contract.paramSecondPartyName ?? '';
      case 'paramSecondPartyCommNumber':
        return contract.paramSecondPartyCommNumber ?? '';
      case 'paramSecondPartyAddress':
        return contract.paramSecondPartyAddress ?? '';
      case 'paramSecondPartyRep':
        return contract.paramSecondPartyRep ?? '';
      case 'paramSecondPartyRepIdNumber':
        return contract.paramSecondPartyRepIdNumber ?? '';
      case 'paramSecondPartyG':
        return contract.paramSecondPartyG ?? '';
      case 'paramContractAddDate':
        return contract.paramContractAddDate ?? '';
      case 'paramContractPeriod':
        return contract.paramContractPeriod ?? '';
      case 'paramContractAmount':
        return contract.paramContractAmount ?? '';
      default:
        return '';
    }
  }

  String renderTemplate(ContractData contract, ReportTextItem item) {
    String result = item.templateValue;
    if (item.parameters != null) {
      item.parameters!.forEach((key, type) {
        final text = paramText(contract, key);
        result = result.replaceAll('{{$key}}', text);
      });
    }
    return result;
  }

  static bool isContractExpired(ContractData contract) {
    if (contract.metaData.state == ContractState.active) {
      final DateTime today = DateTime.now();
      final DateTime? end = contract.metaData.endDate;
      if (end != null &&
          !end.isBefore(DateTime(today.year, today.month, today.day))) {
        return false;
      } else {
        return true;
      }
    }
    // For non-active states, we still show the last node label based on end date if present
    final DateTime today2 = DateTime.now();
    final DateTime? end2 = contract.metaData.endDate;
    if (end2 != null &&
        !end2.isBefore(DateTime(today2.year, today2.month, today2.day))) {
      return false;
    }
    return true;
  }
}
