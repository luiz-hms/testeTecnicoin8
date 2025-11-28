import 'package:ecommercefrontend/app/core/helpers/formatters/card_formatters.dart';
import 'package:ecommercefrontend/app/core/helpers/mixins/validations.dart';
import 'package:ecommercefrontend/app/presentation/cubits/checkout/checkout_cubit.dart';
import 'package:ecommercefrontend/app/presentation/widgets/appbar/custom_appbar/custom_appbar.dart';
import 'package:ecommercefrontend/app/presentation/widgets/appbar/drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/named_routes.dart';
import '../../widgets/checkout/checkout_option_box.dart';
import '../../widgets/checkout/checkout_input_box.dart';
import '../../widgets/checkout/checkout_label.dart';
import '../../widgets/checkout/checkout_card_type_selector.dart';
import '../../widgets/checkout/checkout_order_item.dart';
import '../../widgets/checkout/checkout_total_row.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with Validations {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _nameOnCardController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expirationController = TextEditingController();
  final _cvvController = TextEditingController();
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _nameOnCardController.dispose();
    _cardNumberController.dispose();
    _expirationController.dispose();
    _cvvController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.success) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Sucesso!"),
              content: const Text("Pagamento confirmado com sucesso!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.goNamed(NamedRoute.homePage);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CheckoutCubit>();

        return Scaffold(
          appBar: CustomMainAppBar(),
          drawer: const CustomDrawer(),
          backgroundColor: const Color(0xfff2f2fb),
          body: Center(
            child: Container(
              width: 1300,
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
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
                                      "Voltar",
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
                              InkWell(
                                onTap: () => cubit.selectDeliveryMethod(
                                  DeliveryMethod.delivery,
                                ),
                                child: CheckoutOptionBox(
                                  icon: Icons.local_shipping_outlined,
                                  text: "Receba em apenas 30 minutos",
                                  selected:
                                      state.selectedDeliveryMethod ==
                                      DeliveryMethod.delivery,
                                ),
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () => cubit.selectDeliveryMethod(
                                  DeliveryMethod.pickup,
                                ),
                                child: CheckoutOptionBox(
                                  icon: Icons.store_mall_directory_outlined,
                                  text: "Retire em uma das 3 lojas próximas",
                                  selected:
                                      state.selectedDeliveryMethod ==
                                      DeliveryMethod.pickup,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // SHIPPING ADDRESS
                              const Text(
                                "Endereço de entrega",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CheckoutInputBox(
                                controller: _addressController,
                                hint:
                                    "Rua das Flores, 123, Centro, São Paulo - SP",
                                validator: isNotEmpty,
                              ),
                              const SizedBox(height: 30),

                              // PAYMENT INFORMATION
                              const Text(
                                "Informações de pagamento",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // CARD TYPES
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => cubit.selectPaymentMethod(
                                      PaymentMethod.mastercard,
                                    ),
                                    child: CheckoutCardTypeSelector(
                                      label: "Mastercard",
                                      selected:
                                          state.selectedPaymentMethod ==
                                          PaymentMethod.mastercard,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () => cubit.selectPaymentMethod(
                                      PaymentMethod.visa,
                                    ),
                                    child: CheckoutCardTypeSelector(
                                      label: "Visa",
                                      selected:
                                          state.selectedPaymentMethod ==
                                          PaymentMethod.visa,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () => cubit.selectPaymentMethod(
                                      PaymentMethod.homepay,
                                    ),
                                    child: CheckoutCardTypeSelector(
                                      label: "HomePay",
                                      selected:
                                          state.selectedPaymentMethod ==
                                          PaymentMethod.homepay,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              CheckoutLabel(text: "Nome no cartão"),
                              CheckoutInputBox(
                                controller: _nameOnCardController,
                                hint: "João da Silva",
                                validator: isNotEmpty,
                              ),
                              const SizedBox(height: 20),

                              CheckoutLabel(text: "Número do cartão"),
                              CheckoutInputBox(
                                controller: _cardNumberController,
                                hint: "0000 0000 0000 0000",
                                validator: validateCardNumber,
                                inputFormatters: [CardNumberFormatter()],
                              ),
                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CheckoutLabel(text: "Validade"),
                                        CheckoutInputBox(
                                          controller: _expirationController,
                                          hint: "MM/AA",
                                          validator: validateExpirationDate,
                                          inputFormatters: [
                                            ExpirationDateFormatter(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CheckoutLabel(text: "CVV"),
                                        CheckoutInputBox(
                                          controller: _cvvController,
                                          hint: "123",
                                          validator: validateCVV,
                                          inputFormatters: [CVVFormatter()],
                                        ),
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
                                    onPressed: () {
                                      context.goNamed(NamedRoute.homePage);
                                    },
                                    child: const Text("Voltar"),
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
                                    onPressed:
                                        state.status == CheckoutStatus.loading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              cubit.confirmPayment();
                                            }
                                          },
                                    child:
                                        state.status == CheckoutStatus.loading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            "Confirmar Pagamento  R\$${state.total.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Resumo do Pedido",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => cubit.clearCart(),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  tooltip: "Limpar Carrinho",
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            if (state.items.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text("Seu carrinho está vazio."),
                              )
                            else
                              ...state.items.map(
                                (item) => CheckoutOrderItem(
                                  title: item.product.name,
                                  price: item.product.price,
                                  quantity: item.quantity,
                                  onAdd: () => cubit.addItem(item.product),
                                  onRemove: () =>
                                      cubit.removeItem(item.product),
                                ),
                              ),
                            const SizedBox(height: 16),
                            CheckoutTotalRow(
                              label: "Entrega",
                              value:
                                  "R\$${state.deliveryFee.toStringAsFixed(2)}",
                            ),
                            CheckoutTotalRow(
                              label: "Desconto",
                              value: "R\$${state.discount.toStringAsFixed(2)}",
                            ),
                            const SizedBox(height: 8),
                            CheckoutTotalRow(
                              label: "Total (s/ impostos)",
                              value:
                                  "R\$${(state.subtotal - state.discount).toStringAsFixed(2)}",
                            ),
                            CheckoutTotalRow(
                              label: "Impostos",
                              value: "R\$${state.tax.toStringAsFixed(2)}",
                            ),

                            const Divider(height: 40),

                            CheckoutTotalRow(
                              label: "Total do Pedido",
                              value: "R\$${state.total.toStringAsFixed(2)}",
                              bold: true,
                            ),
                            const SizedBox(height: 20),

                            if (state.savings > 0)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xffd2f5d7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Você economizou: R\$${state.savings.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Color(0xff2b8c41),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _couponController,
                                    decoration: InputDecoration(
                                      hintText: "Código do cupom",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                    ),
                                    enabled: state.couponCode == null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: state.couponCode != null
                                      ? null
                                      : () {
                                          if (_couponController
                                              .text
                                              .isNotEmpty) {
                                            cubit.applyCoupon(
                                              _couponController.text,
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 20,
                                    ),
                                  ),
                                  child: Text(
                                    state.couponCode != null
                                        ? "Aplicado"
                                        : "Aplicar",
                                  ),
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
          ),
        );
      },
    );
  }
}
