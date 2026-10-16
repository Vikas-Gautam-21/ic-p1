import '../entities/insurance_input_entity.dart';
import '../entities/quote_breakdown_entity.dart';

class PremiumCalculator {
  static const double gstRate = 0.18;

  static QuoteBreakdownEntity calculate(InsuranceInputEntity input) {
    final double basePremium = input.idv * input.vehicleType.factor;
    final double ncbDiscount = basePremium * (input.ncbPercentage / 100.0);
    final double addOnTotal = input.activeAddOns.fold(
      0.0,
      (total, addOn) => total + addOn.cost,
    );
    final double netPremium = (basePremium - ncbDiscount) + addOnTotal;
    final double gstAmount = netPremium * gstRate;
    final double totalPremium = netPremium + gstAmount;

    return QuoteBreakdownEntity(
      basePremium: basePremium,
      ncbDiscount: ncbDiscount,
      addOnTotal: addOnTotal,
      netPremium: netPremium,
      gstAmount: gstAmount,
      totalPremium: totalPremium,
    );
  }
}
