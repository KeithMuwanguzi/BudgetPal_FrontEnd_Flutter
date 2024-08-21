import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'isIncome': isIncome,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      isIncome: json['isIncome'],
    );
  }
}

class Transactions {
  static const _key = 'transactions';

  List<Transaction> _transactionList = [];

  Transactions() {
    _loadTransactions();
  }

  List<Transaction> get transactions => _transactionList;

  void addTransaction(Transaction transaction) {
    _transactionList.add(transaction);
    _saveTransactions();
    log(transaction.toString());
  }

  void _saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedTransactions =
        _transactionList.map((tx) => json.encode(tx.toJson())).toList();
    prefs.setStringList(_key, encodedTransactions);
    log(encodedTransactions.toString());
  }

  void _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedTransactions = prefs.getStringList(_key);
    if (encodedTransactions != null) {
      _transactionList = encodedTransactions.map((tx) {
        return Transaction.fromJson(json.decode(tx));
      }).toList();
      log(encodedTransactions.toString());
    }
  }

  List<Transaction> getRecentTransactions(int count) {
    _transactionList.sort((a, b) => b.date.compareTo(a.date));
    return _transactionList.take(count).toList();
  }
}
