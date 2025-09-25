class Category {
  final String id;
  final String name;
  final String type; // 'income' | 'expense'
  final String color;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
  });
}
