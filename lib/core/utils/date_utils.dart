extension DateUtils on DateTime {
  String timeLeft() {
    final now = DateTime.now();
    if (isBefore(now)) {
      return "time's up";
    }

    final difference = this.difference(now);

    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return "$months ${months == 1 ? "month" : "months"} left";
    }

    return "${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} left";
  }
}
