class CompendiumEditorDescriptor {
  final String entityType;
  final String collectionKey;
  final String label;
  final List<CompendiumFieldDescriptor> fields;

  const CompendiumEditorDescriptor({
    required this.entityType,
    required this.collectionKey,
    required this.label,
    this.fields = const [],
  });
}

enum CompendiumFieldKind {
  string,
  integer,
  number,
  boolean,
  object,
  list,
  dynamic,
}

class CompendiumFieldDescriptor {
  final String key;
  final String label;
  final CompendiumFieldKind kind;
  final bool required;
  final bool nullable;
  final bool isArray;
  final List<String> choices;
  final List<CompendiumFieldDescriptor> fields;
  final CompendiumFieldDescriptor? itemDescriptor;
  final int sampleCount;

  const CompendiumFieldDescriptor({
    required this.key,
    required this.label,
    required this.kind,
    this.required = false,
    this.nullable = true,
    this.isArray = false,
    this.choices = const [],
    this.fields = const [],
    this.itemDescriptor,
    this.sampleCount = 0,
  });
}

class CompendiumDraftEntity {
  final String entityType;
  final String collectionKey;
  final String id;
  final String name;
  final String source;
  final String sourceFile;
  final String? edition;
  final Map<String, dynamic> data;
  final Map<String, dynamic> extra;

  const CompendiumDraftEntity({
    required this.entityType,
    required this.collectionKey,
    required this.id,
    required this.name,
    required this.source,
    required this.sourceFile,
    required this.edition,
    required this.data,
    this.extra = const {},
  });
}
