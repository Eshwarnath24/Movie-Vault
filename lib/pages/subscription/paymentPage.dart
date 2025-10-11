import 'package:flutter/material.dart';
import 'package:ott/pages/Main/movieVault.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatefulWidget {
  final String selectedPlan;
  final String selectedPrice;
  const PaymentPage({
    super.key,
    required this.selectedPlan,
    required this.selectedPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = "UPI";
  final TextEditingController _inputController = TextEditingController();
  // +++ ADD LOADING STATE +++
  bool _isLoading = false;

  // +++ ADDED DATABASE UPDATE FUNCTION +++
  Future<void> _finalizeSubscription() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in.");
    }

    final userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid);

    // This updates the user's plan in Firestore
    await userDocRef.set({
      'subscriptionPlan': widget.selectedPlan,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... your existing UI ...
                const SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Back',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Complete Your Payment",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please select a payment method below to continue",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.selectedPlan} Plan",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Duration: 1 Month",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Base Price: ${widget.selectedPrice}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const Divider(color: Colors.white24),
                      Text(
                        "Total: ${widget.selectedPrice}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildPaymentOption(Icons.account_balance_wallet, "UPI"),
                buildPaymentOption(Icons.credit_card, "Debit/Credit Card"),
                buildPaymentOption(Icons.account_balance, "Net Banking"),
                buildPaymentOption(
                  Icons.account_balance_wallet_outlined,
                  "Wallets",
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: buildDynamicPaymentDetails(),
                ),
                const SizedBox(height: 40),

                // --- PAY NOW BUTTON UPDATED FOR LOADING STATE ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.arrow_forward),
                        color: Colors.white,
                        onPressed: _isLoading ? null : validateAndProceed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget buildPaymentOption(IconData icon, String method) {
    return RadioListTile<String>(
      value: method,
      groupValue: selectedMethod,
      onChanged: (value) {
        setState(() {
          selectedMethod = value!;
          _inputController.clear();
        });
      },
      activeColor: Colors.blue,
      selected: selectedMethod == method,
      secondary: Icon(icon, color: Colors.blue),
      title: Text(method, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget buildDynamicPaymentDetails() {
    String placeholder;
    IconData icon;

    switch (selectedMethod) {
      case "UPI":
        placeholder = "Enter your UPI ID (e.g. name@upi)";
        icon = Icons.account_balance_wallet;
        break;
      case "Debit/Credit Card":
        placeholder = "Enter Card Number (16 digits)";
        icon = Icons.credit_card;
        break;
      case "Net Banking":
        placeholder = "Enter Bank Name";
        icon = Icons.account_balance;
        break;
      case "Wallets":
        placeholder = "Enter Wallet ID/Number";
        icon = Icons.account_balance_wallet_outlined;
        break;
      default:
        placeholder = "";
        icon = Icons.help;
    }
    return paymentDetailCard(placeholder, icon);
  }

  Widget paymentDetailCard(String placeholder, IconData icon) {
    return Container(
      key: ValueKey(selectedMethod),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _inputController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: placeholder,
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- VALIDATION LOGIC UPDATED TO CALL DATABASE FUNCTION ---
  void validateAndProceed() async {
    // <--- Make the function async
    String input = _inputController.text.trim();
    String? errorMsg;

    switch (selectedMethod) {
      case "UPI":
        if (!input.contains('@') || input.length < 5) {
          errorMsg = "Enter a valid UPI ID (e.g. name@upi)";
        }
        break;
      case "Debit/Credit Card":
        if (input.length != 16 || int.tryParse(input) == null) {
          errorMsg = "Enter a valid 16-digit card number";
        }
        break;
      case "Net Banking":
        if (input.isEmpty) {
          errorMsg = "Please enter your bank name";
        }
        break;
      case "Wallets":
        if (input.isEmpty) {
          errorMsg = "Please enter your wallet ID/number";
        }
        break;
    }

    if (errorMsg != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    } else {
      // Start loading
      setState(() {
        _isLoading = true;
      });

      try {
        // --- THIS IS THE KEY CHANGE ---
        // First, update the user's subscription in Firestore
        await _finalizeSubscription();

        // If successful, proceed to success page
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Processing $selectedMethod payment..."),
              duration: const Duration(milliseconds: 1500),
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessPage(
                  method: selectedMethod,
                  selectedPlan: widget.selectedPlan,
                  selectedPrice: widget.selectedPrice,
                ),
              ),
            );
          });
        }
      } catch (e) {
        // If there's an error, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update subscription. Please try again."),
          ),
        );
      } finally {
        // Stop loading, regardless of success or failure
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}

// ====================== PAYMENT SUCCESS PAGE ======================
class PaymentSuccessPage extends StatelessWidget {
  final String method;
  final String selectedPlan;
  final String selectedPrice;
  const PaymentSuccessPage({
    super.key,
    required this.method,
    required this.selectedPlan,
    required this.selectedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 80, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Payment Successful!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Thank you for subscribing.\nYour Premium Plan is now active.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailRow("Plan", "$selectedPlan (1 Month)"),
                      detailRow("Amount Paid", selectedPrice),
                      detailRow("Payment Method", method),
                      detailRow("Transaction ID", "#TXN123456789"),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MovieVault(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper row for order details
  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
