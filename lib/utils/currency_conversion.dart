class CurrencyConversion {
  // Format Indian rupee in lkhs and crores
  static String formatCurrency(int amount) {
    if (amount >= 1e5) {
      return '₹${(amount / 1e5).toStringAsFixed(2)} Lk';
    } else if (amount >= 1e7) {
      return '₹${(amount / 1e7).toStringAsFixed(2)} Cr';
    } else {
      return '₹$amount';
    }
  }
}
