import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction>? transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions?.isEmpty == true 
    ? LayoutBuilder(builder: (ctx, constraints) {
      return Column(children: <Widget>[
        const Text(
          'No Transaction added yet!'
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: constraints.maxHeight * 0.6,
          child: Image.asset(
            'assets/images/waiting.png',
            fit: BoxFit.cover
          ),
        ),],
      );
    })
      : ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5
          ),
          child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: FittedBox(
                child: Text('₹ ${(transactions as List<Transaction>)[index].amount?.toStringAsFixed(2)}'),
                )
              ),
            ),
            title: Text(
              transactions?[index].title as String,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              DateFormat.yMMMd().format(transactions?[index].date as DateTime),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: MediaQuery.of(context).size.width > 460 ? 
              TextButton.icon(
                onPressed: () => deleteTx(transactions?[index].id), 
                icon: const Icon(Icons.delete), 
                label: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).errorColor
                  )
                )
              )
              : 
              IconButton(
                onPressed: () => deleteTx(transactions?[index].id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
          )
        );
      },
      itemCount: (transactions as List<Transaction>).length,
    );
  }
}