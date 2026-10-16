import 'package:flutter_test/flutter_test.dart';
import 'package:ic_p1/data/datasources/payment_remote_data_source.dart';
import 'package:ic_p1/data/repositories/insurance_repository_impl.dart';
import 'package:ic_p1/domain/entities/insurance_addon.dart';
import 'package:ic_p1/domain/entities/vehicle_type.dart';
import 'package:ic_p1/presentation/bloc/insurance_bloc.dart';
import 'package:ic_p1/presentation/bloc/insurance_event.dart';
import 'package:ic_p1/presentation/bloc/insurance_state.dart';

void main() {
  group('InsuranceBloc', () {
    late InsuranceBloc bloc;
    late InsuranceRepositoryImpl repository;

    setUp(() {
      final dataSource = MockPaymentRemoteDataSource();
      repository = InsuranceRepositoryImpl(dataSource: dataSource);
      bloc = InsuranceBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has default values and non-zero quote', () async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.status, InsuranceStatus.inputting);
      expect(bloc.state.input.vehicleType, VehicleType.hatchback);
      expect(bloc.state.quote.totalPremium, greaterThan(0));
    });

    test('recalculates premium reactively when vehicle type changes', () async {
      bloc.add(const VehicleTypeChanged(VehicleType.suv));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.input.vehicleType, VehicleType.suv);
      expect(bloc.state.quote.basePremium, 20000.0);
    });

    test('recalculates premium reactively when addon is toggled', () async {
      final initialTotal = bloc.state.quote.totalPremium;
      bloc.add(const AddOnToggled(InsuranceAddOn.zeroDepreciation));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.input.activeAddOns.contains(InsuranceAddOn.zeroDepreciation), isTrue);
      expect(bloc.state.quote.totalPremium, greaterThan(initialTotal));
    });
  });
}
