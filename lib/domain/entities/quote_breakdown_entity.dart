import 'package:equatable/equatable.dart';

class QuoteBreakdownEntity extends Equatable {
  final double basePremium;
  final double ncbDiscount;
  final double addOnTotal;
  final double netPremium;
  final double gstAmount;
  final double totalPremium;

  const QuoteBreakdownEntity({
    required this.basePremium,
    required this.ncbDiscount,
    required this.addOnTotal,
    required this.netPremium,
    required this.gstAmount,
    required this.totalPremium,
  });

  factory QuoteBreakdownEntity.zero() {
    return const QuoteBreakdownEntity(
      basePremium: 0.0,
      ncbDiscount: 0.0,
      addOnTotal: 0.0,
      netPremium: 0.0,
      gstAmount: 0.0,
      totalPremium: 0.0,
    );
  }

  @override
  List<Object?> get props => [
        basePremium,
        ncbDiscount,
        addOnTotal,
        netPremium,
        gstAmount,
        totalPremium,
      ];
}
