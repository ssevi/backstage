import 'package:flutter/material.dart';

class Payments extends StatelessWidget {
  const Payments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: Colors.blue,  // Customize AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTransactionTile('Payment to Vendor X', '\$150.00', '2024-12-01'),
            _buildTransactionTile('Payment from Client Y', '\$300.00', '2024-12-02'),
            _buildTransactionTile('Payment to Vendor Z', '\$450.00', '2024-12-03'),
            // Add more transactions as needed
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(String title, String amount, String date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(title),
        subtitle: Text('Date: $date'),
        trailing: Text(
          amount,
          style: TextStyle(color: amount.contains('-') ? Colors.red : Colors.green),
        ),
      ),
    );
  }
}
