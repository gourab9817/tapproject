import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../bloc/bonds_list_bloc.dart';
import '../bloc/bonds_list_event.dart';
import '../bloc/bonds_list_state.dart';
import '../widgets/bond_card.dart';
import '../widgets/search_bar_widget.dart';
import '../../../bond_detail/presentation/screens/bond_detail_screen.dart';

class BondsListScreen extends StatelessWidget {
  const BondsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BondsListBloc>()..add(const LoadBonds()),
      child: const _BondsListView(),
    );
  }
}

class _BondsListView extends StatefulWidget {
  const _BondsListView();

  @override
  State<_BondsListView> createState() => _BondsListViewState();
}

class _BondsListViewState extends State<_BondsListView>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 28 : 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: BlocConsumer<BondsListBloc, BondsListState>(
        listener: (context, state) {
          if (state is BondsListLoaded) {
            _fadeController.forward();
          } else if (state is BondsListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.errorMessage),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<BondsListBloc>().add(const RefreshBonds());
            },
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                  child: SearchBarWidget(
                    controller: _searchController,
                    onChanged: (query) {
                      context.read<BondsListBloc>().add(SearchBonds(query));
                    },
                    onClear: () {
                      print('DEBUG: SearchBar onClear called');
                      _searchController.clear();
                      context.read<BondsListBloc>().add(const ClearSearch());
                    },
                  ),
                ),
                // Content
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is BondsListInitial || state is BondsListLoading) {
                        return const _LoadingWidget();
                      } else if (state is BondsListLoaded) {
                        final displayBonds = state.searchQuery.isNotEmpty ? state.filteredBonds : state.bonds;
                        
                        if (displayBonds.isEmpty && state.searchQuery.isNotEmpty) {
                          return _EmptySearchWidget(query: state.searchQuery);
                        }
                        
                        if (displayBonds.isEmpty) {
                          return const _EmptyStateWidget();
                        }
                        
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              // Header based on search state
                              Padding(
                                padding: EdgeInsets.only(
                                  left: isTablet ? 20.0 : 16.0,
                                  top: isTablet ? 12.0 : 8.0,
                                  bottom: isTablet ? 12.0 : 8.0,
                                ),
                                child: Text(
                                  (state is BondsListLoaded && state.searchQuery.isNotEmpty) ? 'SEARCH RESULTS' : 'SUGGESTED RESULTS',
                                  style: TextStyle(
                                    fontSize: isTablet ? 14 : 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              // Bonds List
                              ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.0 : 16.0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayBonds.length,
                            itemBuilder: (context, index) {
                              final bond = displayBonds[index];
                              return Padding(
                                    padding: EdgeInsets.only(bottom: isTablet ? 10.0 : 8.0),
                                child: BondCard(
                                  bond: bond,
                                      searchQuery: state.searchQuery,
                                  onTap: () => _navigateToBondDetail(context, bond.isin),
                                ),
                              );
                            },
                              ),
                            ],
                          ),
                        );
                      } else if (state is BondsListError) {
                        if (state.bonds.isNotEmpty) {
                          // Show cached data with error message at top
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.orange[800], size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Data might be outdated. ${state.failure.errorMessage}',
                                        style: TextStyle(color: Colors.orange[800], fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                 child: ListView(
                                   padding: EdgeInsets.zero,
                                   children: [
                                     // Header based on search state
                                     Padding(
                                       padding: EdgeInsets.only(
                                         left: isTablet ? 20.0 : 16.0,
                                         top: isTablet ? 12.0 : 8.0,
                                         bottom: isTablet ? 12.0 : 8.0,
                                       ),
                                       child: Text(
                                         'SUGGESTED RESULTS',
                                         style: TextStyle(
                                           fontSize: isTablet ? 14 : 12,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.grey[600],
                                           letterSpacing: 0.5,
                                         ),
                                       ),
                                     ),
                                     // Bonds List
                                     ListView.builder(
                                       padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.0 : 16.0),
                                       shrinkWrap: true,
                                       physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.bonds.length,
                                  itemBuilder: (context, index) {
                                    final bond = state.bonds[index];
                                    return Padding(
                                           padding: EdgeInsets.only(bottom: isTablet ? 10.0 : 8.0),
                                      child: BondCard(
                                        bond: bond,
                                        onTap: () => _navigateToBondDetail(context, bond.isin),
                                      ),
                                    );
                                  },
                                     ),
                                   ],
                                ),
                              ),
                            ],
                          );
                        }
                        return _ErrorWidget(failure: state.failure);
                      }
                      return const _LoadingWidget();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToBondDetail(BuildContext context, String isin) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BondDetailScreen(isin: isin),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading bonds...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No bonds available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pull to refresh or try again later',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchWidget extends StatelessWidget {
  final String query;
  
  const _EmptySearchWidget({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No bonds match "$query"',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final failure;
  
  const _ErrorWidget({required this.failure});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              failure.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<BondsListBloc>().add(const LoadBonds());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
