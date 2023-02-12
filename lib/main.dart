import 'dart:io';

import 'package:expense_app/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import '../models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'QuickSand',
        errorColor: Colors.red,
        appBarTheme: const AppBarTheme(
          titleTextStyle:  TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20
            ),
          ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return (tx.date as DateTime).isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }
  
  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(), 
      title: title, 
      amount: amount, 
      date: chosenDate
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, 
      builder: (_) {
        return GestureDetector(
          onTap: () => {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );  
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final cupertinoAppBar = CupertinoNavigationBar(
      middle: const Text('Expense App'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: const Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context), 
          )
        ],
      ),
    );
    final appBar = AppBar(
      title: const Text('Expense App'),
      actions: <Widget>[
        IconButton(
          onPressed: () => _startAddNewTransaction(context), 
          icon: const Icon(Icons.add)
        )
      ],
    );
    final txListWidget = SizedBox(
                height: (mediaQuery.size.height - 
                  appBar.preferredSize.height - 
                  mediaQuery.padding.top) * 0.7,
                child: TransactionList(_userTransactions, _deleteTransaction)
              );
    final pageBody = SafeArea(child: SingleChildScrollView( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Show chart',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart, 
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  }
                )
              ],
            ),
            if (!isLandscape) SizedBox(
                height: (mediaQuery.size.height - 
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) * 0.3,
                child: Chart(_recentTransactions)
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape) _showChart 
              ? SizedBox(
                height: (mediaQuery.size.height - 
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) * 0.7,
                child: Chart(_recentTransactions)
              ) 
              : txListWidget
          ],
        ),
      ),
    );
    return Platform.isIOS ? 
      CupertinoPageScaffold(
        navigationBar: cupertinoAppBar,
        child: pageBody
      ) : 
      Scaffold(
        appBar: appBar,
        body: pageBody,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
          onPressed: () => _startAddNewTransaction(context),
          child: const Icon(Icons.add),
        ),
    );
  }
}