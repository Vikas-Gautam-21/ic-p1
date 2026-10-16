import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/insurance_addon.dart';
import '../../domain/entities/vehicle_type.dart';
import '../bloc/insurance_bloc.dart';
import '../bloc/insurance_event.dart';
import '../bloc/insurance_state.dart';
import 'quote_summary_page.dart';

class InsuranceInputPage extends StatefulWidget {
  const InsuranceInputPage({super.key});

  @override
  State<InsuranceInputPage> createState() => _InsuranceInputPageState();
}

class _InsuranceInputPageState extends State<InsuranceInputPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _vehicleNumberController;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final RegExp _vehicleRegex = RegExp(r'^[A-Z]{2}-\d{2}-[A-Z]{2}-\d{4}$');

  final List<int> _years = List<int>.generate(
    15,
    (index) => DateTime.now().year - index,
  );

  final List<int> _ncbPercentages = const [0, 20, 25, 35, 50];

  @override
  void initState() {
    super.initState();
    final currentNumber = context.read<InsuranceBloc>().state.input.vehicleNumber;
    _vehicleNumberController = TextEditingController(text: currentNumber);
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  void _onNavigateToSummary() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QuoteSummaryPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          'Vehicle Insurance Quote',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: BlocBuilder<InsuranceBloc, InsuranceState>(
        builder: (context, state) {
          final input = state.input;
          final quote = state.quote;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                _buildLiveEstimateHeader(quote),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Vehicle Information',
                  icon: Icons.directions_car_filled_rounded,
                  children: [
                    TextFormField(
                      controller: _vehicleNumberController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9-]')),
                        LengthLimitingTextInputFormatter(13),
                        _UpperCaseTextFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Registration Number',
                        hintText: 'e.g. MH-02-AB-1234',
                        prefixIcon: const Icon(Icons.pin_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter vehicle registration number';
                        }
                        if (!_vehicleRegex.hasMatch(value.trim())) {
                          return 'Format must match XX-00-XX-0000 (e.g. MH-02-AB-1234)';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context
                            .read<InsuranceBloc>()
                            .add(VehicleNumberChanged(value.trim()));
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: input.manufacturingYear,
                      decoration: InputDecoration(
                        labelText: 'Manufacturing Year',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _years.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }).toList(),
                      onChanged: (selectedYear) {
                        if (selectedYear != null) {
                          context
                              .read<InsuranceBloc>()
                              .add(ManufacturingYearChanged(selectedYear));
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Vehicle Type',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<VehicleType>(
                      segments: const [
                        ButtonSegment<VehicleType>(
                          value: VehicleType.hatchback,
                          label: Text('Hatchback'),
                          icon: Icon(Icons.directions_car),
                        ),
                        ButtonSegment<VehicleType>(
                          value: VehicleType.sedan,
                          label: Text('Sedan'),
                          icon: Icon(Icons.airport_shuttle),
                        ),
                        ButtonSegment<VehicleType>(
                          value: VehicleType.suv,
                          label: Text('SUV'),
                          icon: Icon(Icons.directions_bus),
                        ),
                      ],
                      selected: {input.vehicleType},
                      onSelectionChanged: (selectedSet) {
                        if (selectedSet.isNotEmpty) {
                          context
                              .read<InsuranceBloc>()
                              .add(VehicleTypeChanged(selectedSet.first));
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Insured Declared Value (IDV)',
                  icon: Icons.shield_outlined,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Declared Value',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          _currencyFormat.format(input.idv),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: input.idv,
                      min: 300000.0,
                      max: 1000000.0,
                      divisions: 70,
                      label: _currencyFormat.format(input.idv),
                      activeColor: const Color(0xFF2563EB),
                      onChanged: (newIdv) {
                        context.read<InsuranceBloc>().add(IdvChanged(newIdv));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹3,00,000',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        Text(
                          '₹10,00,000',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'No Claim Bonus (NCB)',
                  icon: Icons.discount_outlined,
                  children: [
                    DropdownButtonFormField<int>(
                      value: input.ncbPercentage,
                      decoration: InputDecoration(
                        labelText: 'NCB Discount',
                        prefixIcon: const Icon(Icons.percent_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _ncbPercentages.map((percentage) {
                        return DropdownMenuItem<int>(
                          value: percentage,
                          child: Text('$percentage% Discount on Base Premium'),
                        );
                      }).toList(),
                      onChanged: (selectedNcb) {
                        if (selectedNcb != null) {
                          context
                              .read<InsuranceBloc>()
                              .add(NcbPercentageChanged(selectedNcb));
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Optional Add-ons',
                  icon: Icons.add_moderator_outlined,
                  children: [
                    ...InsuranceAddOn.values.map((addon) {
                      final isSelected = input.activeAddOns.contains(addon);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEFF6FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  addon.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                '+${_currencyFormat.format(addon.cost)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            addon.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          value: isSelected,
                          activeColor: const Color(0xFF2563EB),
                          onChanged: (_) {
                            context
                                .read<InsuranceBloc>()
                                .add(AddOnToggled(addon));
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x14000000),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: BlocBuilder<InsuranceBloc, InsuranceState>(
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _currencyFormat.format(state.quote.totalPremium),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _onNavigateToSummary,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text(
                      'View Quote Summary',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLiveEstimateHeader(dynamic quote) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x402563EB),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instant Reactive Quote',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Live Premium Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x2EFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _currencyFormat.format(quote.totalPremium),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
