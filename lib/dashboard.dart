import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'add_product_page.dart';
import 'add_vendor_page.dart';
import 'product_list_page.dart';
import 'vendor_list_page.dart';
import 'sale_product_page.dart';
import 'purchase_detail_page.dart';
import 'sales_detail_page.dart';
import 'transaction_history_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Product> _products = [];
  final List<SaleTransaction> _transactions = [];
  final List<Vendor> _vendors = [];

  List<String> get _supplierNames => _vendors.map((v) => v.name).toList();

  Future<void> _openAddProduct() async {
    final Product? created = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductPage(availableSuppliers: _supplierNames),
      ),
    );
    if (created != null) {
      setState(() {
        _products.add(created);
      });
    }
  }

  Future<void> _openAddVendor() async {
    final Vendor? created = await Navigator.push<Vendor>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddVendorPage(),
      ),
    );
    if (created != null) {
      setState(() {
        _vendors.add(created);
      });
    }
  }

  void _recordSale(Product product, SaleTransaction transaction) {
    setState(() {
      product.quantity = (product.quantity - transaction.quantity).clamp(0, product.quantity);
      _transactions.insert(0, transaction);
    });
  }

  void _openSaleProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SaleProductPage(
          products: _products,
          onSaleCompleted: _recordSale,
        ),
      ),
    );
  }

  void _openTransactions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionHistoryPage(transactions: _transactions),
      ),
    );
  }

  void _openSalesReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalesDetailPage(transactions: _transactions),
      ),
    );
  }

  void _openPurchaseDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PurchaseDetailPage(products: _products),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeTab(
        onAddProduct: _openAddProduct,
        onAddVendor: _openAddVendor,
        onRecordSale: _openSaleProduct,
        onOpenTransactions: _openTransactions,
        onOpenPurchaseDetail: _openPurchaseDetail,
        onOpenSalesReport: _openSalesReport,
      ),
      ProductListPage(
        products: _products,
        onAddProduct: _openAddProduct,
      ),
      SalesDetailPage(transactions: _transactions),
      VendorListPage(
        vendors: _vendors,
        onAddVendor: _openAddVendor,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('M&K Inventory'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.terracotta),
              child: Text(
                'M&K Inventory',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Product Stock'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Sales Report'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Vendor List'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.terracotta,
        unselectedItemColor: AppColors.textMuted,
        backgroundColor: AppColors.surface,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Vendors',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.onAddProduct,
    required this.onAddVendor,
    required this.onRecordSale,
    required this.onOpenTransactions,
    required this.onOpenPurchaseDetail,
    required this.onOpenSalesReport,
  });

  final VoidCallback onAddProduct;
  final VoidCallback onAddVendor;
  final VoidCallback onRecordSale;
  final VoidCallback onOpenTransactions;
  final VoidCallback onOpenPurchaseDetail;
  final VoidCallback onOpenSalesReport;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.terracotta,
                    child: const Icon(Icons.store, color: AppColors.onPrimary, size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                      Text(
                        'M&K Inventory',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: 'Record Sale',
                  icon: Icons.point_of_sale,
                  color: AppColors.terracotta,
                  onTap: onRecordSale,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  title: 'Add Product',
                  icon: Icons.add_box,
                  color: AppColors.oasis,
                  onTap: onAddProduct,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: 'Add Vendor',
                  icon: Icons.person_add,
                  color: AppColors.ochre,
                  onTap: onAddVendor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  title: 'Transactions',
                  icon: Icons.history,
                  color: AppColors.dusk,
                  onTap: onOpenTransactions,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'REPORTS & DETAILS',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: 'Purchase Detail',
                  icon: Icons.receipt_long,
                  color: AppColors.sage,
                  onTap: onOpenPurchaseDetail,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  title: 'Sales Report',
                  icon: Icons.bar_chart,
                  color: AppColors.rose,
                  onTap: onOpenSalesReport,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}