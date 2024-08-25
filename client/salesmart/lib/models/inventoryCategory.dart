// lib/models/item_category.dart

// Define the ItemCategory enum
enum ItemCategory { electronics, groceries, clothing, others }

// Define the ItemCategoryExtension to add utility methods
extension ItemCategoryExtension on ItemCategory {
  // Method to convert enum to string
  String get name {
    switch (this) {
      case ItemCategory.electronics:
        return 'Electronics';
      case ItemCategory.groceries:
        return 'Groceries';
      case ItemCategory.clothing:
        return 'Clothing';
      case ItemCategory.others:
        return 'Others';
    }
  }

  // Static method to convert string to enum
  static ItemCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return ItemCategory.electronics;
      case 'groceries':
        return ItemCategory.groceries;
      case 'clothing':
        return ItemCategory.clothing;
      default:
        return ItemCategory.others;
    }
  }
}
