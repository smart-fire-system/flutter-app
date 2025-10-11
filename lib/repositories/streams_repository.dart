import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';

class StreamsRepository {
  final FirebaseFirestore _firestore;
  final AppRepository appRepository;
  final _contractsController = StreamController<QuerySnapshot>.broadcast();
  final _reportsMetaDataController =
      StreamController<QuerySnapshot>.broadcast();
  final _visitReportsController = StreamController<QuerySnapshot>.broadcast();
  final _signaturesController = StreamController<QuerySnapshot>.broadcast();
  final _authStateChangesController = StreamController<void>.broadcast();
  final _branchesController = StreamController<QuerySnapshot>.broadcast();
  final _companiesController = StreamController<QuerySnapshot>.broadcast();
  final _usersController = StreamController<QuerySnapshot>.broadcast();
  final _masterAdminsController = StreamController<QuerySnapshot>.broadcast();
  final _adminsController = StreamController<QuerySnapshot>.broadcast();
  final _companyManagersController =
      StreamController<QuerySnapshot>.broadcast();
  final _branchManagersController = StreamController<QuerySnapshot>.broadcast();
  final _employeesController = StreamController<QuerySnapshot>.broadcast();
  final _clientsController = StreamController<QuerySnapshot>.broadcast();

  StreamsRepository({required this.appRepository})
      : _firestore = FirebaseFirestore.instance {
    appRepository.authStateStream.listen((status) {
      //startBranchesStream();
      //startCompaniesStream();
      //startUsersStream();
      startContractsStream();
      startReportsMetaDataStream();
      startVisitReportsStream();
      startSignaturesStream();
    });
  }

  Stream<QuerySnapshot> get contractsStream => _contractsController.stream;
  Stream<QuerySnapshot> get reportsMetaDataStream =>
      _reportsMetaDataController.stream;
  Stream<QuerySnapshot> get visitReportsStream =>
      _visitReportsController.stream;
  Stream<QuerySnapshot> get signaturesStream => _signaturesController.stream;
  Stream<void> get authStateChangesStream => _authStateChangesController.stream;
  Stream<QuerySnapshot> get branchesStream => _branchesController.stream;
  Stream<QuerySnapshot> get companiesStream => _companiesController.stream;
  Stream<QuerySnapshot> get usersStream => _usersController.stream;
  Stream<QuerySnapshot> get masterAdminsStream =>
      _masterAdminsController.stream;
  Stream<QuerySnapshot> get adminsStream => _adminsController.stream;
  Stream<QuerySnapshot> get companyManagersStream =>
      _companyManagersController.stream;
  Stream<QuerySnapshot> get branchManagersStream =>
      _branchManagersController.stream;
  Stream<QuerySnapshot> get employeesStream => _employeesController.stream;
  Stream<QuerySnapshot> get clientsStream => _clientsController.stream;

  StreamSubscription? _reportsMetaDataSubscription;
  StreamSubscription? _contractsSubscription;
  StreamSubscription? _visitReportsSubscription;
  StreamSubscription? _signaturesSubscription;
  StreamSubscription? _branchesSubscription;
  StreamSubscription? _companiesSubscription;
  StreamSubscription? _usersSubscription;
  StreamSubscription? _masterAdminsSubscription;
  StreamSubscription? _adminsSubscription;
  StreamSubscription? _companyManagersSubscription;
  StreamSubscription? _branchManagersSubscription;
  StreamSubscription? _employeesSubscription;
  StreamSubscription? _clientsSubscription;

  void startBranchesStream() {
    stopStream(_branchesSubscription);
    Query collection = _firestore.collection('branches');
    if (appRepository.userRole is CompanyManager) {
      collection = collection.where('company',
          isEqualTo: appRepository.userRole.company.id);
    } else if (appRepository.userRole is BranchManager ||
        appRepository.userRole is Employee ||
        appRepository.userRole is Client) {
      collection = collection.where(FieldPath.documentId,
          isEqualTo: appRepository.userRole.branch.id);
    }
    collection = collection.orderBy('createdAt', descending: true);
    _branchesSubscription = collection.snapshots().listen((snapshot) {
      _branchesController.add(snapshot);
    });
  }

