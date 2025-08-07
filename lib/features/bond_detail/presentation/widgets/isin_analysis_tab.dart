import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/bond_detail_entity.dart';

class IsinAnalysisTab extends StatefulWidget {
  final BondDetailEntity bondDetail;

  const IsinAnalysisTab({Key? key, required this.bondDetail}) : super(key: key);

  @override
  State<IsinAnalysisTab> createState() => _IsinAnalysisTabState();
}

class _IsinAnalysisTabState extends State<IsinAnalysisTab> {
  bool _isRevenueSelected = false; // Track which analysis is selected

  // Compute "nice" axis bounds and interval to avoid label overlap
  ({double minY, double maxY, double interval}) _computeAxisBounds(List<double> values) {
    final double dataMin = values.reduce((a, b) => a < b ? a : b);
    final double dataMax = values.reduce((a, b) => a > b ? a : b);

    // Expand a bit at ends
    double minY = dataMin * 0.95;
    double maxY = dataMax * 1.05;

    // Choose a step from {0.5M, 1M, 2M, 5M}
    final steps = <double>[0.5e6, 1e6, 2e6, 5e6];
    double chosen = 1e6;
    for (final s in steps) {
      final tickCount = ((maxY - minY) / s).clamp(1, 10);
      if (tickCount >= 4 && tickCount <= 7) {
        chosen = s;
        break;
      }
      chosen = s; // fallback to the last evaluated if none matched earlier
    }

    // Snap min/max to step
    minY = (minY / chosen).floorToDouble() * chosen;
    maxY = (maxY / chosen).ceilToDouble() * chosen;

    // Ensure at least 3 ticks
    if (((maxY - minY) / chosen) < 3) {
      maxY = minY + chosen * 3;
    }

    return (minY: minY, maxY: maxY, interval: chosen);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final padding = isTablet ? 24.0 : 20.0;
    final spacing = isTablet ? 24.0 : 20.0;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ISIN Info Card
          _buildIsinInfoCard(context),
          const SizedBox(height: 20),
          
          // Analysis Toggle
          _buildAnalysisToggle(),
          SizedBox(height: spacing),
          
          // Chart based on selection
          if (_isRevenueSelected) ...[
            if (widget.bondDetail.revenueHistory != null && widget.bondDetail.revenueHistory!.isNotEmpty)
              _buildRevenueChart(context)
            else
              _buildNoRevenueDataCard(context),
          ] else ...[
            if (widget.bondDetail.ebitdaHistory != null && widget.bondDetail.ebitdaHistory!.isNotEmpty)
              _buildEbitdaChart(context)
            else
              _buildNoDataCard(context),
          ],
        ],
      ),
    );
  }

  Widget _buildIsinInfoCard(BuildContext context) {
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'ISIN Analysis',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'ISIN:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.bondDetail.isin,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Company:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.bondDetail.companyName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEbitdaChart(BuildContext context) {
    final ebitdaData = widget.bondDetail.ebitdaHistory!;
    final axis = _computeAxisBounds(ebitdaData.map((e) => e.value).toList());
    
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'EBITDA Over Months',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Chart
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 300 : 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  verticalInterval: 1,
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() < ebitdaData.length) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 6,
                            child: Text(
                              ebitdaData[value.toInt()].month,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 64,
                      interval: axis.interval,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // Show titles only on our fixed interval
                        if ((value - axis.minY) % axis.interval > 1e-6 &&
                            axis.interval - ((value - axis.minY) % axis.interval) > 1e-6) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 8,
                          child: Text(
                            '\$${(value / 1000000).toStringAsFixed(1)}M',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: (ebitdaData.length - 1).toDouble(),
                minY: axis.minY,
                maxY: axis.maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: ebitdaData.asMap().entries.map((entry) =>
                        FlSpot(entry.key.toDouble(), entry.value.value)).toList(),
                    isCurved: true,
                    gradient: LinearGradient(colors: [
                      Colors.blue.withOpacity(0.8),
                      Colors.green.withOpacity(0.8),
                    ]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.blue,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.1),
                          Colors.green.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.blueAccent,
                    tooltipMargin: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) =>
                        touchedBarSpots.map((barSpot) {
                      final month = ebitdaData[barSpot.spotIndex].month;
                      final value = barSpot.y;
                      return LineTooltipItem(
                        '$month\n\$${(value / 1000000).toStringAsFixed(1)}M',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Statistics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Highest EBITDA',
                    '\$${(ebitdaData.map((e) => e.value).reduce((a, b) => a > b ? a : b) / 1000000).toStringAsFixed(1)}M',
                    Colors.green,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatItem(
                    'Lowest EBITDA',
                    '\$${(ebitdaData.map((e) => e.value).reduce((a, b) => a < b ? a : b) / 1000000).toStringAsFixed(1)}M',
                    Colors.red,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatItem(
                    'Average EBITDA',
                    '\$${(ebitdaData.map((e) => e.value).reduce((a, b) => a + b) / ebitdaData.length / 1000000).toStringAsFixed(1)}M',
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    final revenueData = widget.bondDetail.revenueHistory!;
    final axis = _computeAxisBounds(revenueData.map((e) => e.value).toList());
    
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Revenue Over Months',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Chart
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 300 : 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  verticalInterval: 1,
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() < revenueData.length) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 6,
                            child: Text(
                              revenueData[value.toInt()].month,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 64,
                      interval: axis.interval,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if ((value - axis.minY) % axis.interval > 1e-6 &&
                            axis.interval - ((value - axis.minY) % axis.interval) > 1e-6) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 8,
                          child: Text(
                            '\$${(value / 1000000).toStringAsFixed(1)}M',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: (revenueData.length - 1).toDouble(),
                minY: axis.minY,
                maxY: axis.maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: revenueData.asMap().entries.map((entry) =>
                        FlSpot(entry.key.toDouble(), entry.value.value)).toList(),
                    isCurved: true,
                    gradient: LinearGradient(colors: [
                      Colors.orange.withOpacity(0.8),
                      Colors.red.withOpacity(0.8),
                    ]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.orange,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withOpacity(0.1),
                          Colors.red.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.orangeAccent,
                    tooltipMargin: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) =>
                        touchedBarSpots.map((barSpot) {
                      final month = revenueData[barSpot.spotIndex].month;
                      final value = barSpot.y;
                      return LineTooltipItem(
                        '$month\n\$${(value / 1000000).toStringAsFixed(1)}M',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Statistics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Highest Revenue',
                    '\$${(revenueData.map((e) => e.value).reduce((a, b) => a > b ? a : b) / 1000000).toStringAsFixed(1)}M',
                    Colors.orange,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatItem(
                    'Lowest Revenue',
                    '\$${(revenueData.map((e) => e.value).reduce((a, b) => a < b ? a : b) / 1000000).toStringAsFixed(1)}M',
                    Colors.red,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatItem(
                    'Average Revenue',
                    '\$${(revenueData.map((e) => e.value).reduce((a, b) => a + b) / revenueData.length / 1000000).toStringAsFixed(1)}M',
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
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
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No EBITDA data available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'EBITDA historical data is not available for this bond',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAnalysisToggle() {
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
          Text(
            'Financial Analysis',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildNoRevenueDataCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
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
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Revenue data available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revenue historical data is not available for this bond',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
