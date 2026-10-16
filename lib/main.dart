import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/payment_remote_data_source.dart';
import 'data/repositories/insurance_repository_impl.dart';
import 'presentation/bloc/insurance_bloc.dart';
import 'presentation/pages/insurance_input_page.dart';

void main() {
  final paymentDataSource = MockPaymentRemoteDataSource();
  final insuranceRepository = InsuranceRepositoryImpl(
    dataSource: paymentDataSource,
  );

  runApp(
    InsuranceApp(
      insuranceRepository: insuranceRepository,
    ),
  );
}

class InsuranceApp extends StatelessWidget {
  final InsuranceRepositoryImpl insuranceRepository;

  const InsuranceApp({
    super.key,
    required this.insuranceRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InsuranceBloc>(
      create: (context) => InsuranceBloc(
        repository: insuranceRepository,
      ),
      child: MaterialApp(
        title: 'Vehicle Insurance Quote Generator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        ),
        home: const InsuranceInputPage(),
      ),
    );
  }
}
