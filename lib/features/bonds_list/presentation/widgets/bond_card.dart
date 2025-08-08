import 'package:flutter/material.dart';
import '../../domain/entities/bond_entity.dart';
import 'highlighted_text.dart';
import 'isin_text.dart';

class BondCard extends StatelessWidget {
  final BondEntity bond;
  final VoidCallback onTap;
  final String searchQuery;

  const BondCard({
    Key? key,
    required this.bond,
    required this.onTap,
    this.searchQuery = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final padding = isTablet ? 16.0 : 12.0;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              // Company Logo from API
              Container(
                width: isTablet ? 72 : 58,
                height: isTablet ? 72 : 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 70, 97, 247),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: bond.logo.isNotEmpty
                      ? Image.network(
                          bond.logo,
                          width: isTablet ? 68 : 54,
                          height: isTablet ? 68 : 54,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: (isTablet ? 68 : 54) * 0.5,
                                height: (isTablet ? 68 : 54) * 0.5,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue[300]!,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: isTablet ? 68 : 54,
                              height: isTablet ? 68 : 54,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.account_balance,
                                color: Colors.grey[400],
                                size: isTablet ? 28 : 24,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: isTablet ? 68 : 54,
                          height: isTablet ? 68 : 54,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance,
                            color: Colors.grey[400],
                            size: isTablet ? 28 : 24,
                          ),
                        ),
                ),
              ),
              
              SizedBox(width: isTablet ? 16 : 12),
              
              // Content Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ISIN Number (Primary) with bigger last 4
                    IsinText(
                      text: bond.isin,
                      query: searchQuery,
                      lastN: 4,
                      baseStyle: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(221, 80, 77, 77),
                      ),
                      highlightStyle: TextStyle(
                        backgroundColor: Colors.orange[100],
                        fontWeight: FontWeight.w700,
                      ),
                      bigStyle: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w800,
                        color: const Color.fromARGB(221, 0, 0, 0),
                      ),
                    ),
                    
                    SizedBox(height: isTablet ? 8 : 6),
                    
                    // Company Details (Secondary)
                    HighlightedText(
                      text: '${bond.rating} • ${bond.companyName}',
                      query: searchQuery,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      highlightStyle: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        backgroundColor: Colors.orange[100],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Navigation Arrow
              Icon(
                Icons.chevron_right,
                color: Colors.blue,
                size: isTablet ? 24 : 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
