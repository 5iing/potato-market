class FormatUtils {
  /// 숫자를 천 단위 콤마가 포함된 문자열로 변환
  static String formatPrice(int? price) {
    if (price == null || price == 0) {
      return '가격 문의';
    }

    return '${_addCommas(price)}원';
  }

  /// 숫자에 천 단위 콤마 추가
  static String _addCommas(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }

  /// DateTime을 상대 시간으로 변환
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '방금 전';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}
