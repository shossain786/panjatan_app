// Category Enum
// ignore_for_file: constant_identifier_names

enum Category {
  Imaan,
  Namaaz,
  Roza,
  Hajj,
  Zakaat,
  Taharat,
  Others,
}

// Category Helper Class
class CategoryHelper {
  // Convert Category enum to String
  static String getCategoryName(Category category) {
    switch (category) {
      case Category.Imaan:
        return 'Imaan';
      case Category.Namaaz:
        return 'Namaaz';
      case Category.Roza:
        return 'Roza';
      case Category.Hajj:
        return 'Hajj';
      case Category.Zakaat:
        return 'Zakaat';
      case Category.Taharat:
        return 'Taharat';
      case Category.Others:
        return 'Others';
      }
  }

  // Convert String to Category enum
  static Category getCategoryFromString(String categoryName) {
    switch (categoryName) {
      case 'Imaan':
        return Category.Imaan;
      case 'Namaaz':
        return Category.Namaaz;
      case 'Roza':
        return Category.Roza;
      case 'Hajj':
        return Category.Hajj;
      case 'Zakaat':
        return Category.Zakaat;
      case 'Taharat':
        return Category.Taharat;
      case 'Others':
        return Category.Others;
      default:
        throw ArgumentError('Invalid category: $categoryName');
    }
  }

  // Get all category values as a List of Strings
  static List<String> getAllCategories() {
    return Category.values
        .map((category) => getCategoryName(category))
        .toList();
  }
}
