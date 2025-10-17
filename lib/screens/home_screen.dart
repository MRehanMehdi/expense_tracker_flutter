import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import 'expense_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Expense> expenses = [];
  late TabController _tabController;
  int currentPage = 0;
  final int expensesPerPage = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = currentPage * expensesPerPage;
    int endIndex = (startIndex + expensesPerPage < expenses.length)
        ? startIndex + expensesPerPage
        : expenses.length;
    List<Expense> currentExpenses = expenses.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00796B), Color(0xFF26A69A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.teal.shade100,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.info_outline), text: "About"),
            Tab(icon: Icon(Icons.person_outline), text: "Profile"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 🏠 HOME TAB
          Column(
            children: [
              Expanded(
                child: expenses.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallet_outlined,
                          color: Colors.teal.shade400, size: 70),
                      const SizedBox(height: 15),
                      const Text(
                        'No expenses added yet!',
                        style: TextStyle(
                            fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap + to add your first expense',
                        style: TextStyle(
                            fontSize: 14, color: Colors.black45),
                      ),
                    ],
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: currentExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = currentExpenses[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.teal.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.teal.shade100,
                                child: const Icon(Icons.receipt_long,
                                    color: Colors.teal, size: 28),
                              ),
                              title: Text(
                                expense.category,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  'Rs. ${expense.amount.toStringAsFixed(2)}\nDate: ${DateFormat('yyyy-MM-dd').format(expense.date)}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      height: 1.5),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red, size: 26),
                                onPressed: () {
                                  deleteExpense(startIndex + index);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExpenseDetailScreen(
                                            expense: expense),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 🔽 Buttons Row (Always Visible)
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          heroTag: "prevBtn",
                          backgroundColor: currentPage > 0
                              ? Colors.teal.shade500
                              : Colors.grey.shade400,
                          mini: true,
                          onPressed: currentPage > 0
                              ? () {
                            setState(() {
                              currentPage--;
                            });
                          }
                              : null,
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 15),
                        FloatingActionButton.extended(
                          heroTag: "addBtn",
                          backgroundColor: Colors.teal.shade600,
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'Add Expense',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          onPressed: () async {
                            final newExpense = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const AddExpenseScreen(),
                              ),
                            );

                            if (newExpense != null && newExpense is Expense) {
                              setState(() {
                                expenses.add(newExpense);
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 15),
                        FloatingActionButton(
                          heroTag: "nextBtn",
                          backgroundColor: endIndex < expenses.length
                              ? Colors.teal.shade500
                              : Colors.grey.shade400,
                          mini: true,
                          onPressed: endIndex < expenses.length
                              ? () {
                            setState(() {
                              currentPage++;
                            });
                          }
                              : null,
                          child: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Page ${currentPage + 1} of ${((expenses.length - 1) ~/ expensesPerPage) + 1}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ℹ ABOUT TAB
          _buildAboutTab(),

          // 👤 PROFILE TAB
          _buildProfileTab(),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8,
          shadowColor: Colors.tealAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB2DFDB), Color(0xFFE0F2F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, color: Colors.teal, size: 60),
                const SizedBox(height: 15),
                const Text(
                  'About This App',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The Expense Tracker app helps users record and manage their daily expenses easily and effectively. '
                      'It provides a clean design, friendly interface, and essential features to track spending habits conveniently.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 25),
                const Divider(thickness: 1.5, color: Colors.teal),
                const SizedBox(height: 15),
                const Text(
                  'Developed By:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Text(
                  'M. Rehan Mehdi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const Text(
                  'Riphah International University',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: const Text(
                    '© 2025 All Rights Reserved',
                    style: TextStyle(fontSize: 13, color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal,
            child: Icon(Icons.person, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 15),
          const Text(
            'User Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Welcome back!',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}