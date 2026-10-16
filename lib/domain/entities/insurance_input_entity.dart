import 'package:equatable/equatable.dart';
import 'insurance_addon.dart';
import 'vehicle_type.dart';

class InsuranceInputEntity extends Equatable {
  final String vehicleNumber;
  final int manufacturingYear;
  final VehicleType vehicleType;
  final double idv;
  final Set<InsuranceAddOn> activeAddOns;
  final int ncbPercentage;

  const InsuranceInputEntity({
    required this.vehicleNumber,
    required this.manufacturingYear,
    required this.vehicleType,
    required this.idv,
    required this.activeAddOns,
    required this.ncbPercentage,
  });

  factory InsuranceInputEntity.initial() {
    return InsuranceInputEntity(
      vehicleNumber: '',
      manufacturingYear: DateTime.now().year,
      vehicleType: VehicleType.hatchback,
      idv: 500000.0,
      activeAddOns: const <InsuranceAddOn>{},
      ncbPercentage: 0,
    );
  }

  InsuranceInputEntity copyWith({
    String? vehicleNumber,
    int? manufacturingYear,
    VehicleType? vehicleType,
    double? idv,
    Set<InsuranceAddOn>? activeAddOns,
    int? ncbPercentage,
  }) {
    return InsuranceInputEntity(
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      manufacturingYear: manufacturingYear ?? this.manufacturingYear,
      vehicleType: vehicleType ?? this.vehicleType,
      idv: idv ?? this.idv,
      activeAddOns: activeAddOns ?? this.activeAddOns,
      ncbPercentage: ncbPercentage ?? this.ncbPercentage,
    );
  }

  @override
  List<Object?> get props => [
        vehicleNumber,
        manufacturingYear,
        vehicleType,
        idv,
        activeAddOns,
        ncbPercentage,
      ];
}
