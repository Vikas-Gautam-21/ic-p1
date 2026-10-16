enum InsuranceAddOn {
  zeroDepreciation(
    cost: 3500.0,
    title: 'Zero Depreciation',
    subtitle: 'Covers replacement cost without factoring depreciation',
  ),
  roadsideAssistance(
    cost: 800.0,
    title: '24x7 Roadside Assistance',
    subtitle: 'Emergency assistance for breakdown, battery, and towing',
  ),
  engineProtection(
    cost: 1800.0,
    title: 'Engine Protection',
    subtitle: 'Safeguards against engine damage and hydrostatic lock',
  ),
  consumablesCover(
    cost: 600.0,
    title: 'Consumables Cover',
    subtitle: 'Reimburses cost of consumable materials used during repairs',
  );

  final double cost;
  final String title;
  final String subtitle;

  const InsuranceAddOn({
    required this.cost,
    required this.title,
    required this.subtitle,
  });
}
