import 'package:flutter/material.dart';
import 'dart:async';
import '../../domain/entities/bond_detail_entity.dart';

class BondInfoTab extends StatefulWidget {
  final BondDetailEntity bondDetail;

  const BondInfoTab({Key? key, required this.bondDetail}) : super(key: key);

  @override
  State<BondInfoTab> createState() => _BondInfoTabState();
}

class _BondInfoTabState extends State<BondInfoTab> with TickerProviderStateMixin {
  int? _selectedBarIndex;
  late AnimationController _tooltipController;
  late Animation<double> _tooltipAnimation;
  late Animation<Offset> _tooltipSlideAnimation;
  Timer? _autoCloseTimer;
  final List<GlobalKey> _barKeys = List.generate(12, (index) => GlobalKey());
  bool _isRevenueSelected = false; // Track which tab is selected

  @override
  void initState() {
    super.initState();
    _tooltipController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _tooltipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tooltipController,
      curve: Curves.easeOutCubic,
    ));
    _tooltipSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _tooltipController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final padding = isTablet ? 24.0 : 16.0;
    final spacing = isTablet ? 20.0 : 16.0;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          _buildDescriptionSection(context),
          SizedBox(height: spacing),
          
          // Company Financials - EBITDA Chart (always show with mock data)
          _buildFinancialsSection(context),
          SizedBox(height: spacing),
          
          // Issuer Details
          if (widget.bondDetail.issuerDetails != null) ...[
            _buildIssuerDetailsSection(context),
            SizedBox(height: spacing),
          ],
        ],
      ),
    );
  }



  Widget _buildDescriptionSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: Colors.blue[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.bondDetail.description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialsSection(BuildContext context) {
    // Get data based on selected tab (EBITDA or Revenue)
    List<Map<String, dynamic>> chartData;
    
    if (_isRevenueSelected) {
      // Use Revenue data if available
      final hasRevenueData = widget.bondDetail.revenueHistory != null && widget.bondDetail.revenueHistory!.isNotEmpty;
      if (hasRevenueData) {
        chartData = widget.bondDetail.revenueHistory!.map((item) {
          final valueInCrores = item.value / 10000000; // Convert to crores
          
          if (valueInCrores < 0.8) {
            return {
              'month': item.month.substring(0, 1).toUpperCase(),
              'baseValue': valueInCrores * 100,
              'topValue': 0.0,
              'totalValue': valueInCrores * 100,
            };
          } else {
            return {
              'month': item.month.substring(0, 1).toUpperCase(),
              'baseValue': 80.0,
              'topValue': (valueInCrores - 0.8) * 100,
              'totalValue': valueInCrores * 100,
            };
          }
        }).toList();
      } else {
        // Mock revenue data
        chartData = [
          {'month': 'J', 'baseValue': 120.0, 'topValue': 30.0, 'totalValue': 150.0},
          {'month': 'F', 'baseValue': 125.0, 'topValue': 35.0, 'totalValue': 160.0},
          {'month': 'M', 'baseValue': 118.0, 'topValue': 32.0, 'totalValue': 150.0},
          {'month': 'A', 'baseValue': 130.0, 'topValue': 40.0, 'totalValue': 170.0},
          {'month': 'M', 'baseValue': 128.0, 'topValue': 38.0, 'totalValue': 166.0},
          {'month': 'J', 'baseValue': 135.0, 'topValue': 45.0, 'totalValue': 180.0},
          {'month': 'J', 'baseValue': 132.0, 'topValue': 42.0, 'totalValue': 174.0},
          {'month': 'A', 'baseValue': 138.0, 'topValue': 48.0, 'totalValue': 186.0},
          {'month': 'S', 'baseValue': 134.0, 'topValue': 44.0, 'totalValue': 178.0},
          {'month': 'O', 'baseValue': 140.0, 'topValue': 50.0, 'totalValue': 190.0},
          {'month': 'N', 'baseValue': 126.0, 'topValue': 36.0, 'totalValue': 162.0},
          {'month': 'D', 'baseValue': 142.0, 'topValue': 52.0, 'totalValue': 194.0},
        ];
      }
    } else {
      // Use EBITDA data
      final hasEbitdaData = widget.bondDetail.ebitdaHistory != null && widget.bondDetail.ebitdaHistory!.isNotEmpty;
      if (hasEbitdaData) {
        chartData = widget.bondDetail.ebitdaHistory!.map((item) {
          final valueInCrores = item.value / 10000000;
          
          // For EBITDA, we want to show proportional heights
          // All values are above 0.8 Cr, so we'll use the two-toned approach
          // Base (black) = 80% of the value, Top (light blue) = 20% of the value
          final totalValue = valueInCrores * 100; // Convert to chart units
          final baseValue = 80.0; // Fixed base for visual consistency
          final topValue = totalValue - baseValue; // Remaining goes to top
          
          return {
            'month': item.month.substring(0, 1).toUpperCase(),
            'baseValue': baseValue,
            'topValue': topValue,
            'totalValue': totalValue,
          };
        }).toList();
      } else {
        // Mock EBITDA data with varying heights to test proportionality
        chartData = [
          {'month': 'J', 'baseValue': 80.0, 'topValue': 40.0, 'totalValue': 120.0}, // 1.2 Cr
          {'month': 'F', 'baseValue': 80.0, 'topValue': 55.0, 'totalValue': 135.0}, // 1.35 Cr
          {'month': 'M', 'baseValue': 80.0, 'topValue': 38.0, 'totalValue': 118.0}, // 1.18 Cr
          {'month': 'A', 'baseValue': 80.0, 'topValue': 65.0, 'totalValue': 145.0}, // 1.45 Cr
          {'month': 'M', 'baseValue': 80.0, 'topValue': 48.0, 'totalValue': 128.0}, // 1.28 Cr
          {'month': 'J', 'baseValue': 80.0, 'topValue': 75.0, 'totalValue': 155.0}, // 1.55 Cr
          {'month': 'J', 'baseValue': 80.0, 'topValue': 52.0, 'totalValue': 132.0}, // 1.32 Cr
          {'month': 'A', 'baseValue': 80.0, 'topValue': 68.0, 'totalValue': 148.0}, // 1.48 Cr
          {'month': 'S', 'baseValue': 80.0, 'topValue': 57.0, 'totalValue': 137.0}, // 1.37 Cr
          {'month': 'O', 'baseValue': 80.0, 'topValue': 80.0, 'totalValue': 160.0}, // 1.6 Cr
          {'month': 'N', 'baseValue': 80.0, 'topValue': 45.0, 'totalValue': 125.0}, // 1.25 Cr
          {'month': 'D', 'baseValue': 80.0, 'topValue': 60.0, 'totalValue': 140.0}, // 1.4 Cr
        ];
      }
    }
    
    // Calculate dynamic scaling
    final maxValue = chartData.map((e) => e['totalValue'] as double).reduce((a, b) => a > b ? a : b);
    
    // Create Y-axis labels based on actual data
    final yAxisLabels = _generateYAxisLabels(maxValue);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Toggle on same row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'COMPANY FINANCIALS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
              _buildToggleButton(),
            ],
          ),
          const SizedBox(height: 24),
          
          // Chart with Y-axis labels
          SizedBox(
            height: 240,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis labels
                SizedBox(
                  width: 40, // Reduced from 55 to save space
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: yAxisLabels.map((label) => _buildYAxisLabel(label)).toList(),
                  ),
                ),
                const SizedBox(width: 5), // Reduced from 10 to save space
                
                // Chart area
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: Stack(
            children: [
                        // Grid lines
                        ...List.generate(5, (index) {
                          return Positioned(
                            top: index * 40.0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: Colors.grey[200],
                            ),
                          );
                        }),
                        
                        // Bars with reduced spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: chartData.asMap().entries.map((entry) {
                            final index = entry.key;
                            final data = entry.value;
                            return _buildInteractiveBar(
                              data['baseValue'] as double,
                              data['topValue'] as double,
                              data['month'] as String,
                              data['totalValue'] as double,
                              index,
                              maxValue,
                            );
                          }).toList(),
                        ),
                        
                        // Tooltip overlay
                        if (_selectedBarIndex != null)
                          _buildTooltip(chartData[_selectedBarIndex!]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // X-axis labels (months)
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: chartData.map((data) {
                return Text(
                  data['month'] as String,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                );
              }).toList(),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildInteractiveBar(
    double baseValue, 
    double topValue, 
    String month, 
    double totalValue, 
    int index, 
    double maxValue
  ) {
    const barHeight = 200.0;
    
    final baseBarHeight = (baseValue / maxValue) * barHeight;
    final topBarHeight = (topValue / maxValue) * barHeight;
    final totalBarHeight = baseBarHeight + topBarHeight;
    final isSelected = _selectedBarIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedBarIndex == index) {
            _closeTooltip();
          } else {
            _showTooltip(index);
          }
        });
      },
      child: Container(
        key: _barKeys[index],
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: isSelected ? 14 : 10, // Slightly wider when selected
          height: barHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_isRevenueSelected) ...[
                // Revenue: Single solid blue bar
                Container(
                  width: isSelected ? 14 : 10,
                  height: totalBarHeight,
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? Colors.blue[600]?.withOpacity(0.9)
                      : Colors.blue[600],
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                ),
              ] else ...[
                // EBITDA: Two-toned bars (black base + light blue top)
                // Top bar (light blue) - represents values above 0.8 Cr
                if (topBarHeight > 0)
                  Container(
                    width: isSelected ? 14 : 10,
                    height: topBarHeight,
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? Colors.blue[300]?.withOpacity(0.9)
                        : Colors.blue[200]?.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                  ),
                // Bottom bar (black) - represents values up to 0.8 Cr
                if (baseBarHeight > 0)
                  Container(
                    width: isSelected ? 14 : 10,
                    height: baseBarHeight,
                    color: isSelected ? Colors.black87 : Colors.black,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTooltip(Map<String, dynamic> data) {
    final month = data['month'] as String;
    final totalValue = data['totalValue'] as double;
    final baseValue = data['baseValue'] as double;
    final topValue = data['topValue'] as double;
    
    // Calculate position based on selected bar index
    final barWidth = 8.0;
    final spacing = 16.0;
    final totalBarWidth = barWidth + spacing;
    final tooltipLeft = (_selectedBarIndex! * totalBarWidth) - 60; // Center the tooltip
    
    return Positioned(
      top: 20,
      left: tooltipLeft,
      child: SlideTransition(
        position: _tooltipSlideAnimation,
        child: FadeTransition(
          opacity: _tooltipAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Month name
                Text(
                  _getFullMonthName(month),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                // Total value
                Text(
                  '₹${(totalValue / 100).toStringAsFixed(1)}Cr',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                // Breakdown
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₹${(baseValue / 100).toStringAsFixed(1)}Cr',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
          Text(
                      '₹${(topValue / 100).toStringAsFixed(1)}Cr',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
              

  void _showTooltip(int index) {
    _selectedBarIndex = index;
    _tooltipController.forward();
    
    // Auto-close after 3 seconds
    _autoCloseTimer?.cancel();
    _autoCloseTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _closeTooltip();
      }
    });
  }

  void _closeTooltip() {
    setState(() {
      _selectedBarIndex = null;
    });
    _tooltipController.reverse();
    _autoCloseTimer?.cancel();
  }

  String _getFullMonthName(String shortMonth) {
    final monthNames = {
      'J': 'January',
      'F': 'February', 
      'M': 'March',
      'A': 'April',
      'M': 'May',
      'J': 'June',
      'J': 'July',
      'A': 'August',
      'S': 'September',
      'O': 'October',
      'N': 'November',
      'D': 'December',
    };
    return monthNames[shortMonth] ?? shortMonth;
  }

  List<String> _generateYAxisLabels(double maxValue) {
    // Convert chart units back to crores for display
    final maxValueInCrores = maxValue / 100;
    
    if (maxValueInCrores <= 0.5) {
      return ['₹0.5Cr', '₹0.4Cr', '₹0.3Cr', '₹0.2Cr', '₹0.1Cr'];
    } else if (maxValueInCrores <= 1.0) {
      return ['₹1Cr', '₹0.8Cr', '₹0.6Cr', '₹0.4Cr', '₹0.2Cr'];
    } else if (maxValueInCrores <= 2.0) {
      return ['₹2Cr', '₹1.5Cr', '₹1Cr', '₹0.5Cr', '₹0'];
    } else if (maxValueInCrores <= 3.0) {
      return ['₹3Cr', '₹2.5Cr', '₹2Cr', '₹1Cr', '₹0'];
    } else if (maxValueInCrores <= 5.0) {
      return ['₹5Cr', '₹4Cr', '₹3Cr', '₹2Cr', '₹1Cr'];
    } else {
      // For very large values
      return [
        '₹${maxValueInCrores.toStringAsFixed(1)}Cr',
        '₹${(maxValueInCrores * 0.75).toStringAsFixed(1)}Cr',
        '₹${(maxValueInCrores * 0.5).toStringAsFixed(1)}Cr',
        '₹${(maxValueInCrores * 0.25).toStringAsFixed(1)}Cr',
        '₹0',
      ];
    }
  }

  Widget _buildToggleButton() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isRevenueSelected = false;
                _selectedBarIndex = null; // Reset selection when switching tabs
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isRevenueSelected ? Colors.transparent : Colors.black87,
                borderRadius: BorderRadius.circular(17),
                boxShadow: _isRevenueSelected ? null : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                'EBITDA',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _isRevenueSelected ? Colors.grey[600] : Colors.white,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isRevenueSelected = true;
                _selectedBarIndex = null; // Reset selection when switching tabs
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isRevenueSelected ? Colors.black87 : Colors.transparent,
                borderRadius: BorderRadius.circular(17),
                boxShadow: _isRevenueSelected ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
              child: Text(
                'Revenue',
            style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _isRevenueSelected ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey[500],
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildIssuerDetailsSection(BuildContext context) {
    final issuer = widget.bondDetail.issuerDetails!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                Icons.business_center,
                  color: Colors.purple[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Issuer Details',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          if (issuer.issuerName != null) ...[
            _buildDetailRow('Issuer Name', issuer.issuerName!),
            const SizedBox(height: 12),
          ],
          if (issuer.typeOfIssuer != null) ...[
            _buildDetailRow('Type of Issuer', issuer.typeOfIssuer!),
            const SizedBox(height: 12),
          ],
          if (issuer.sector != null) ...[
            _buildDetailRow('Sector', issuer.sector!),
            const SizedBox(height: 12),
          ],
          if (issuer.industry != null) ...[
            _buildDetailRow('Industry', issuer.industry!),
            const SizedBox(height: 12),
          ],
          if (issuer.issuerNature != null) ...[
            _buildDetailRow('Issuer Nature', issuer.issuerNature!),
            const SizedBox(height: 12),
          ],
          if (issuer.cin != null) ...[
            _buildDetailRow('Corporate Identity Number (CIN)', issuer.cin!),
            const SizedBox(height: 12),
          ],
          if (issuer.leadManager != null) ...[
            _buildDetailRow('Lead Manager', issuer.leadManager!),
            const SizedBox(height: 12),
          ],
          if (issuer.registrar != null) ...[
            _buildDetailRow('Registrar', issuer.registrar!),
            const SizedBox(height: 12),
          ],
          if (issuer.debentureTrustee != null) ...[
            _buildDetailRow('Debenture Trustee', issuer.debentureTrustee!),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isTablet ? 180 : 140,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 15 : 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: isTablet ? 20 : 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 15 : 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }


}