  void startCompaniesStream() {
    stopStream(_companiesSubscription);
    Query collection = _firestore.collection('companies');
    if (appRepository.userRole is CompanyManager) {
      collection = collection.where(FieldPath.documentId,
          isEqualTo: appRepository.userRole.company.id);
    } else if (appRepository.userRole is BranchManager ||
        appRepository.userRole is Employee ||
        appRepository.userRole is Client) {
      collection = collection.where(FieldPath.documentId,
          isEqualTo: appRepository.userRole.branch.company.id);
    }
    collection = collection.orderBy('createdAt', descending: true);
    _companiesSubscription = collection.snapshots().listen((snapshot) {
      _companiesController.add(snapshot);
    });
  }

  void startUsersStream() {
    stopStream(_usersSubscription);
    stopStream(_masterAdminsSubscription);
    stopStream(_adminsSubscription);
    stopStream(_companyManagersSubscription);
    stopStream(_branchManagersSubscription);
    stopStream(_employeesSubscription);
    stopStream(_clientsSubscription);
    _usersSubscription =
        _firestore.collection('users').snapshots().listen((snapshot) {
      _usersController.add(snapshot);
    });
    _masterAdminsSubscription =
        _firestore.collection('masterAdmins').snapshots().listen((snapshot) {
      _masterAdminsController.add(snapshot);
    });
    _adminsSubscription =
        _firestore.collection('admins').snapshots().listen((snapshot) {
      _adminsController.add(snapshot);
    });
    _companyManagersSubscription =
        _firestore.collection('companyManagers').snapshots().listen((snapshot) {
      _companyManagersController.add(snapshot);
    });
    _branchManagersSubscription =
        _firestore.collection('branchManagers').snapshots().listen((snapshot) {
      _branchManagersController.add(snapshot);
    });
    _employeesSubscription =
        _firestore.collection('employees').snapshots().listen((snapshot) {
      _employeesController.add(snapshot);
    });
    _clientsSubscription =
        _firestore.collection('clients').snapshots().listen((snapshot) {
      _clientsController.add(snapshot);
    });
  }

  void startContractsStream() {
    stopStream(_contractsSubscription);
    Query collection = _firestore.collection('contracts');
    if (appRepository.userRole is CompanyManager) {
      collection = collection.where('companyId',
          isEqualTo: appRepository.userRole.company.id);
    } else if (appRepository.userRole is BranchManager) {
      collection = collection.where('branchId',
          isEqualTo: appRepository.userRole.branch.id);
    } else {
      collection = collection.where('sharedWith',
          arrayContains: appRepository.userRole.info.id);
    }
    collection = collection.orderBy('createdAt', descending: true);
    _contractsSubscription = collection.snapshots().listen((snapshot) {
      _contractsController.add(snapshot);
    });
  }

  void startVisitReportsStream() {
    stopStream(_visitReportsSubscription);
    Query collection = _firestore.collection('visitReports');
    if (appRepository.userRole is CompanyManager) {
      collection = collection.where('companyId',
          isEqualTo: appRepository.userRole.company.id);
    } else if (appRepository.userRole is BranchManager) {
      collection = collection.where('branchId',
          isEqualTo: appRepository.userRole.branch.id);
    } else {
      collection = collection.where('sharedWith',
          arrayContains: appRepository.userRole.info.id);
    }
    collection = collection.orderBy('createdAt', descending: true);
    _visitReportsSubscription = collection.snapshots().listen((snapshot) {
      _visitReportsController.add(snapshot);
    });
  }

  void startReportsMetaDataStream() {
    stopStream(_reportsMetaDataSubscription);
    _reportsMetaDataSubscription =
        _firestore.collection('reportsMetaData').snapshots().listen((snapshot) {
      _reportsMetaDataController.add(snapshot);
    });
  }

  void startSignaturesStream() {
    stopStream(_signaturesSubscription);
    _signaturesSubscription =
        _firestore.collection('signatures').snapshots().listen((snapshot) {
      _signaturesController.add(snapshot);
    });
  }

  void stopStream(StreamSubscription? subscription) {
    if (subscription != null) {
      subscription.cancel();
      subscription = null;
    }
  }
}
