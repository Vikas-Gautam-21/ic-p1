abstract class PaymentRemoteDataSource {
  Future<bool> executePayment({required double amount});
}

class MockPaymentRemoteDataSource implements PaymentRemoteDataSource {
  @override
  Future<bool> executePayment({required double amount}) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
