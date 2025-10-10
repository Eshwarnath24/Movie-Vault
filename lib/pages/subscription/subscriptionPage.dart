import 'package:flutter/material.dart';
import 'package:ott/pages/subscription/paymentPage.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedPlan = "Starter"; // default selected plan

  String getPlanPrice(String plan) {
    switch (plan) {
      case "Starter":
        return "₹69/Month";
      case "Enterprise":
        return "₹499/Month";
      case "Premium":
        return "₹199/Month";
      default:
        return "₹0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background images
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/images/titanic.jpg",
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    "assets/images/star_wars.jpg",
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    "assets/images/master.jpg",
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    "assets/images/srimanthudu.jpg",
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
              ],
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.95),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
            ),

            // Foreground content
            Column(
              children: [
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
                const SizedBox(height: 30),
                const Icon(
                  Icons.workspace_premium,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Subscribe to Premium",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 35),
                const FeatureTile(text: "Watch in 4K on All Devices"),
                const FeatureTile(text: "Ad-free. No One Ad"),
                const FeatureTile(text: "Quality in All Watching Movies"),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Features
                        const SizedBox(height: 50),

                        // Plans
                        buildPlanTile(
                          "Starter",
                          "7 - Days Free Trial",
                          "₹69/Month",
                        ),

                        const SizedBox(height: 15),
                        buildPlanTile(
                          "Enterprise",
                          "Best for Teams",
                          "₹499/Month",
                        ),
                        const SizedBox(height: 15),
                        buildPlanTile(
                          "Premium",
                          "1 - Month Free Trial",
                          "₹199/Month",
                        ),

                        const SizedBox(height: 40),

                        // Continue button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "You selected: $selectedPlan plan",
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            Future.delayed(
                              const Duration(milliseconds: 1500),
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                      selectedPlan: selectedPlan,
                                      selectedPrice: getPlanPrice(selectedPlan),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Continue For Payment",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Footer
                        const Center(
                          child: Text(
                            "Terms of use | Privacy Policy | Restore",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper for plan tiles
  Widget buildPlanTile(String title, String subtitle, String price) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = title;
        });
      },
      child: PlanTile(
        title: title,
        subtitle: subtitle,
        price: price,
        isSelected: selectedPlan == title,
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String text;
  const FeatureTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.blue),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;

  const PlanTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.white38,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? Colors.blue : Colors.white70,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
