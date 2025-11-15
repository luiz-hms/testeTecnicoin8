import 'package:ecommercefrontend/app/presentation/widgets/appbar/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/named_routes.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomMainAppBar(),
      backgroundColor: const Color(0xfff2f2fb),
      body: Center(
        child: Container(
          width: 1300,
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT SIDE
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BACK BUTTON
                        InkWell(
                          onTap: () {
                            context.goNamed(NamedRoute.homePage);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_back),
                              const SizedBox(width: 6),
                              Text(
                                "Back",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // DELIVERY OPTIONS
                        _optionBox(
                          icon: Icons.local_shipping_outlined,
                          text: "Get it delivered in only 30 minutes",
                          selected: true,
                        ),
                        const SizedBox(height: 12),
                        _optionBox(
                          icon: Icons.store_mall_directory_outlined,
                          text: "Pickup available in 3 stores near you",
                        ),
                        const SizedBox(height: 28),

                        // SHIPPING ADDRESS
                        const Text(
                          "Shipping address",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _inputBox(
                          hint:
                              "98 Kite Close, 8-3, Marsfield, Sydney Australia 2723",
                        ),
                        const SizedBox(height: 30),

                        // PAYMENT INFORMATION
                        const Text(
                          "Payment information",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // CARD TYPES
                        Row(
                          children: [
                            _cardType("Mastercard"),
                            const SizedBox(width: 12),
                            _cardType("Visa"),
                            const SizedBox(width: 12),
                            _cardType("HomePay"),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _label("Name on card"),
                        _inputBox(hint: "Parham Marandi"),
                        const SizedBox(height: 20),

                        _label("Card number"),
                        _inputBox(hint: "9383 3847 3494 8763"),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label("Expiration"),
                                  _inputBox(hint: "MM/YY"),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label("CVV"),
                                  _inputBox(hint: "837"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("Back"),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff7b61ff),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                "Confirm Payment  \$570.98",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 32),

              // RIGHT SIDE - ORDER SUMMARY
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _orderItem(
                        title: "Franklin Merino Wool V-Neck Knit",
                        price: 199.00,
                      ),
                      _orderItem(
                        title: "Judd Slim Dress Chino Pant",
                        price: 159.00,
                      ),
                      _orderItem(title: "Angus Shawl Cardigan", price: 199.99),

                      const SizedBox(height: 16),

                      _rowTotal("Delivery", "\$16.99"),
                      _rowTotal("Discount", "\$0.00"),
                      const SizedBox(height: 8),
                      _rowTotal("Total (exc tax)", "\$557.99"),
                      _rowTotal("Tax", "\$12.99"),

                      const Divider(height: 40),

                      _rowTotal("Order Total", "\$570.98", bold: true),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffd2f5d7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Your total saving on this order: \$34.99",
                          style: TextStyle(
                            color: Color(0xff2b8c41),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(child: _inputBox(hint: "Coupon code")),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 20,
                              ),
                            ),
                            child: const Text("Apply"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------- COMPONENTS ----------------------------- //

  Widget _optionBox({
    required IconData icon,
    required String text,
    bool selected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffe9ddff) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? const Color(0xff7b61ff) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff7b61ff)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _inputBox({required String hint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(hint, style: TextStyle(color: Colors.grey.shade600)),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _cardType(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Text(label),
    );
  }

  Widget _orderItem({required String title, required double price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("x1  $title", style: const TextStyle(fontSize: 15)),
          Text("\$${price.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _rowTotal(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
