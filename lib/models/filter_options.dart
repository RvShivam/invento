// lib/models/filter_options.dart

enum SortOption { nameAZ, stockHighToLow, stockLowToHigh }
enum FilterStatus { all, lowStock, outOfStock }

// A class to hold all the selected filter and sort options
class FilterOptions {
  SortOption sortOption;
  FilterStatus filterStatus;
  String? category;
  String? supplier;

  FilterOptions({
    this.sortOption = SortOption.nameAZ,
    this.filterStatus = FilterStatus.all,
    this.category,
    this.supplier,
  });
}