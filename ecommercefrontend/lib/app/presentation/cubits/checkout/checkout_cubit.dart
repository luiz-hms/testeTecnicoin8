import 'package:bloc/bloc.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/product.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutInitial());

  /// Adiciona um produto ao carrinho
  void addItem(Product product) {
    final currentItems = List<CartItem>.from(state.items);

    // Verifica se o produto já está no carrinho
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // Incrementa a quantidade
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Adiciona novo item
      currentItems.add(CartItem(product: product, quantity: 1));
    }

    _emitUpdatedState(items: currentItems);
  }

  /// Remove uma unidade do produto do carrinho
  void removeItem(Product product) {
    final currentItems = List<CartItem>.from(state.items);

    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      final existingItem = currentItems[existingIndex];

      if (existingItem.quantity > 1) {
        // Decrementa a quantidade
        currentItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
      } else {
        // Remove o item completamente
        currentItems.removeAt(existingIndex);
      }

      _emitUpdatedState(items: currentItems);
    }
  }

  /// Atualiza a quantidade de um item específico
  void updateQuantity(String productId, int quantity) {
    final currentItems = List<CartItem>.from(state.items);

    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (existingIndex != -1) {
      if (quantity > 0) {
        currentItems[existingIndex] = currentItems[existingIndex].copyWith(
          quantity: quantity,
        );
      } else {
        currentItems.removeAt(existingIndex);
      }

      _emitUpdatedState(items: currentItems);
    }
  }

  /// Remove completamente um produto do carrinho
  void removeProduct(String productId) {
    final currentItems = List<CartItem>.from(state.items);
    currentItems.removeWhere((item) => item.product.id == productId);

    _emitUpdatedState(items: currentItems);
  }

  /// Limpa todo o carrinho
  void clearCart() {
    emit(const CheckoutUpdated(items: []));
  }

  /// Obtém a quantidade de um produto específico
  int getProductQuantity(String productId) {
    final item = state.items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: Product(id: '', name: '', price: 0, oldPrice: 0),
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  /// Aplica cupom de desconto (qualquer cupom aplica 10%)
  bool applyCoupon(String couponCode) {
    final trimmedCode = couponCode.trim().toUpperCase();

    if (trimmedCode.isNotEmpty) {
      if (state is CheckoutUpdated) {
        emit((state as CheckoutUpdated).copyWith(couponCode: trimmedCode));
      } else {
        emit(CheckoutUpdated(items: state.items, couponCode: trimmedCode));
      }
      return true;
    }

    return false;
  }

  /// Remove cupom aplicado
  void removeCoupon() {
    if (state is CheckoutUpdated) {
      emit((state as CheckoutUpdated).copyWith(clearCoupon: true));
    }
  }

  /// Seleciona método de pagamento
  void selectPaymentMethod(PaymentMethod method) {
    if (state is CheckoutUpdated) {
      emit((state as CheckoutUpdated).copyWith(selectedPaymentMethod: method));
    } else {
      emit(CheckoutUpdated(items: state.items, selectedPaymentMethod: method));
    }
  }

  /// Seleciona método de entrega
  void selectDeliveryMethod(DeliveryMethod method) {
    if (state is CheckoutUpdated) {
      emit((state as CheckoutUpdated).copyWith(selectedDeliveryMethod: method));
    } else {
      emit(CheckoutUpdated(items: state.items, selectedDeliveryMethod: method));
    }
  }

  /// Confirma o pagamento
  Future<void> confirmPayment() async {
    if (state is CheckoutUpdated) {
      emit((state as CheckoutUpdated).copyWith(status: CheckoutStatus.loading));
    } else {
      emit(
        CheckoutUpdated(
          items: state.items,
          status: CheckoutStatus.loading,
          couponCode: state.couponCode,
          selectedDeliveryMethod: state.selectedDeliveryMethod,
          selectedPaymentMethod: state.selectedPaymentMethod,
        ),
      );
    }

    // Simula processamento
    await Future.delayed(const Duration(seconds: 2));

    // Sucesso
    emit(
      CheckoutUpdated(
        items: [],
        status: CheckoutStatus.success,
        couponCode: null, // Limpa cupom
        selectedDeliveryMethod: state.selectedDeliveryMethod,
        selectedPaymentMethod: state.selectedPaymentMethod,
      ),
    );
  }

  /// Helper para emitir estado atualizado preservando outras propriedades
  void _emitUpdatedState({List<CartItem>? items}) {
    if (state is CheckoutUpdated) {
      emit((state as CheckoutUpdated).copyWith(items: items));
    } else {
      emit(
        CheckoutUpdated(
          items: items ?? state.items,
          couponCode: state.couponCode,
          selectedDeliveryMethod: state.selectedDeliveryMethod,
          selectedPaymentMethod: state.selectedPaymentMethod,
        ),
      );
    }
  }
}
