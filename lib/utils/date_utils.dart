DateTime safeParseDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) {
    return DateTime(1970);
  }
  try {
    return DateTime.parse(dateStr);
  } catch (_) {
    print("⚠️ Invalid date format: $dateStr");
    return DateTime(1970);
  }
}
