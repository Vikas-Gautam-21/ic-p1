enum VehicleType {
  hatchback(factor: 0.02, displayName: 'Hatchback'),
  sedan(factor: 0.03, displayName: 'Sedan'),
  suv(factor: 0.04, displayName: 'SUV');

  final double factor;
  final String displayName;

  const VehicleType({
    required this.factor,
    required this.displayName,
  });
}
