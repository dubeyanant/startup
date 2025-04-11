class CurrencyConversion {
  // Format Indian rupee in lkhs and crores
  static String formatCurrency(int amount) {
    if (amount >= 1e5) {
      return '₹${(amount / 1e5).toStringAsFixed(2)} Lakh';
    } else if (amount >= 1e7) {
      return '₹${(amount / 1e7).toStringAsFixed(2)} Crore';
    } else {
      return '₹$amount';
    }
  }
}
