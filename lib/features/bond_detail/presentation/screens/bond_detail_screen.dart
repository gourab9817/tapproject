import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/bond_detail_bloc.dart';
import '../bloc/bond_detail_event.dart';
import '../bloc/bond_detail_state.dart';
import '../widgets/bond_info_tab.dart';
import '../widgets/isin_analysis_tab.dart';
import '../widgets/pros_cons_tab.dart';

class BondDetailScreen extends StatelessWidget {
  final String isin;

  const BondDetailScreen({Key? key, required this.isin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BondDetailBloc>()..add(LoadBondDetail(isin)),
      child: _BondDetailView(isin: isin),
    );
  }
}

class _BondDetailView extends StatefulWidget {
  final String isin;

  const _BondDetailView({required this.isin});

  @override
  State<_BondDetailView> createState() => _BondDetailViewState();
}

class _BondDetailViewState extends State<_BondDetailView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<Tab> _tabs = const [
    Tab(text: 'Bond Info'),
    Tab(text: 'ISIN Analysis'),
    Tab(text: 'Pros & Cons'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<BondDetailBloc>().add(ChangeTab(_tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocConsumer<BondDetailBloc, BondDetailState>(
        listener: (context, state) {
          if (state is BondDetailLoaded) {
            _slideController.forward();
            if (state.currentTabIndex != _tabController.index) {
              _tabController.animateTo(state.currentTabIndex);
            }
          } else if (state is BondDetailError) {
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
          if (state is BondDetailInitial || state is BondDetailLoading) {
            return const _LoadingWidget();
          } else if (state is BondDetailLoaded) {
            return _buildDetailContent(context, state.bondDetail);
          } else if (state is BondDetailError) {
            return _buildErrorContent(context, state.failure);
          }
          return const _LoadingWidget();
        },
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, bondDetail) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.25, // Responsive height (25% of screen height)
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                      children: [
                        Row(
                          children: [
                            // Company Logo
                            Container(
                              width: MediaQuery.of(context).size.width > 600 ? 80 : 60,
                              height: MediaQuery.of(context).size.width > 600 ? 80 : 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: bondDetail.logo.isNotEmpty
                                    ? Image.network(
                                        bondDetail.logo,
                                        width: MediaQuery.of(context).size.width > 600 ? 80 : 60,
                                        height: MediaQuery.of(context).size.width > 600 ? 80 : 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: MediaQuery.of(context).size.width > 600 ? 80 : 60,
                                            height: MediaQuery.of(context).size.width > 600 ? 80 : 60,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Icon(
                                              Icons.account_balance,
                                              color: Theme.of(context).primaryColor,
                                              size: 30,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: MediaQuery.of(context).size.width > 600 ? 80 : 60,
                                        height: MediaQuery.of(context).size.width > 600 ? 80 : 60,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          Icons.account_balance,
                                          color: Theme.of(context).primaryColor,
                                          size: MediaQuery.of(context).size.width > 600 ? 40 : 30,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bondDetail.companyName,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.blue[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          'ISIN: ${bondDetail.isin}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width > 600 ? 15 : 13,
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.green[50],
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.green[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          bondDetail.status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width > 600 ? 15 : 13,
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.w600,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: _tabs,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Add padding
            ),
          ),
        ];
      },
      body: SlideTransition(
        position: _slideAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            BondInfoTab(bondDetail: bondDetail),
            IsinAnalysisTab(bondDetail: bondDetail),
            ProsConsTab(bondDetail: bondDetail),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, failure) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bond Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Center(
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
                'Failed to load bond details',
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
                  context.read<BondDetailBloc>().add(LoadBondDetail(widget.isin));
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
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bond Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading bond details...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
