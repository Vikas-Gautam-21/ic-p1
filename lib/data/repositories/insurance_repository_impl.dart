import '../../domain/entities/quote_breakdown_entity.dart';
import '../../domain/repositories/insurance_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class InsuranceRepositoryImpl implements InsuranceRepository {
  final PaymentRemoteDataSource dataSource;

  InsuranceRepositoryImpl({required this.dataSource});

  @override
  Future<bool> processPayment(QuoteBreakdownEntity quote) async {
    return await dataSource.executePayment(amount: quote.totalPremium);
  }
}
