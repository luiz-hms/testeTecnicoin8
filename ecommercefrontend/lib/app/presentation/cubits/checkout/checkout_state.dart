part of 'checkout_cubit.dart';

enum PaymentMethod { mastercard, visa, homepay }

enum DeliveryMethod { delivery, pickup }

enum CheckoutStatus { initial, loading, success, error }

abstract class CheckoutState {
  final List<CartItem> items;
  final double deliveryFee;
  final double taxRate;
  final String? couponCode;
  final PaymentMethod selectedPaymentMethod;
  final DeliveryMethod selectedDeliveryMethod;
  final CheckoutStatus status;

  const CheckoutState({
    required this.items,
    this.deliveryFee = 16.99,
    this.taxRate = 0.023, // 2.3%
    this.couponCode,
    this.selectedPaymentMethod = PaymentMethod.mastercard,
    this.selectedDeliveryMethod = DeliveryMethod.delivery,
    this.status = CheckoutStatus.initial,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);

  // Desconto de 10% se cupom válido
  double get discount =>
      couponCode != null && couponCode!.isNotEmpty ? subtotal * 0.10 : 0.0;

  double get tax => (subtotal - discount) * taxRate;

  double get total => subtotal - discount + deliveryFee + tax;

  double get savings => items.fold(
    0.0,
    (sum, item) =>
        sum + ((item.product.oldPrice - item.product.price) * item.quantity),
  );

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial() : super(items: const []);
}

class CheckoutUpdated extends CheckoutState {
  const CheckoutUpdated({
    required super.items,
    super.deliveryFee,
    super.taxRate,
    super.couponCode,
    super.selectedPaymentMethod,
    super.selectedDeliveryMethod,
    super.status,
  });

  CheckoutUpdated copyWith({
    List<CartItem>? items,
    double? deliveryFee,
    double? taxRate,
    String? couponCode,
    bool clearCoupon = false,
    PaymentMethod? selectedPaymentMethod,
    DeliveryMethod? selectedDeliveryMethod,
    CheckoutStatus? status,
  }) {
    return CheckoutUpdated(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxRate: taxRate ?? this.taxRate,
      couponCode: clearCoupon ? null : (couponCode ?? this.couponCode),
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedDeliveryMethod:
          selectedDeliveryMethod ?? this.selectedDeliveryMethod,
      status: status ?? this.status,
    );
  }
}
