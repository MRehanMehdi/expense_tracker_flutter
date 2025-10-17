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
