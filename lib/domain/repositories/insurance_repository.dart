import '../entities/quote_breakdown_entity.dart';

abstract class InsuranceRepository {
  Future<bool> processPayment(QuoteBreakdownEntity quote);
}
