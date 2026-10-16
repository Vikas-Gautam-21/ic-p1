import 'package:flutter_test/flutter_test.dart';
import 'package:ic_p1/domain/entities/insurance_addon.dart';
import 'package:ic_p1/domain/entities/insurance_input_entity.dart';
import 'package:ic_p1/domain/entities/vehicle_type.dart';
import 'package:ic_p1/domain/services/premium_calculator.dart';

void main() {
  group('PremiumCalculator', () {
    test('calculates correct premium for hatchback with no addons and zero ncb', () {
      final input = InsuranceInputEntity(
        vehicleNumber: 'MH-02-AB-1234',
        manufacturingYear: 2022,
        vehicleType: VehicleType.hatchback,
        idv: 500000.0,
        activeAddOns: const {},
        ncbPercentage: 0,
      );

      final quote = PremiumCalculator.calculate(input);

      expect(quote.basePremium, 10000.0);
      expect(quote.ncbDiscount, 0.0);
      expect(quote.addOnTotal, 0.0);
      expect(quote.netPremium, 10000.0);
      expect(quote.gstAmount, 1800.0);
      expect(quote.totalPremium, 11800.0);
    });

    test('calculates correct premium for sedan with ncb and addons', () {
      final input = InsuranceInputEntity(
        vehicleNumber: 'DL-01-XY-9876',
        manufacturingYear: 2021,
        vehicleType: VehicleType.sedan,
        idv: 600000.0,
        activeAddOns: const {
          InsuranceAddOn.zeroDepreciation,
          InsuranceAddOn.roadsideAssistance,
        },
        ncbPercentage: 20,
      );

      final quote = PremiumCalculator.calculate(input);

      expect(quote.basePremium, 18000.0);
      expect(quote.ncbDiscount, 3600.0);
      expect(quote.addOnTotal, 4300.0);
      expect(quote.netPremium, 18700.0);
      expect(quote.gstAmount, closeTo(3366.0, 0.01));
      expect(quote.totalPremium, closeTo(22066.0, 0.01));
    });

    test('calculates correct premium for suv with 50 percent ncb and all addons', () {
      final input = InsuranceInputEntity(
        vehicleNumber: 'KA-05-MN-5555',
        manufacturingYear: 2023,
        vehicleType: VehicleType.suv,
        idv: 1000000.0,
        activeAddOns: {
          InsuranceAddOn.zeroDepreciation,
          InsuranceAddOn.roadsideAssistance,
          InsuranceAddOn.engineProtection,
          InsuranceAddOn.consumablesCover,
        },
        ncbPercentage: 50,
      );

      final quote = PremiumCalculator.calculate(input);

      expect(quote.basePremium, 40000.0);
      expect(quote.ncbDiscount, 20000.0);
      expect(quote.addOnTotal, 6700.0);
      expect(quote.netPremium, 26700.0);
      expect(quote.gstAmount, closeTo(4806.0, 0.01));
      expect(quote.totalPremium, closeTo(31506.0, 0.01));
    });
  });
}
