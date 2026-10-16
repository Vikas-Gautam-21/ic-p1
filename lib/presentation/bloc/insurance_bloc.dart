import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/insurance_addon.dart';
import '../../domain/repositories/insurance_repository.dart';
import '../../domain/services/premium_calculator.dart';
import 'insurance_event.dart';
import 'insurance_state.dart';

class InsuranceBloc extends Bloc<InsuranceEvent, InsuranceState> {
  final InsuranceRepository repository;

  InsuranceBloc({required this.repository}) : super(InsuranceState.initial()) {
    on<VehicleNumberChanged>(_onVehicleNumberChanged);
    on<ManufacturingYearChanged>(_onManufacturingYearChanged);
    on<VehicleTypeChanged>(_onVehicleTypeChanged);
    on<IdvChanged>(_onIdvChanged);
    on<AddOnToggled>(_onAddOnToggled);
    on<NcbPercentageChanged>(_onNcbPercentageChanged);
    on<RecalculatePremium>(_onRecalculatePremium);
    on<SubmitPayment>(_onSubmitPayment);
    on<ResetPaymentStatus>(_onResetPaymentStatus);

    add(const RecalculatePremium());
  }

  void _onVehicleNumberChanged(
    VehicleNumberChanged event,
    Emitter<InsuranceState> emit,
  ) {
    final updatedInput = state.input.copyWith(vehicleNumber: event.vehicleNumber);
    final calculatedQuote = PremiumCalculator.calculate(updatedInput);
    emit(state.copyWith(
      input: updatedInput,
      quote: calculatedQuote,
      status: InsuranceStatus.inputting,
    ));
  }

  void _onManufacturingYearChanged(
    ManufacturingYearChanged event,
    Emitter<InsuranceState> emit,
  ) {
    final updatedInput = state.input.copyWith(manufacturingYear: event.year);
    final calculatedQuote = PremiumCalculator.calculate(updatedInput);
    emit(state.copyWith(
      input: updatedInput,
      quote: calculatedQuote,
      status: InsuranceStatus.inputting,
    ));
  }

  void _onVehicleTypeChanged(
    VehicleTypeChanged event,
    Emitter<InsuranceState> emit,
  ) {
    final updatedInput = state.input.copyWith(vehicleType: event.vehicleType);
    final calculatedQuote = PremiumCalculator.calculate(updatedInput);
    emit(state.copyWith(
      input: updatedInput,
      quote: calculatedQuote,
      status: InsuranceStatus.inputting,
    ));
  }

  void _onIdvChanged(
    IdvChanged event,
    Emitter<InsuranceState> emit,
  ) {
    final updatedInput = state.input.copyWith(idv: event.idv);
    final calculatedQuote = PremiumCalculator.calculate(updatedInput);
    emit(state.copyWith(
      input: updatedInput,
      quote: calculatedQuote,
      status: InsuranceStatus.inputting,
    ));
  }

  void _onAddOnToggled(
    AddOnToggled event,
    Emitter<InsuranceState> emit,
  ) {
    final updatedAddOns = Set<InsuranceAddOn>.from(state.input.activeAddOns);
    if (updatedAddOns.contains(event.addOn)) {
      updatedAddOns.remove(event.addOn);
    } else {
      updatedAddOns.add(event.addOn);
    }
    final updatedInput = state.input.copyWith(activeAddOns: updatedAddOns);
    final calculatedQuote = PremiumCalculator.calculate(updatedInput);
    emit(state.copyWith(
      input: updatedInput,
      quote: calculatedQuote,
      status: InsuranceStatus.inputting,
    ));
  }

  void _onNcbPercentageChanged(
    NcbPercentageChanged event,
    Emitter<InsuranceState> emit,
  ) {
    final updatedInput = state.input.copyWith(ncbPercentage: event.ncbPercentage);
    final calculatedQuote = PremiumCalculator.calculate(updatedInput);
    emit(state.copyWith(
      input: updatedInput,
      quote: calculatedQuote,
      status: InsuranceStatus.inputting,
    ));
  }

  void _onRecalculatePremium(
    RecalculatePremium event,
    Emitter<InsuranceState> emit,
  ) {
    final calculatedQuote = PremiumCalculator.calculate(state.input);
    emit(state.copyWith(
      quote: calculatedQuote,
      status: InsuranceStatus.inputting,
    ));
  }

  Future<void> _onSubmitPayment(
    SubmitPayment event,
    Emitter<InsuranceState> emit,
  ) async {
    emit(state.copyWith(status: InsuranceStatus.submittingPayment));
    try {
      final success = await repository.processPayment(state.quote);
      if (success) {
        emit(state.copyWith(status: InsuranceStatus.paymentSuccess));
      } else {
        emit(state.copyWith(
          status: InsuranceStatus.paymentFailure,
          errorMessage: 'Payment transaction failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: InsuranceStatus.paymentFailure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetPaymentStatus(
    ResetPaymentStatus event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(status: InsuranceStatus.inputting));
  }
}
