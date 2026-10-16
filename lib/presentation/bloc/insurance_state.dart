import 'package:equatable/equatable.dart';
import '../../domain/entities/insurance_input_entity.dart';
import '../../domain/entities/quote_breakdown_entity.dart';

enum InsuranceStatus {
  inputting,
  submittingPayment,
  paymentSuccess,
  paymentFailure,
}

class InsuranceState extends Equatable {
  final InsuranceInputEntity input;
  final QuoteBreakdownEntity quote;
  final InsuranceStatus status;
  final String? errorMessage;

  const InsuranceState({
    required this.input,
    required this.quote,
    required this.status,
    this.errorMessage,
  });

  factory InsuranceState.initial() {
    final initialInput = InsuranceInputEntity.initial();
    return InsuranceState(
      input: initialInput,
      quote: QuoteBreakdownEntity.zero(),
      status: InsuranceStatus.inputting,
    );
  }

  bool get isSubmitting => status == InsuranceStatus.submittingPayment;
  bool get isSuccess => status == InsuranceStatus.paymentSuccess;
  bool get isFailure => status == InsuranceStatus.paymentFailure;

  InsuranceState copyWith({
    InsuranceInputEntity? input,
    QuoteBreakdownEntity? quote,
    InsuranceStatus? status,
    String? errorMessage,
  }) {
    return InsuranceState(
      input: input ?? this.input,
      quote: quote ?? this.quote,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [input, quote, status, errorMessage];
}
