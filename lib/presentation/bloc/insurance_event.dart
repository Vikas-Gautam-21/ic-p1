import 'package:equatable/equatable.dart';
import '../../domain/entities/insurance_addon.dart';
import '../../domain/entities/vehicle_type.dart';

abstract class InsuranceEvent extends Equatable {
  const InsuranceEvent();

  @override
  List<Object?> get props => [];
}

class VehicleNumberChanged extends InsuranceEvent {
  final String vehicleNumber;

  const VehicleNumberChanged(this.vehicleNumber);

  @override
  List<Object?> get props => [vehicleNumber];
}

class ManufacturingYearChanged extends InsuranceEvent {
  final int year;

  const ManufacturingYearChanged(this.year);

  @override
  List<Object?> get props => [year];
}

class VehicleTypeChanged extends InsuranceEvent {
  final VehicleType vehicleType;

  const VehicleTypeChanged(this.vehicleType);

  @override
  List<Object?> get props => [vehicleType];
}

class IdvChanged extends InsuranceEvent {
  final double idv;

  const IdvChanged(this.idv);

  @override
  List<Object?> get props => [idv];
}

class AddOnToggled extends InsuranceEvent {
  final InsuranceAddOn addOn;

  const AddOnToggled(this.addOn);

  @override
  List<Object?> get props => [addOn];
}

class NcbPercentageChanged extends InsuranceEvent {
  final int ncbPercentage;

  const NcbPercentageChanged(this.ncbPercentage);

  @override
  List<Object?> get props => [ncbPercentage];
}

class RecalculatePremium extends InsuranceEvent {
  const RecalculatePremium();
}

class SubmitPayment extends InsuranceEvent {
  const SubmitPayment();
}

class ResetPaymentStatus extends InsuranceEvent {
  const ResetPaymentStatus();
}
